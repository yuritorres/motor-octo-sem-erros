#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

print_header() {
  echo "==== motor-octo-sem-erros ===="
  echo "Ferramenta central para instalar e gerenciar Docker e Portainer BE."
  echo
}

usage() {
  cat <<EOF
Uso: ./motor-octo.sh [comando]

Comandos disponíveis:
  docker       Instala e configura Docker no Ubuntu Server
  portainer    Instala e sobe o Portainer BE usando Docker
  all          Instala Docker e Portainer BE
  help         Mostra esta ajuda

Se nenhum comando for informado, será exibido um menu interativo.
EOF
}

require_script() {
  local script_path="$1"
  if [ ! -x "$script_path" ]; then
    if [ -f "$script_path" ]; then
      chmod +x "$script_path"
    else
      echo "Script não encontrado: $script_path"
      echo "Certifique-se de estar na raiz do repositório e que a pasta 'scripts/' existe."
      exit 1
    fi
  fi
}

install_docker() {
  print_header
  echo "[1/2] Instalação do Docker..."
  local script="$SCRIPTS_DIR/instalar-docker-ubuntu.sh"
  require_script "$script"
  "$script"
  echo "[2/2] Docker instalado/atualizado."
}

install_portainer() {
  print_header
  echo "Instalação do Portainer BE..."
  local script="$SCRIPTS_DIR/instalar-portainer-be.sh"
  require_script "$script"
  "$script"
}

install_all() {
  install_docker
  install_portainer
}

interactive_menu() {
  print_header
  echo "Selecione uma opção:"
  echo "  1) Instalar Docker"
  echo "  2) Instalar Portainer BE"
  echo "  3) Instalar Docker + Portainer BE"
  echo "  0) Sair"
  echo
  read -rp "Opção: " opt

  case "$opt" in
    1) install_docker ;;
    2) install_portainer ;;
    3) install_all ;;
    0) echo "Saindo..."; exit 0 ;;
    *) echo "Opção inválida"; exit 1 ;;
  esac
}

main() {
  case "$1" in
    docker)
      install_docker
      ;;
    portainer)
      install_portainer
      ;;
    all)
      install_all
      ;;
    help|-h|--help)
      print_header
      usage
      ;;
    "")
      interactive_menu
      ;;
    *)
      echo "Comando desconhecido: $1"
      echo
      usage
      exit 1
      ;;
  esac
}

main "$@"
