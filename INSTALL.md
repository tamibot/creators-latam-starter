# Guía de Instalación · Creators Latam Starter

Guía paso a paso desde una Mac recién abierta hasta tener el starter funcionando con Claude Code, los 15 agentes, 3 skills y todas las herramientas.

> **Tiempo estimado:** 20–40 minutos la primera vez (mayoría es descarga). Las próximas instalaciones tardan ~2 minutos porque Homebrew cachea todo.

---

## Resumen (para los apurados)

```bash
# 1. Clonar
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto

# 2. Instalar todo
./tooling/install.sh

# 3. Configurar credenciales
cp .env.example .env
# Editar .env con tus keys reales

# 4. Abrir Claude Code
claude
```

Si es tu primera vez o algo falla, seguí la guía completa abajo. 👇

---

## Pre-check · ¿qué ya tenés?

Antes de instalar nada, verificá qué hay en tu Mac:

```bash
# Copiá y pegá todo el bloque en terminal
echo "=== Herramientas del sistema ==="
for cmd in git gh brew python3 node npm uv docker ffmpeg; do
  if command -v $cmd &>/dev/null; then
    echo "✓ $cmd → $(command -v $cmd)"
  else
    echo "✗ $cmd → NO INSTALADO"
  fi
done
echo ""
echo "=== Claude Code ==="
command -v claude &>/dev/null && echo "✓ claude instalado" || echo "✗ claude NO instalado"
```

Según qué falte, saltá al paso correspondiente.

---

## Paso 1 · Homebrew (base de todo en Mac)

Si `brew --version` no devuelve nada, instalalo:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Te va a pedir la contraseña de tu Mac.** Es normal.

Al terminar, si estás en Mac con chip Apple Silicon, agregá al PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Verificación: `brew --version` debe devolver algo como `Homebrew 4.x.x`.

Más info: [brew.sh](https://brew.sh/)

---

## Paso 2 · git y GitHub CLI

### git
Casi siempre viene con Xcode Command Line Tools. Si `git --version` falla:
```bash
xcode-select --install
```
Aceptá el popup. Tarda ~5 min.

### GitHub CLI (`gh`)
```bash
brew install gh
gh auth login
```
- Elegí **GitHub.com**.
- Elegí **HTTPS**.
- Elegí **Login with a web browser** → te abre el navegador para aprobar.

Verificación: `gh auth status` debe decir `Logged in to github.com`.

Más info: [cli.github.com](https://cli.github.com/)

---

## Paso 3 · Clonar el starter

Elegí **dónde** querés que vivan tus proyectos. Recomendación: una carpeta madre por cliente.

```bash
mkdir -p ~/Desktop/Clientes/mi-cliente
cd ~/Desktop/Clientes/mi-cliente
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto
```

Si es un proyecto propio (no derivado del starter), podés despegarte del remote:
```bash
rm -rf .git && git init
```

---

## Paso 4 · Instalador automático

Ahora corré el script maestro:

```bash
./tooling/install.sh
```

Es **interactivo**: te pregunta bloque por bloque qué instalar. Si no sabés, decí `y` a todo.

**Cuándo te va a pedir autorización manual:**
1. Contraseña de Mac (Homebrew, Python).
2. Popup de `xcode-select --install` (si git no estaba).
3. `gh auth login` abre navegador.
4. Docker Desktop: abrirla manualmente una vez.
5. Al final, opcionalmente descargar modelo whisper (~1.5 GB).

Lo que instala (todo opcional — podés saltear bloques):

| Bloque | Paquetes |
|---|---|
| Prerrequisitos | Homebrew, git, gh, Python 3.12, uv, nvm+Node LTS, ffmpeg, Docker Desktop |
| Documentos | [`marker`](https://github.com/datalab-to/marker), [`markitdown`](https://github.com/microsoft/markitdown) |
| Video/Audio | [`yt-dlp`](https://github.com/yt-dlp/yt-dlp), [`whisper.cpp`](https://github.com/ggerganov/whisper.cpp), `google-genai` SDK |
| Terminal | ripgrep, fd, bat, fzf, jq, delta, glow, zoxide, tree |

Al terminar, corré `echo $SHELL`. Si es `/bin/zsh`, agregá a `~/.zshrc`:
```bash
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# zoxide (reemplaza cd)
eval "$(zoxide init zsh)"

# fzf (fuzzy finder)
source <(fzf --zsh)
```

Después: `source ~/.zshrc`.

---

## Paso 5 · Credenciales

```bash
cp .env.example .env
open -e .env   # abre en TextEdit
```

### ⚠️ Aclaración importante sobre `ANTHROPIC_API_KEY`

Si usás **Claude Code** como IDE, **NO necesitás** setear `ANTHROPIC_API_KEY` — Claude Code usa tu sesión de login (`claude` te pide auth la primera vez y listo).

Solo necesitás `ANTHROPIC_API_KEY` si:
- Vas a llamar a la API de Anthropic **desde código** (Python, Node, curl).
- Usás otro IDE que no sea Claude Code y que requiera la key.

### Lo que sí querés rellenar

```bash
# Gemini (para el skill video-a-texto — gratis)
GEMINI_API_KEY=AIza...
```

Otras keys van según el stack del cliente (definido en Fase 2 del Plan Maestro).

**Dónde conseguirlas:**
- Gemini (gratis): [aistudio.google.com/apikey](https://aistudio.google.com/apikey)
- Anthropic (si hace falta): [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys)
- OpenAI: [platform.openai.com/api-keys](https://platform.openai.com/api-keys)

**Regla crítica:** nunca commitees `.env` al repo. Ya está en `.gitignore`, pero el `credentials-manager` revisa igual antes de cada commit.

---

## Paso 6 · Claude Code

Si todavía no lo tenés:

```bash
npm install -g @anthropic-ai/claude-code
```

(Requiere que `nvm install --lts` haya corrido antes.)

Verificación: `claude --version`.

Más info: [claude.com/claude-code](https://claude.com/claude-code)

---

## Paso 7 · Primer arranque

Dentro de la carpeta del proyecto:

```bash
claude
```

Al abrir, Claude Code detecta automáticamente:
- `.claude/settings.json` → permisos preaprobados.
- `.claude/agents/*.md` → los 15 agentes.
- `.claude/skills/*/SKILL.md` → los 3 skills.
- `CLAUDE.md` → reglas del proyecto.

Probá estos comandos dentro de Claude Code para verificar:
- `/agents` → debería listar los 15.
- `/skills` → debería listar los 3.

**🎯 Primer mensaje para un proyecto nuevo:**

> *"Invocá al agente `onboarding-pm` para arrancar un proyecto nuevo. Vamos a completar las 3 fases del Plan Maestro."*

El `onboarding-pm` te va a guiar paso a paso por:
- Fase 1 → Entregables (qué recibe el cliente)
- Fase 2 → Stack Tecnológico (con research en foros)
- Fase 3 → Equipo y Plan (qué agentes, qué orden, Gantt)

Al terminar, tenés `documentation/plan-maestro.md` listo para firmar con el cliente.

---

## Paso 8 · Validar instalación

Corré este bloque para confirmar que todo quedó:

```bash
echo "=== Herramientas ==="
for cmd in brew git gh python3 uv node npm claude docker ffmpeg yt-dlp whisper-cli rg fd bat fzf jq; do
  if command -v $cmd &>/dev/null; then
    echo "✓ $cmd"
  else
    echo "✗ $cmd FALTA"
  fi
done

echo ""
echo "=== Paquetes Python ==="
python3 -c "import marker" 2>/dev/null && echo "✓ marker" || echo "✗ marker"
python3 -c "import markitdown" 2>/dev/null && echo "✓ markitdown" || echo "✗ markitdown"
python3 -c "from google import genai" 2>/dev/null && echo "✓ google-genai" || echo "✗ google-genai"

echo ""
echo "=== Estructura del proyecto ==="
for path in .claude/agents .claude/skills .claude/settings.json templates tooling/install.sh .env; do
  [ -e "$path" ] && echo "✓ $path" || echo "✗ $path FALTA"
done
```

Si algo dice `FALTA`, volvé al paso correspondiente.

---

## 🪟 Windows (sin detalle, guía general)

El instalador `install.sh` asume macOS. En Windows:

1. **Instalá `winget`** (viene con Windows 11).
2. **Abrí Claude Code o Cursor** y pedile:
   > *"Instalame lo que está en `tooling/install.sh` pero adaptado a Windows usando winget y pip. Saltá las partes que son específicas de macOS."*
3. Herramientas equivalentes disponibles en winget: `Git.Git`, `GitHub.cli`, `Python.Python.3.12`, `Astral.uv`, `OpenJS.NodeJS.LTS`, `Docker.DockerDesktop`, `yt-dlp.yt-dlp`, `Gyan.FFmpeg`.
4. Para `whisper.cpp` en Windows: seguir el [README del repo](https://github.com/ggerganov/whisper.cpp#quick-start).
5. En lugar de `brew install ripgrep fd bat fzf jq`, usá `scoop install ripgrep fd bat fzf jq` o `winget install BurntSushi.ripgrep.MSVC sharkdp.fd sharkdp.bat junegunn.fzf jqlang.jq`.

---

## 🐧 Linux (sin detalle, guía general)

En Linux usá `apt` (Debian/Ubuntu) o `dnf` (Fedora) en vez de `brew`:

```bash
sudo apt update && sudo apt install -y git gh python3 python3-pip nodejs npm docker.io ffmpeg yt-dlp ripgrep fd-find bat fzf jq
curl -LsSf https://astral.sh/uv/install.sh | sh   # uv
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash   # nvm
```

Pedile a tu IDE con IA que traduzca el resto de `tooling/install.sh` según tu distro.

---

## 🆘 Troubleshooting

### "command not found: brew" después de instalar Homebrew
→ Agregá Homebrew al PATH (ver Paso 1, segunda parte).

### Python 3 dice `externally-managed-environment`
→ Usá `uv` (más rápido y moderno): `uv pip install --system marker-pdf markitdown[all]`.
→ O `pip3 install --user <paquete>` con flag `--break-system-packages` si sabés lo que hacés.

### `claude` command not found
→ Instalá Node: `nvm install --lts`. Después `npm install -g @anthropic-ai/claude-code`.

### Docker Desktop no arranca
→ Abrilo manualmente desde Applications al menos una vez. Necesita aceptar permisos.

### El agente no aparece en `/agents`
→ Cerrá y abrí Claude Code. Los agentes se cargan al iniciar sesión.

### `marker` es muy lento la primera vez
→ Normal. Descarga modelos (~2 GB). Corridas siguientes son rápidas.

### Quiero actualizar el starter a una versión nueva
```bash
git remote add starter https://github.com/tamibot/creators-latam-starter.git
git fetch starter
git merge starter/main --allow-unrelated-histories
```

---

## Links útiles

- Repo: [github.com/tamibot/creators-latam-starter](https://github.com/tamibot/creators-latam-starter)
- Landing: [tamibot.github.io/creators-latam-starter](https://tamibot.github.io/creators-latam-starter/)
- Creators Latam: [creatorslatam.com](https://www.creatorslatam.com/)
- Contacto directo: +51 995 547 575 (WhatsApp)

Cualquier problema, abrí un issue en el repo o mandanos WhatsApp.
