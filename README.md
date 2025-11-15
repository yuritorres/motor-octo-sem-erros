# motor-octo-sem-erros

Ferramentas para facilitar a instalação e utilização do Docker em servidores Ubuntu.

## Requisitos

- Ubuntu Server suportado pela Docker (por exemplo: 20.04, 22.04)
- Usuário com permissão `sudo`
- `git` instalado para clonar o repositório

## Instalar git (caso não esteja instalado)

```bash
sudo apt update
sudo apt install -y git
```

## Clonar o projeto

```bash
git clone https://github.com/yuritorres/motor-octo-sem-erros.git
cd motor-octo-sem-erros
```

### Usar sem git (baixando só o script)

Se você não quiser instalar o `git`, pode baixar apenas o script de instalação diretamente do GitHub:

Com `curl`:

```bash
curl -fsSL -o instalar-docker-ubuntu.sh \
  https://raw.githubusercontent.com/yuritorres/motor-octo-sem-erros/main/scripts/instalar-docker-ubuntu.sh
chmod +x instalar-docker-ubuntu.sh
./instalar-docker-ubuntu.sh
```

Com `wget`:

```bash
wget -O instalar-docker-ubuntu.sh \
  https://raw.githubusercontent.com/yuritorres/motor-octo-sem-erros/main/scripts/instalar-docker-ubuntu.sh
chmod +x instalar-docker-ubuntu.sh
./instalar-docker-ubuntu.sh
```

## Instalar Docker no Ubuntu Server

Este projeto inclui um script que configura o repositório oficial da Docker e instala os pacotes necessários.

```bash
chmod +x scripts/instalar-docker-ubuntu.sh
./scripts/instalar-docker-ubuntu.sh
```

O script irá:

- Atualizar a lista de pacotes (`apt update`)
- Instalar dependências (`ca-certificates`, `curl`)
- Adicionar a chave GPG e o repositório oficial da Docker
- Instalar:
  - `docker-ce`
  - `docker-ce-cli`
  - `containerd.io`
  - `docker-buildx-plugin`
  - `docker-compose-plugin`
- Habilitar e iniciar o serviço `docker`

## Usar o Docker após a instalação

Opcionalmente, adicione seu usuário ao grupo `docker` para não precisar usar `sudo` em cada comando:

```bash
sudo usermod -aG docker $USER
# depois faça logout/login ou reinicie a sessão
```

Teste o Docker com um container simples:

```bash
docker run hello-world
```

## Atualizar Docker no futuro

Como o repositório oficial da Docker já estará configurado, futuras atualizações podem ser feitas com:

```bash
sudo apt update
sudo apt upgrade docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin