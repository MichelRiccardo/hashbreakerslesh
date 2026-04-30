#!/bin/bash

BASE=~/pentest
RESULTS="$BASE/results"
WORDLIST="/usr/share/wordlists/rockyou.txt"
RULES="/usr/share/hashcat/rules/best64.rule"

mkdir -p "$RESULTS"

banner() {
  clear
  echo -e "\e[32m"
  echo "██╗  ██╗ █████╗ ███████╗██╗  ██╗"
  echo "██║  ██║██╔══██╗██╔════╝██║  ██║"
  echo "███████║███████║███████╗███████║"
  echo "██╔══██║██╔══██║╚════██║██╔══██║"
  echo "██║  ██║██║  ██║███████║██║  ██║"
  echo "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
  echo -e "\e[0m"
  echo ""
  echo -e "\e[35mHashBreakerSlesh PRO v1.0\e[0m"
  echo -e "\e[36mGitHub:\e[0m https://github.com/MichelRiccardo"
  echo ""
}

check_wordlist() {
  if [ ! -f "$WORDLIST" ]; then
    echo "[!] Wordlist nao encontrada, tentando corrigir..."
    if [ -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
      sudo gzip -d /usr/share/wordlists/rockyou.txt.gz
    fi
  fi

  if [ ! -f "$WORDLIST" ]; then
    echo "[!] Falha: wordlist nao encontrada"
    exit 1
  fi
}

separar_hashes() {
  input="$1"
  outdir="$2"

  > "$outdir/md5.txt"
  > "$outdir/sha1.txt"
  > "$outdir/sha256.txt"
  > "$outdir/sha512.txt"
  > "$outdir/ntlm.txt"
  > "$outdir/bcrypt.txt"
  > "$outdir/unknown.txt"

  while read -r line; do
    hash=$(echo "$line" | tr -d ' \r\n')

    if [[ "$hash" =~ ^[a-f0-9]{32}$ ]]; then
      echo "$hash" >> "$outdir/md5.txt"

    elif [[ "$hash" =~ ^[a-f0-9]{40}$ ]]; then
      echo "$hash" >> "$outdir/sha1.txt"

    elif [[ "$hash" =~ ^[a-f0-9]{64}$ ]]; then
      echo "$hash" >> "$outdir/sha256.txt"

    elif [[ "$hash" =~ ^[a-f0-9]{128}$ ]]; then
      echo "$hash" >> "$outdir/sha512.txt"

    elif [[ "$hash" =~ ^\$2[aby]\$ ]]; then
      echo "$hash" >> "$outdir/bcrypt.txt"

    elif [[ "$hash" =~ ^[A-F0-9]{32}$ ]]; then
      echo "$hash" >> "$outdir/ntlm.txt"

    else
      echo "$hash" >> "$outdir/unknown.txt"
    fi

  done < "$input"
}

run_hashcat() {
  file="$1"
  mode="$2"
  name="$3"
  outdir="$4"

  out="$outdir/${name}_cracked.txt"

  # garante que o arquivo existe
  touch "$out"

  if [ ! -s "$file" ]; then
    echo "[!] No hashes for $name, skipping..."
    return
  fi

  echo "[+] Running $name..."

  hashcat -a 0 -m "$mode" "$file" "$WORDLIST" -o "$out" --quiet
  hashcat -a 0 -m "$mode" "$file" "$WORDLIST" -r "$RULES" -o "$out" --quiet
  hashcat -a 6 -m "$mode" "$file" "$WORDLIST" ?d?d -o "$out" --quiet

  if [ "$mode" -ne 3200 ]; then
    hashcat -a 3 -m "$mode" "$file" ?d?d?d?d?d?d -o "$out" --quiet
  fi
}

generate_report() {
  outdir="$1"
  report="$outdir/report.txt"

  echo "===== HASH REPORT =====" > "$report"

  for type in md5 sha1 sha256 sha512 ntlm bcrypt; do
    total=$(wc -l < "$outdir/$type.txt" 2>/dev/null)
    found=$(wc -l < "$outdir/${type}_cracked.txt" 2>/dev/null)

    [ -z "$total" ] && total=0
    [ -z "$found" ] && found=0

    percent=0
    if [ "$total" -gt 0 ]; then
      percent=$(awk "BEGIN {printf \"%.2f\", ($found/$total)*100}")
    fi

    echo "" >> "$report"
    echo "$type:" >> "$report"
    echo " total: $total" >> "$report"
    echo " cracked: $found" >> "$report"
    echo " percent: $percent %" >> "$report"
  done

  echo "" >> "$report"
  echo "[+] Report saved in: $report"
}

run() {
  read -p "Hash file: " hf
  hf=$(eval echo $hf)

  if [ ! -f "$hf" ]; then
    echo "[!] File not found"
    exit 1
  fi

  check_wordlist

  ts=$(date +%F-%H%M)
  outdir="$RESULTS/$ts"
  mkdir -p "$outdir"

  echo "[+] Separating hashes..."
  separar_hashes "$hf" "$outdir"

  run_hashcat "$outdir/md5.txt" 0 "md5" "$outdir"
  run_hashcat "$outdir/sha1.txt" 100 "sha1" "$outdir"
  run_hashcat "$outdir/sha256.txt" 1400 "sha256" "$outdir"
  run_hashcat "$outdir/sha512.txt" 1700 "sha512" "$outdir"
  run_hashcat "$outdir/ntlm.txt" 1000 "ntlm" "$outdir"
  run_hashcat "$outdir/bcrypt.txt" 3200 "bcrypt" "$outdir"

  generate_report "$outdir"
}

menu() {
  banner
  echo "1) Start audit"
  echo "2) Exit"
  read -p "Choice: " op

  case $op in
    1) run ;;
    2) exit ;;
    *) echo "Invalid option" ;;
  esac
}

menu
