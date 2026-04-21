# Tooling · Herramientas que instala el starter

Este documento explica **cada herramienta** que `./tooling/install.sh` deja lista en tu máquina, qué hace, y en qué skill/agente la usa el sistema.

> **Windows:** el script asume macOS. Si estás en Windows, pediles a tu asistente de IA que aplique lo mismo pero usando `winget` o `scoop` en lugar de `brew`. El resto de los paquetes (Python, Node, Docker) tienen instaladores nativos para Windows. Linux → hacé lo mismo con `apt`/`dnf`.

---

## 🔧 Prerrequisitos del sistema (la base)

Sin esto no funciona nada. El script los detecta y sólo instala lo que falta.

### 1. Homebrew — [brew.sh](https://brew.sh/)
Gestor de paquetes de macOS. El primer paso obligatorio en Mac. Maneja todo lo demás.

### 2. git
Control de versiones. Casi siempre viene preinstalado con Xcode Command Line Tools. El script verifica.

### 3. GitHub CLI (`gh`) — [cli.github.com](https://cli.github.com/)
Crea repos, abre PRs, gestiona issues desde terminal. Lo usa el agente `github-keeper`.
```bash
brew install gh
gh auth login  # necesita login manual en el navegador
```

### 4. Python 3.12+ — [python.org](https://www.python.org/)
Runtime de Python. Base de marker, markitdown, whisper bindings, etc.
```bash
brew install python@3.12
```

### 5. uv — [astral.sh/uv](https://github.com/astral-sh/uv)
Gestor de paquetes Python moderno (de Astral), 10–100× más rápido que pip. Reemplaza pip+venv+pyenv en uno.
```bash
brew install uv
```

### 6. Node.js + nvm — [nvm-sh](https://github.com/nvm-sh/nvm)
Runtime JS. `nvm` permite cambiar entre versiones sin romper proyectos.
```bash
brew install nvm
nvm install --lts
nvm use --lts
```

### 7. ffmpeg — [ffmpeg.org](https://ffmpeg.org/)
Procesamiento de audio/video. Requerido por `yt-dlp` y `whisper.cpp`.
```bash
brew install ffmpeg
```

### 8. Docker Desktop — [docker.com](https://www.docker.com/products/docker-desktop/)
Contenedores. Útil para levantar n8n, bases de datos, servicios locales sin ensuciar tu Mac.
```bash
brew install --cask docker
```
⚠️ Tras instalar, abrir Docker.app **una vez manualmente** para aceptar permisos.

---

## 📄 Conversión de documentos

### marker — [datalab-to/marker](https://github.com/datalab-to/marker)
**Qué hace:** convierte PDFs a Markdown con calidad estado-del-arte. Preserva tablas, ecuaciones LaTeX, orden de lectura, extrae imágenes.

**Cuándo usarlo:** PDFs largos, técnicos, papers, contratos con tablas complejas.

**Lo usa:** skill [`pdf-a-markdown`](../.claude/skills/pdf-a-markdown/SKILL.md).

```bash
uv pip install marker-pdf
marker_single data_original/doc.pdf --output_dir documentation/
```

### MarkItDown — [microsoft/markitdown](https://github.com/microsoft/markitdown)
**Qué hace:** convierte casi cualquier cosa a MD: PDF, DOCX, PPTX, XLSX, HTML, imágenes (OCR), audio.

**Cuándo usarlo:** default para todo excepto PDFs complejos. Más rápido que marker.

**Lo usa:** skill [`pdf-a-markdown`](../.claude/skills/pdf-a-markdown/SKILL.md).

```bash
uv pip install 'markitdown[all]'
markitdown data_original/doc.docx > documentation/doc.md
```

---

## 🎬 Video / Audio → texto

### Gemini API — [aistudio.google.com/apikey](https://aistudio.google.com/apikey)
**Qué hace:** Gemini de Google acepta video `.mp4` directo como input (hasta ~1h). Te responde qué ve y qué se dice en un solo paso.

**Cuándo usarlo:** default para analizar videos. Solo requiere token gratis.

**Lo usa:** skill [`video-a-texto`](../.claude/skills/video-a-texto/SKILL.md).

```bash
uv pip install google-genai
# Setear GEMINI_API_KEY en .env
```

### yt-dlp — [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)
**Qué hace:** descarga videos de YouTube, TikTok, Instagram, Vimeo, Twitter, etc. Sucesor moderno de youtube-dl.

**Cuándo usarlo:** cuando el video está online y necesitás el archivo.

**Lo usa:** skill [`video-a-texto`](../.claude/skills/video-a-texto/SKILL.md).

```bash
brew install yt-dlp
yt-dlp -o "data_original/%(title)s.%(ext)s" "<URL>"
```

### whisper.cpp — [ggerganov/whisper.cpp](https://github.com/ggerganov/whisper.cpp)
**Qué hace:** transcribe audio a texto **localmente**, en CPU, sin enviar nada a la nube. Port C++ de Whisper.

**Cuándo usarlo:** contenido confidencial, volumen alto (Gemini cobra), o sin internet.

**Lo usa:** skill [`video-a-texto`](../.claude/skills/video-a-texto/SKILL.md).

```bash
brew install whisper-cpp
# Descargar modelo una vez:
bash <(curl -s https://raw.githubusercontent.com/ggerganov/whisper.cpp/master/models/download-ggml-model.sh) medium
```

---

## ⚡ Terminal productivity

Un solo `brew install` deja todos listos. Cada uno mejora un comando básico.

| CLI | Reemplaza a | Qué mejora |
|---|---|---|
| **ripgrep** (`rg`) | `grep` | 10–100× más rápido, respeta `.gitignore` |
| **fd** | `find` | Sintaxis humana, rápido |
| **bat** | `cat` | Syntax highlighting, números de línea, paginado |
| **fzf** | — | Buscador fuzzy interactivo (archivos, historial, branches) |
| **jq** | — | Parsear y transformar JSON en terminal |
| **delta** | `git diff` | Diffs con formato legible y colores |
| **glow** | — | Renderiza Markdown en terminal (ideal para previsualizar READMEs) |
| **zoxide** (`z`) | `cd` | Salta a directorios visitados con fuzzy matching |
| **tree** | — | Árbol visual de directorios |

```bash
brew install ripgrep fd bat fzf jq git-delta glow zoxide tree
```

---

## 🎨 Diagramación

### Mermaid CLI — [@mermaid-js/mermaid-cli](https://github.com/mermaid-js/mermaid-cli)
**Qué hace:** convierte archivos Mermaid (`.mmd`) a SVG/PNG/PDF. Valida sintaxis antes de commitear.

**Lo usa:** agente [`diagramador-mermaid`](../.claude/agents/diagramador-mermaid.md).

No requiere instalación global — se ejecuta vía `npx`:
```bash
npx -y @mermaid-js/mermaid-cli -i diagrama.mmd -o diagrama.svg
```

---

## 📦 Resumen: qué instala el script

```
PREREQUISITOS (sistema):
├── Homebrew
├── git (verifica, no reinstala)
├── gh (GitHub CLI)
├── python@3.12
├── uv
├── nvm + Node LTS
├── ffmpeg
└── Docker Desktop

DOCUMENTOS:
├── marker-pdf (pip)
└── markitdown[all] (pip)

VIDEO/AUDIO:
├── yt-dlp (brew)
├── whisper-cpp (brew)
├── google-genai (pip)
└── modelo whisper medium (descarga opcional)

TERMINAL:
└── ripgrep, fd, bat, fzf, jq, delta, glow, zoxide, tree (brew)

DIAGRAMAS:
└── @mermaid-js/mermaid-cli (on-demand via npx)
```

---

## 🚀 Uso

```bash
# Correr el instalador (interactivo)
./tooling/install.sh

# O manualmente paso a paso
# Ver: ./tooling/prerequisitos.md
```
