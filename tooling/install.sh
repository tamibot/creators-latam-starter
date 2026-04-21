#!/usr/bin/env bash
# ============================================================
# Creators Latam · Starter Kit · Instalador interactivo
# ============================================================
# Uso: ./tooling/install.sh
# Docs: ./tooling/README.md
# ------------------------------------------------------------

set -u  # fallar si uso variable no definida

# --- Colores ---
B='\033[1m'; D='\033[2m'; PINK='\033[38;5;205m'; GREEN='\033[38;5;42m'
YELLOW='\033[38;5;220m'; BLUE='\033[38;5;39m'; RED='\033[38;5;196m'; R='\033[0m'

# --- Logging helpers ---
say()     { printf "${B}%s${R}\n" "$*"; }
ok()      { printf "  ${GREEN}✓${R} %s\n" "$*"; }
warn()    { printf "  ${YELLOW}!${R} %s\n" "$*"; }
err()     { printf "  ${RED}✗${R} %s\n" "$*"; }
info()    { printf "  ${D}%s${R}\n" "$*"; }
hr()      { printf "${D}─────────────────────────────────────────────${R}\n"; }

confirm() {
  local prompt="$1"
  local default="${2:-y}"
  local yn
  if [ "$default" = "y" ]; then
    read -r -p "  $(printf "${PINK}?${R} %s [${B}Y${R}/n]: " "$prompt")" yn
    yn="${yn:-y}"
  else
    read -r -p "  $(printf "${PINK}?${R} %s [y/${B}N${R}]: " "$prompt")" yn
    yn="${yn:-n}"
  fi
  [[ "$yn" =~ ^[Yy]$ ]]
}

has() { command -v "$1" >/dev/null 2>&1; }

install_pkg_brew() {
  local pkg="$1"
  if has "${2:-$pkg}"; then
    ok "$pkg ya instalado"
  else
    info "Instalando $pkg ..."
    if brew install "$pkg"; then ok "$pkg instalado"; else err "Falló instalación de $pkg"; fi
  fi
}

# ============================================================
# Header
# ============================================================
clear
cat <<EOF

${PINK}${B}
   ╔═════════════════════════════════════════════╗
   ║   Creators Latam · Starter Kit Installer    ║
   ╚═════════════════════════════════════════════╝
${R}
${D}Este script instala las herramientas del starter kit.
Vas a poder elegir qué instalar.

Si algo requiere autorización manual (contraseña, popup de macOS,
login de OAuth), te vamos a avisar.${R}

EOF

# ============================================================
# Detección de SO
# ============================================================
if [[ "$OSTYPE" != "darwin"* ]]; then
  err "Este instalador asume macOS. Estás en: $OSTYPE"
  warn "Si estás en Windows o Linux, consultá tooling/README.md"
  exit 1
fi
ok "macOS detectado"
hr
echo

# ============================================================
# BLOQUE 1 · Prerrequisitos
# ============================================================
say "[1/5] Prerrequisitos del sistema"
echo

# --- Homebrew ---
if has brew; then
  ok "Homebrew instalado ($(brew --version | head -1))"
else
  warn "Homebrew no detectado. Se requiere para instalar casi todo lo demás."
  if confirm "¿Instalar Homebrew ahora?" y; then
    info "Pedirá tu contraseña de macOS — es normal."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Agregar a PATH si es Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    err "Sin Homebrew no puedo seguir. Saliendo."
    exit 1
  fi
fi

# --- git (suele venir por defecto) ---
if has git; then
  ok "git instalado ($(git --version))"
else
  warn "git no detectado — ejecutá: xcode-select --install"
  if confirm "¿Correr xcode-select --install ahora?" y; then
    xcode-select --install
    warn "Aceptá el popup que salga y volvé a correr este script cuando termine."
    exit 0
  fi
fi

# --- GitHub CLI ---
if has gh; then
  ok "gh (GitHub CLI) instalado"
else
  if confirm "¿Instalar GitHub CLI (gh)?" y; then
    install_pkg_brew gh
    warn "Después del script correr: gh auth login  (abre navegador)"
  fi
fi

# --- Python ---
if has python3 && python3 -c 'import sys; exit(0 if sys.version_info>=(3,11) else 1)'; then
  ok "Python $(python3 --version | cut -d' ' -f2) instalado"
else
  if confirm "¿Instalar Python 3.12?" y; then
    install_pkg_brew "python@3.12" python3
  fi
fi

# --- uv (gestor Python rápido) ---
if has uv; then
  ok "uv instalado"
else
  if confirm "¿Instalar uv (gestor Python ultra-rápido de Astral)?" y; then
    install_pkg_brew uv
  fi
fi

# --- nvm + Node ---
if [ -s "$HOME/.nvm/nvm.sh" ] || has node; then
  ok "Node.js / nvm detectado"
else
  if confirm "¿Instalar nvm + Node LTS?" y; then
    install_pkg_brew nvm
    mkdir -p ~/.nvm
    warn "Agregá a tu ~/.zshrc o ~/.bashrc:"
    info '  export NVM_DIR="$HOME/.nvm"'
    info '  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"'
    info "Después: nvm install --lts"
  fi
fi

# --- ffmpeg ---
if has ffmpeg; then
  ok "ffmpeg instalado"
else
  if confirm "¿Instalar ffmpeg (requerido por yt-dlp y whisper)?" y; then
    install_pkg_brew ffmpeg
  fi
fi

# --- Docker ---
if has docker; then
  ok "docker instalado"
else
  if confirm "¿Instalar Docker Desktop?" n; then
    info "Instalando Docker Desktop (cask) ..."
    brew install --cask docker || err "Falló instalación de Docker"
    warn "Abrí Docker.app una vez manualmente para aceptar permisos."
  fi
fi

hr
echo

# ============================================================
# BLOQUE 2 · Documentos
# ============================================================
say "[2/5] Conversión de documentos (marker + markitdown)"
echo
if confirm "¿Instalar marker-pdf + markitdown?" y; then
  if has uv; then
    info "Usando uv ..."
    uv pip install --system marker-pdf 'markitdown[all]' || warn "uv falló, probando con pip ..."
  fi
  if ! has marker_single || ! has markitdown; then
    pip3 install --user marker-pdf 'markitdown[all]'
  fi
  has marker_single && ok "marker instalado" || warn "marker no quedó en PATH"
  has markitdown && ok "markitdown instalado" || warn "markitdown no quedó en PATH"
fi

hr
echo

# ============================================================
# BLOQUE 3 · Video / Audio
# ============================================================
say "[3/5] Video / Audio (yt-dlp + whisper.cpp + Gemini SDK)"
echo
if confirm "¿Instalar yt-dlp + whisper.cpp + SDK Gemini?" y; then
  install_pkg_brew yt-dlp
  install_pkg_brew whisper-cpp whisper-cli
  if has uv; then
    uv pip install --system google-genai || pip3 install --user google-genai
  else
    pip3 install --user google-genai
  fi
  ok "SDK Gemini listo (recordá setear GEMINI_API_KEY en .env)"

  if confirm "¿Descargar modelo whisper 'medium' (~1.5GB)?" n; then
    mkdir -p ~/.whisper-cpp/models
    bash <(curl -s https://raw.githubusercontent.com/ggerganov/whisper.cpp/master/models/download-ggml-model.sh) medium ~/.whisper-cpp/models \
      && ok "modelo medium descargado" \
      || warn "descarga falló — podés correrla manualmente más tarde"
  fi
fi

hr
echo

# ============================================================
# BLOQUE 4 · Terminal productivity
# ============================================================
say "[4/5] Terminal productivity (ripgrep, fd, bat, fzf, jq, delta, glow, zoxide, tree)"
echo
if confirm "¿Instalar todas?" y; then
  for pkg in ripgrep fd bat fzf jq git-delta glow zoxide tree; do
    install_pkg_brew "$pkg"
  done
  warn "Para activar zoxide agregá a tu shell rc: eval \"\$(zoxide init zsh)\""
fi

hr
echo

# ============================================================
# BLOQUE 5 · Entorno del proyecto
# ============================================================
say "[5/5] Entorno del proyecto"
echo

if [ ! -f .env ] && [ -f .env.example ]; then
  if confirm "¿Copiar .env.example a .env?" y; then
    cp .env.example .env
    ok ".env creado — rellenalo con tus credenciales reales"
  fi
else
  ok ".env ya existe o no hay template"
fi

hr
echo

# ============================================================
# Resumen final
# ============================================================
say "¡Listo!"
echo
ok "Starter kit instalado."
info "Próximos pasos:"
echo "    1. Editá ${B}.env${R} con tus credenciales reales."
echo "    2. Si instalaste gh → ${B}gh auth login${R}"
echo "    3. Si instalaste nvm → agregalo a tu shell rc y ${B}nvm install --lts${R}"
echo "    4. Abrí tu IDE: ${B}claude${R} (o ${B}cursor .${R})"
echo "    5. Los 12 agentes y 3 skills están listos en .claude/"
echo
info "Dudas → tooling/README.md o https://github.com/tamibot/creators-latam-starter"
echo
