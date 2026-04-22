# Guía de instalación

Paso a paso desde una Mac vacía hasta tener el starter funcionando — Claude Code + 32 agentes + 5 skills + todas las herramientas.

> **Tiempo:** 15–30 min la primera vez (mayoría es descarga). En corridas posteriores: segundos.
> **OS:** macOS (guías Windows / Linux al final).
> **Esfuerzo:** interactivo — el instalador te pregunta bloque por bloque.

---

## Resumen (para los apurados)

```bash
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto && rm -rf .git && git init
./tooling/install.sh
cp .env.example .env       # editar con tus keys reales
claude                     # abre Claude Code
```

Si es tu primera vez, **seguí la guía completa abajo**. 👇

---

## Fase 0 · Chequeo previo

Antes de instalar nada, mirá qué ya tenés:

```bash
# Copiá y pegá todo el bloque en terminal
echo "=== Estado actual ==="
for cmd in git gh brew python3 node npm uv claude docker ffmpeg yt-dlp rg fd bat fzf jq gitleaks; do
  if command -v $cmd &>/dev/null; then
    echo "✓ $cmd"
  else
    echo "✗ $cmd — falta"
  fi
done
```

El instalador hace este mismo check al arrancar y solo instala lo que falta.

---

## Fase 1 · Homebrew (base de todo)

Si `brew --version` no devuelve nada:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Te pide la contraseña de tu Mac.** Es normal.

Al terminar, en Apple Silicon hay que agregar al PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"
```

✓ Verificá: `brew --version`

---

## Fase 2 · Git + GitHub CLI

### git
Casi siempre viene con Xcode Command Line Tools. Si `git --version` falla:
```bash
xcode-select --install
```
Aceptá el popup. Tarda ~5 min.

### GitHub CLI
```bash
brew install gh
gh auth login
```
- Elegí **GitHub.com**.
- Elegí **HTTPS**.
- Elegí **Login with a web browser** → aprobar en navegador.

✓ Verificá: `gh auth status` debe decir `Logged in to github.com`.

---

## Fase 3 · Clonar el starter

Organización recomendada: una carpeta madre por cliente, adentro una carpeta por proyecto.

```bash
mkdir -p ~/Desktop/Clientes/mi-cliente
cd ~/Desktop/Clientes/mi-cliente
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto
```

Si es un proyecto propio (no un fork del starter):
```bash
rm -rf .git && git init
git remote add starter https://github.com/tamibot/creators-latam-starter.git
```
El remote `starter` te sirve para futuras actualizaciones (vía `./tooling/migrate.sh`).

---

## Fase 4 · Instalador automático

Ahora corré el script maestro:

```bash
./tooling/install.sh
```

Es **interactivo y seguro**:
- Audita tu sistema primero → muestra qué tenés ✓ y qué falta ✗.
- Si todo está instalado, sale en segundos.
- Si faltan cosas, te pregunta bloque por bloque antes de instalar.

### Qué te va a pedir autorización

1. **Contraseña de Mac** (para Homebrew / Python system install).
2. **Popup `xcode-select --install`** (solo si git no estaba).
3. **`gh auth login`** abre navegador.
4. **Docker Desktop** se instala pero requiere abrirlo manual una vez.
5. **Modelo whisper** (opcional, ~1.5 GB) — descarga optativa.
6. **gitleaks + pre-commit hook** (opcional, recomendado).

### Qué se instala

| Categoría | Paquetes |
|---|---|
| **Base** | Homebrew, git, gh, Python 3.12, uv, nvm + Node LTS, ffmpeg, Docker Desktop, Claude Code CLI |
| **Documentos** | [`marker`](https://github.com/datalab-to/marker), [`markitdown`](https://github.com/microsoft/markitdown) |
| **Audio/Video** | [`yt-dlp`](https://github.com/yt-dlp/yt-dlp), [`whisper.cpp`](https://github.com/ggerganov/whisper.cpp), `google-genai` SDK |
| **Terminal** | ripgrep, fd, bat, fzf, jq, delta, glow, zoxide, tree |
| **Seguridad** | [`gitleaks`](https://github.com/gitleaks/gitleaks) + pre-commit hook (opcional) |

Al final, el instalador muestra:
- Qué instaló ahora.
- Qué ya estaba.
- Tiempo total.

### Post-instalación · shell rc

Agregá a tu `~/.zshrc` (o `~/.bashrc`):

```bash
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# zoxide (reemplaza cd)
eval "$(zoxide init zsh)"

# fzf (fuzzy finder)
source <(fzf --zsh)
```

Recargá: `source ~/.zshrc`.

Luego instalá Node LTS: `nvm install --lts`.

---

## Fase 5 · Credenciales

```bash
cp .env.example .env
open -e .env    # abre en TextEdit
```

### ⚠️ Aclaración crítica sobre `ANTHROPIC_API_KEY`

Si usás **Claude Code como IDE**, **NO necesitás** setear `ANTHROPIC_API_KEY`:
- Claude Code usa tu **sesión de login** (`claude` te pide auth en el navegador la primera vez).
- El `.env` es para tu **código**, no para el IDE.

Solo setéalo si:
- Tu código hace llamadas directas a la API de Anthropic (script Python, Node).
- Usás otro IDE que no sea Claude Code.

### Lo que sí querés rellenar

```bash
# Gemini (gratis · usado por skill video-a-texto)
GEMINI_API_KEY=AIza...
```

Otras keys se definen en Fase 2 del Plan Maestro (por proyecto):

| Servicio | Dónde conseguirla |
|---|---|
| Gemini (gratis) | https://aistudio.google.com/apikey |
| OpenAI | https://platform.openai.com/api-keys |
| Kommo | Account → Integrations → API |
| WhatsApp Meta | Meta Business Manager |
| n8n | Self-host o n8n.cloud |
| Railway | Railway dashboard → Account Settings |

**Regla:** nunca commitees `.env`. Ya está en `.gitignore` y el `credentials-manager` audita antes de cada commit.

---

## Fase 6 · Claude Code

Si el instalador no lo hizo:

```bash
npm install -g @anthropic-ai/claude-code
```

Requiere haber corrido `nvm install --lts` antes.

✓ Verificá: `claude --version`

Primer login:
```bash
claude
# Pide auth en navegador la primera vez
```

---

## Fase 7 · Primer arranque

Dentro de la carpeta del proyecto:

```bash
claude
```

Claude Code detecta automáticamente:
- ✓ `.claude/settings.json` → permisos preaprobados.
- ✓ `.claude/agents/*.md` → los 32 agentes.
- ✓ `.claude/skills/*/SKILL.md` → los 5 skills.
- ✓ `.claude/commands/*.md` → los slash commands custom.
- ✓ `CLAUDE.md` → reglas del proyecto.

Probá dentro de Claude Code:

```
/agents      → debería listar los 32 agentes
/plan-maestro → genera el scaffold inicial
/doctor      → corre health check
```

### 🎯 Tu primer mensaje en un proyecto nuevo

```
Usá el skill plan-maestro para generar el scaffold del plan.
Después invocá al agente kickoff-cliente para la primera reunión.
```

El sistema te va a guiar:
1. **kickoff-cliente** → primera reunión con el cliente (minuta + brief).
2. **onboarding-pm** → las 4 fases del Plan Maestro (Entregable → Stack → Equipo → Plan).
3. Con el plan firmado → `./tooling/validate-plan.sh` debe devolver exit 0.
4. **orquestador** → arranca ejecución delegando a los agentes correctos.

---

## Fase 8 · Validar todo

Correr el doctor:

```bash
./tooling/doctor.sh
```

Tiene que devolver todo ✓. Si reporta issues, corré con `--fix`:

```bash
./tooling/doctor.sh --fix
```

Aplica correcciones seguras (chmod 600 al `.env`, crea carpetas faltantes, etc).

---

## 🪟 Windows (guía general)

El script `install.sh` asume macOS. Para Windows:

1. **Instalá `winget`** (viene con Windows 11).
2. En Claude Code / Cursor pedí:
   > *"Instalame lo que está en `tooling/install.sh` adaptado a Windows con `winget` y `pip`. Saltá las partes específicas de macOS."*
3. Paquetes equivalentes: `Git.Git`, `GitHub.cli`, `Python.Python.3.12`, `Astral.uv`, `OpenJS.NodeJS.LTS`, `Docker.DockerDesktop`, `yt-dlp.yt-dlp`, `Gyan.FFmpeg`.
4. Para `whisper.cpp`: [README oficial](https://github.com/ggerganov/whisper.cpp#quick-start).
5. CLIs modernos: `scoop install ripgrep fd bat fzf jq` o `winget install BurntSushi.ripgrep.MSVC ...`.

---

## 🐧 Linux (guía general)

```bash
sudo apt update && sudo apt install -y git gh python3 python3-pip nodejs npm docker.io ffmpeg yt-dlp ripgrep fd-find bat fzf jq
curl -LsSf https://astral.sh/uv/install.sh | sh                                                  # uv
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash                  # nvm
```

Pedile a tu IDE con IA que adapte el resto de `tooling/install.sh` a tu distro.

---

## 🆘 Troubleshooting

### "command not found: brew" después de instalar Homebrew
→ Agregá al PATH en Apple Silicon:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### Python 3.12 dice "externally-managed-environment"
→ Usá `uv` (incluido): `uv pip install --system <paquete>`.
→ O `pip3 install --user --break-system-packages <paquete>` si sabés lo que hacés.

### "command not found: claude"
→ Instalaste Node? `nvm install --lts` primero.
→ Después: `npm install -g @anthropic-ai/claude-code`.

### Docker Desktop no arranca
→ Abrilo manualmente desde `/Applications` al menos una vez — necesita aceptar permisos de macOS.

### El agente no aparece en `/agents`
→ Cerrá y reabrí Claude Code. Los agentes se cargan al iniciar sesión.
→ Si aún no aparece, chequeá el frontmatter del archivo:
```yaml
---
name: mi-agente
description: ...
tools: Read, Write
---
```

### `marker` tarda mucho la primera vez
→ Normal. Descarga ~2 GB de modelos. Las corridas siguientes son rápidas.
→ Si llevás más de 30 min sin progreso, `Ctrl+C` y re-correlo — detecta lo que ya bajó.

### Querés actualizar el starter a una versión más nueva
```bash
./tooling/migrate.sh              # dry-run: muestra qué cambiaría
./tooling/migrate.sh --apply      # aplica el merge
```

### Dudas sobre duplicados entre agentes
```bash
./tooling/check-duplicates.sh
```

---

## Estructura de lo que te vas a encontrar

```
mi-proyecto/
├── .claude/          (32 agentes + 5 skills + settings + commands)
├── tooling/          (7 scripts · doctor, install, validate, migrate, etc)
├── templates/        (plan-maestro, NV, api-research, handoff, retro)
├── workflows/        (vacío — acá van tus flujos)
├── documentation/    (vacío — plan-maestro.md, bitácora, status)
├── data_original/    (raw del cliente · sagrado)
└── output/           (entregables finales al cliente)
```

---

## Próximos pasos

1. Leé [`CLAUDE.md`](./CLAUDE.md) — las 10 reglas no negociables.
2. Leé [`.claude/agents/README.md`](./.claude/agents/README.md) — el escuadrón de 32 agentes.
3. Revisá [`templates/plan-maestro.md`](./templates/plan-maestro.md) — el documento que vas a firmar con el cliente.
4. Arrancá tu proyecto: `claude` → `/plan-maestro`.

Cualquier problema: WhatsApp al +51 995 547 575 o issue en GitHub.
