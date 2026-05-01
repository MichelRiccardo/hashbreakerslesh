#!/bin/bash

# =========================================
#  HASHE_SLESH (HashBreakerSlesh)
#  Advanced Password Recovery Tool
# -----------------------------------------
#  Author : MichelRiccardo
#  GitHub : https://github.com/MichelRiccardo
#  Version: 1.0
# =========================================

# ===== CONFIG =====
DEFAULT_WORDLIST="/usr/share/wordlists/rockyou.txt"
RULES="/usr/share/hashcat/rules/best64.rule"

# ===== CORES =====
G="\e[32m"; R="\e[31m"; Y="\e[33m"; C="\e[36m"; N="\e[0m"

WORDLISTS=()

# ===== BANNER FIXO (SEM ANIMAÇÃO) =====
banner() {
clear

echo -e "$G"
echo "██╗  ██╗ █████╗ ███████╗██╗  ██╗███████╗"
echo "██║  ██║██╔══██╗██╔════╝██║  ██║██╔════╝"
echo "███████║███████║███████╗███████║█████╗  "
echo "██╔══██║██╔══██║╚════██║██╔══██║██╔══╝  "
echo "██║  ██║██║  ██║███████║██║  ██║███████╗"
echo "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝"
echo ""
echo "           HASHE_SLESH"
echo -e "$N"

echo "============================================="
echo "  HASHE_SLESH (HashBreakerSlesh)"
echo "  Advanced Password Recovery Tool"
echo " -----------------------------------------"
echo "  Author : MichelRiccardo"
echo "  GitHub : https://github.com/MichelRiccardo"
echo "  Version: 2.0"
echo "============================================="

echo "================================="
echo " Advanced Password Recovery Tool"
echo "================================="
echo ""
echo -e "$C GitHub:$N https://github.com/MichelRiccardo"
echo ""
}

# ===== LOADING =====
loading() {
msg="$1"
echo -ne "$G[+] $msg$N"
for i in {1..3}; do
  echo -n "."
  sleep 0.2
done
echo ""
}

# ===== CHECK =====
check() {
command -v hashcat >/dev/null || {
  echo -e "$R[!] Instale hashcat$N"
  exit 1
}
}

# ===== MENU =====
menu() {
echo -e "$G=================================$N"
echo -e "$G        MENU PRINCIPAL        $N"
echo -e "$G=================================$N"

echo "1) Rockyou"
echo "2) Custom"
echo "3) Multi"
echo ""
read -p "Escolha: " opt
}

# ===== WORDLIST =====
choose_wordlists() {
case $opt in
1) WORDLISTS=("$DEFAULT_WORDLIST") ;;
2)
read -p "Caminho: " wl
[ ! -f "$wl" ] && { echo -e "$R[!] Não encontrada$N"; exit; }
WORDLISTS=("$wl")
;;
3)
echo "Digite caminhos:"
read -a wls
for w in "${wls[@]}"; do
[ ! -f "$w" ] && { echo -e "$R[!] Não encontrada: $w$N"; exit; }
WORDLISTS+=("$w")
done
;;
*) echo -e "$R[!] Opção inválida$N"; exit ;;
esac

echo -e "$G[+] Wordlists carregadas:$N"
printf '%s\n' "${WORDLISTS[@]}"
}

# ===== PATH =====
BASE="$HOME/pentest/results/$(date +%F-%H%M)"
HASHDIR="$BASE/hashes"
REPORTDIR="$BASE/report"

mkdir -p "$HASHDIR" "$REPORTDIR"

# ===== LIMPAR ENTRADA =====
clean_input() {
read -p "Arquivo de hashes: " file
[ ! -f "$file" ] && { echo -e "$R[!] Arquivo inválido$N"; exit; }

CLEAN="$BASE/clean.txt"
cat "$file" | tr -d '\r' | tr -d ' ' > "$CLEAN"
}

# ===== DETECT =====
detect() {
h="$1"

[[ "$h" =~ ^[a-fA-F0-9]{32}$ ]] && echo "md5 0" && return
[[ "$h" =~ ^[a-fA-F0-9]{40}$ ]] && echo "sha1 100" && return
[[ "$h" =~ ^[a-fA-F0-9]{64}$ ]] && echo "sha256 1400" && return
[[ "$h" =~ ^[a-fA-F0-9]{128}$ ]] && echo "sha512 1700" && return
[[ "$h" =~ ^\$2 ]] && echo "bcrypt 3200" && return

echo "unknown -1"
}

# ===== SPLIT =====
split_hashes() {
loading "Separando hashes"
rm -f "$HASHDIR"/*.txt

while read -r h; do
res=$(detect "$h")
type=$(echo $res | cut -d' ' -f1)

case "$type" in
md5|sha1|sha256|sha512|bcrypt)
echo "$h" >> "$HASHDIR/$type.txt"
;;
*)
echo -e "$Y[!] Ignorado: $h$N"
;;
esac

done < "$CLEAN"
}

# ===== ATAQUE =====
run() {
file="$1"
mode="$2"
name="$3"

[ ! -s "$file" ] && { echo -e "$Y[!] Sem $name$N"; return; }

loading "Atacando $name"

for wl in "${WORDLISTS[@]}"; do
hashcat -a 0 -m "$mode" "$file" "$wl" -r "$RULES" --quiet
done

echo -e "$G[+] Senhas encontradas ($name):$N"
hashcat -m "$mode" "$file" --show | tee "$REPORTDIR/${name}.txt"
}

# ===== MAIN =====
banner
check

echo -e "$C[+] Salvando em: $BASE$N"

menu
choose_wordlists
clean_input
split_hashes

run "$HASHDIR/md5.txt" 0 md5
run "$HASHDIR/sha1.txt" 100 sha1
run "$HASHDIR/sha256.txt" 1400 sha256
run "$HASHDIR/sha512.txt" 1700 sha512
run "$HASHDIR/bcrypt.txt" 3200 bcrypt

loading "Finalizando"

echo -e "$G\n[✔] Finalizado! Resultados em:$N $BASE"
