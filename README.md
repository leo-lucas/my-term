# Como Configurar o Tmux com a Configuração Disponível

Este diretório contém um arquivo de configuração para o `tmux`, um terminal multiplexor. Siga as instruções abaixo para usar essa configuração.

## Requisitos
- O `tmux` deve estar instalado no seu sistema. Caso não tenha, instale via:
- Python 3 disponível no PATH (macOS e Linux já incluem ou podem instalar via package manager).

### Linux (Debian/Ubuntu)
```bash
sudo apt update
sudo apt install tmux
```

### MacOS
```bash
tmux --version  # Verifica se já está instalado
Se não estiver, use:
brew install tmux
```

### Windows (WSL ou com tmux instalado)
Certifique-se de ter o `tmux` instalado no ambiente WSL ou via [Git for Windows](https://git-scm.com/download/win).

## Instalação (recomendado)

Execute o script de instalação para copiar a configuração:
```bash
./install.sh
```

## Instalação sem clonar o repositório

Copie e cole o comando abaixo para baixar e executar o instalador direto do GitHub:
```bash
curl -fsSL https://raw.githubusercontent.com/leo-lucas/my-term/main/install-from-github.sh | bash
```

Depois, recarregue o tmux:
```bash
tmux source-file ~/.tmux.conf
```

## Instalação do Neovim

O script de instalação também inclui a instalação do Neovim com sua configuração personalizada. O script irá:
- Instalar o Neovim (se não estiver instalado)
- Substituir a configuração existente em ~/.config/nvim
- Clonar a configuração do repositório https://github.com/leo-lucas/my-nvim
- Instalar os plugins automaticamente

## Instalação do OpenCode

O script de instalação também inclui a instalação do OpenCode com sua configuração personalizada. O script irá:
- Instalar o OpenCode via npm (se não estiver instalado)
- Substituir a configuração existente em ~/.config/opencode
- Clonar a configuração do repositório https://github.com/leo-lucas/my-opencode
- Instalar as dependências automaticamente

## Instalação via curl

Você também pode instalar o OpenCode diretamente via curl:
```bash
curl -fsSL https://opencode.ai/install | bash
```

O script também configura o `zsh`, instala o Oh My Zsh e aplica o tema Spaceship (macOS e Linux). Caso falte algum requisito (como gerenciador de pacotes ou Python 3), ele informará o que precisa ser instalado.

## Instruções (manual)

1. **Crie um diretório para suas sessões** (opcional, mas recomendado):
   ```bash
   mkdir -p ~/.tmux-sessions
   ```

2. **Copia a configuração para o diretório padrão do tmux**:
   Copie o arquivo `.tmux.conf` para o diretório `~/.tmux.conf`: 
   ```bash
   cp ./.tmux.conf ~/.tmux.conf
   ```

3. **Atualize seu shell**:
   Reinicie o shell atual ou feche e abra um novo terminal.

4. **Carregue a configuração**:
   Execute o comando abaixo para carregar a configuração:
   ```bash
   tmux source-file ~/.tmux.conf && tmux
   ```

## Comandos Úteis do Tmux

- **Abrir uma nova sessão**:
  ```bash
tmux new -s nome-da-sessao
  ```

- **Listar sessões**:
  ```bash
tmux ls
  ```

- **Ativar sessão**:
  ```bash
tmux attach -t nome-da-sessao
  ```

- **Fechar sessão**:
  ```bash
tmux kill-session -t nome-da-sessao
  ```

## Troubleshooting

- **Se a configuração não carregar corretamente**, verifique se não há conflitos com outras configurações.
- **Para debugar**, rode:
  ```bash
tmux source-file ~/.tmux.conf -o show-server-info
  ```

---
