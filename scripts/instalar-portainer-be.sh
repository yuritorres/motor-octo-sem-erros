#!/usr/bin/env bash
set -e

echo "==== Instalação do Portainer BE (Business Edition) ===="

# Verifica se o Docker está instalado
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker não encontrado. Instale o Docker antes de rodar este script."
  exit 1
fi

# Verifica se o container já existe
if docker ps -a --format '{{.Names}}' | grep -q '^portainer$'; then
  echo "O container 'portainer' já existe. Nada a fazer."
  docker ps -a --filter "name=portainer" --format 'Nome: {{.Names}} | Status: {{.Status}}'
  exit 0
fi

echo "1/3: Criando volume portainer_data (se ainda não existir)..."
VOLUME_NAME=$(docker volume create portainer_data)
echo "Volume em uso: ${VOLUME_NAME}"

echo "2/3: Subindo container Portainer BE..."

docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ee:lts

echo "3/3: Verificando se o container está em execução..."
if ! docker ps --format '{{.Names}}' | grep -q '^portainer$'; then
  echo "O container 'portainer' não parece estar em execução. Verifique logs com:\n  docker logs portainer"
  exit 1
fi

echo
echo "==== Portainer BE instalado com sucesso! ===="
echo "Acesse via navegador:" 
echo "  https://<IP_DO_SERVIDOR>:9443" 
echo "Na primeira vez, você deverá criar o usuário admin e informar a licença BE (quando aplicável)."
