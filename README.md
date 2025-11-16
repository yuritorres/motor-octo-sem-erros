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

## Ferramenta central (motor-octo.sh)

Este repositório inclui uma ferramenta central na raiz para facilitar o uso dos scripts:

```bash
chmod +x motor-octo.sh
./motor-octo.sh
```

Ela mostra um menu com opções:

- **1** – Instalar Docker
- **2** – Instalar Portainer BE
- **3** – Instalar Docker + Portainer BE
- **0** – Sair

Também é possível chamar diretamente por subcomandos:

```bash
./motor-octo.sh docker      # instala/configura Docker
./motor-octo.sh portainer   # instala Portainer BE
./motor-octo.sh all         # Docker + Portainer BE
./motor-octo.sh help        # ajuda
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
```

## Instalar Portainer BE (Business Edition)

Portainer BE é uma interface web para gerenciar ambientes Docker. Antes de instalar, garanta que o Docker já está instalado e em execução.

### Usando o script deste repositório

Se você clonou o repositório ou baixou os scripts:

```bash
chmod +x scripts/instalar-portainer-be.sh
./scripts/instalar-portainer-be.sh
```

### Usando apenas Docker (sem script)

Criar o volume que o Portainer usará para armazenar a base de dados:

```bash
docker volume create portainer_data
```

Baixar e instalar o container do Portainer Server (BE):

```bash
docker run -d -p 8000:8000 -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ee:lts
```

Por padrão, o Portainer gera e usa um certificado SSL autoassinado na porta `9443`. Acesse:

```text
https://<IP_DO_SERVIDOR>:9443
```

Na primeira vez, você deverá criar o usuário `admin` e informar/ativar a licença BE (conforme o plano contratado).