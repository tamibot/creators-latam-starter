# Prerrequisitos · Instalación manual

Guía para instalar los prerrequisitos **uno por uno**, sin usar `install.sh`. Útil si querés entender qué pasa en cada paso o si el script falla en algún bloque.

Para la guía completa end-to-end, ver [`INSTALL.md`](../INSTALL.md) en el root del repo.

---

## 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Tras la instalación, agregá al shell (Apple Silicon):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

**Verificar:** `brew --version`

---

## 2. git

Normalmente ya está. Si no:
```bash
xcode-select --install
```

**Verificar:** `git --version`

---

## 3. GitHub CLI

```bash
brew install gh
gh auth login
```

**Verificar:** `gh auth status`

---

## 4. Python 3.12+

```bash
brew install python@3.12
```

**Verificar:** `python3 --version`

---

## 5. uv (gestor Python de Astral)

```bash
brew install uv
```

O:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Verificar:** `uv --version`

---

## 6. nvm + Node LTS

```bash
brew install nvm
mkdir -p ~/.nvm
```

Agregar al `~/.zshrc`:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
```

Reabrir terminal o `source ~/.zshrc`. Después:
```bash
nvm install --lts
nvm use --lts
```

**Verificar:** `node --version && npm --version`

---

## 7. ffmpeg

Requerido por `yt-dlp` y `whisper.cpp` para manejar audio/video.

```bash
brew install ffmpeg
```

**Verificar:** `ffmpeg -version`

---

## 8. Docker Desktop

```bash
brew install --cask docker
```

**Importante:** abrí Docker.app manualmente desde `/Applications` la primera vez para aceptar permisos.

**Verificar:** `docker --version && docker ps`

---

## 9. Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

**Verificar:** `claude --version`

---

## Instalación de herramientas (después de prerrequisitos)

### Conversión de documentos
```bash
uv pip install --system marker-pdf 'markitdown[all]'
```

### Video / audio
```bash
brew install yt-dlp whisper-cpp
uv pip install --system google-genai

# Modelo whisper (opcional, ~1.5 GB)
mkdir -p ~/.whisper-cpp/models
bash <(curl -s https://raw.githubusercontent.com/ggerganov/whisper.cpp/master/models/download-ggml-model.sh) medium ~/.whisper-cpp/models
```

### Terminal productivity
```bash
brew install ripgrep fd bat fzf jq git-delta glow zoxide tree
```

Post-instalación, agregar al `~/.zshrc`:
```bash
eval "$(zoxide init zsh)"
source <(fzf --zsh)
```

---

## Validación final

Ver el bloque de validación en [`INSTALL.md`](../INSTALL.md#paso-8--validar-instalación) para un script que chequea todo.

---

## Links a las docs oficiales

| Herramienta | Docs |
|---|---|
| Homebrew | https://brew.sh/ |
| GitHub CLI | https://cli.github.com/ |
| Python | https://docs.python.org/3/ |
| uv | https://docs.astral.sh/uv/ |
| nvm | https://github.com/nvm-sh/nvm |
| Node.js | https://nodejs.org/ |
| Docker Desktop | https://docs.docker.com/desktop/ |
| ffmpeg | https://ffmpeg.org/documentation.html |
| Claude Code | https://docs.claude.com/en/docs/claude-code |
| marker | https://github.com/datalab-to/marker |
| markitdown | https://github.com/microsoft/markitdown |
| yt-dlp | https://github.com/yt-dlp/yt-dlp#installation |
| whisper.cpp | https://github.com/ggerganov/whisper.cpp |
| ripgrep | https://github.com/BurntSushi/ripgrep |
| fd | https://github.com/sharkdp/fd |
| bat | https://github.com/sharkdp/bat |
| fzf | https://github.com/junegunn/fzf |
| jq | https://jqlang.github.io/jq/ |
| delta | https://github.com/dandavison/delta |
| glow | https://github.com/charmbracelet/glow |
| zoxide | https://github.com/ajeetdsouza/zoxide |
