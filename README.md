# 🔥 HashBreakerSlesh PRO

Ferramenta automatizada de cracking de hashes para auditoria de segurança (pentest)

---

## 🧠 Descrição

O **HashBreakerSlesh PRO** automatiza o processo de análise e quebra de hashes, incluindo:

- detecção automática de tipos de hash  
- separação e organização dos dados  
- execução com Hashcat  
- geração de relatórios finais  

---

## ⚙️ Funcionalidades

🔍 Detecção automática de hashes  
📂 Separação por tipo de hash  
⚡ Execução automatizada com Hashcat  
  
  Visualizar Senha
  
  EXEMPLO:
  
  cat ~/DIRETORIO/SEU_USER/PASTA/*/sha1_cracked.txt
  cat ~/DIRETORIO/SEU_USER/PASTA/*/md5_cracked.txt
  cat ~/DIRETORIO/SEU_USER/PASTA/*/sha256_cracked.txt


---

### 🔥 Suporte a:

- MD5  
- SHA1  
- SHA256  
- SHA512  
- NTLM  
- bcrypt  

---

📊 Relatório de resultados (senhas quebradas)

---

## 🧠 Pipeline de ataque

- Wordlist attack  
- Rule-based attack  
- Hybrid attack  
- Mask attack  

---

## ⚙️ Requisitos

Sistema Linux (recomendado: Parrot OS ou Kali Linux)

```bash
sudo apt update
sudo apt install hashcat wordlists -y
https://github.com/MichelRiccardo/hashbreakerslesh.git
