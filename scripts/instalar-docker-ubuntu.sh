#!/usr/bin/env bash
set -e

echo "==== Instalação do Docker no Ubuntu (Server) ===="

# Verifica se é Ubuntu
if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [ "$ID" != "ubuntu" ]; then
    echo "Este script foi feito para Ubuntu. Distribuição detectada: $ID"
    exit 1
  fi
else
  echo "Não foi possível identificar a distribuição (arquivo /etc/os-release ausente)."
  exit 1
fi

echo "1/5: Atualizando lista de pacotes..."
sudo apt update -y

echo "2/5: Instalando dependências (ca-certificates, curl)..."
sudo apt install -y ca-certificates curl

echo "3/5: Configurando keyring da Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
else
  echo "Keyring /etc/apt/keyrings/docker.asc já existe, mantendo arquivo."
fi

echo "4/5: Adicionando repositório oficial da Docker..."
UBUNTU_SUITE=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")

sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_SUITE}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "Atualizando lista de pacotes com o novo repositório..."
sudo apt update -y

echo "5/5: Instalando Docker Engine e componentes..."
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo "Habilitando e iniciando o serviço docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Verificando instalação (docker --version)..."
docker --version || {
  echo "Algo deu errado ao executar 'docker --version'. Verifique os logs."
  exit 1
}

echo
echo "==== Docker instalado com sucesso! ===="
echo "Para usar o Docker sem sudo, adicione seu usuário ao grupo docker (logout/login após isso):"
echo "  sudo usermod -aG docker $USER"
