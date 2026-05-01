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
                                                                                     [ 196 linhas lidas ]
^H Ajuda         ^O Ler o arq     ^R Substituir    ^V Colar         ^G Ir p/ linha   ^Y Refazer       M-6 Copiar       ^B Onde estava   M-F Próxima      ▸ Avançar        ^▸ Prx palvr
^X Sair          ^F Onde está?    ^K Recortar      ^T Executar      ^Z Desfazer      M-A Marcar       M-] Parênteses   M-B Anterior     ◂ Voltar         ^◂ Palvr ant     ^A Início
