# 🔥 HashBreakerSlesh PRO

Ferramenta automatizada de cracking de hashes para auditoria de senhas.

Desenvolvida para uso em testes de segurança (pentest), ela detecta automaticamente múltiplos tipos de hash, separa, executa ataques e gera relatórios.

---

## 🧠 Funcionalidades

- 🔍 Detecção automática de hashes
- 📂 Separação por tipo
- ⚡ Execução automática com Hashcat
- 🔥 Suporte a:
  - MD5
  - SHA1
  - SHA256
  - SHA512
  - NTLM
  - bcrypt
- 📊 Relatório de senhas quebradas
- 🧠 Pipeline completo:
  - Wordlist
  - Rules
  - Hybrid
  - Mask

---

## ⚙️ Requisitos

Sistema baseado em Linux (recomendado: Parrot OS ou Kali Linux)

Instalar dependências:

```bash
sudo apt update
sudo apt install hashcat wordlists -y
