#!/usr/bin/env bash
# ============================================================
# Creators Latam · Starter Kit · Instalador inteligente
# ============================================================
# Uso: ./tooling/install.sh
# Docs: ./tooling/README.md
# ------------------------------------------------------------
# Este instalador NO reinstala lo que ya tenés.
# Primero audita el sistema, después te muestra qué falta,
# y te pregunta qué querés instalar.
# ------------------------------------------------------------

set -u

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

# Imprime versión compacta de un comando si existe.
version_of() {
  local cmd="$1"
  case "$cmd" in
    brew)         brew --version 2>/dev/null | head -1 | awk '{print $2}' ;;
    git)          git --version 2>/dev/null | awk '{print $3}' ;;
    gh)           gh --version 2>/dev/null | head -1 | awk '{print $3}' ;;
    python3)      python3 --version 2>/dev/null | awk '{print $2}' ;;
    node)         node --version 2>/dev/null ;;
    npm)          npm --version 2>/dev/null ;;
    docker)       docker --version 2>/dev/null | awk '{print $3}' | tr -d ',' ;;
    ffmpeg)       ffmpeg -version 2>/dev/null | head -1 | awk '{print $3}' ;;
    uv)           uv --version 2>/dev/null | awk '{print $2}' ;;
    claude)       claude --version 2>/dev/null | head -1 | awk '{print $1}' ;;
    yt-dlp)       yt-dlp --version 2>/dev/null ;;
    whisper-cli)  whisper-cli --help 2>/dev/null | head -1 | awk '{print $NF}' ;;
    rg)           rg --version 2>/dev/null | head -1 | awk '{print $2}' ;;
    *)            echo "installed" ;;
  esac
}

# Chequea si un paquete Python está instalado.
pip_has() {
  python3 -c "import importlib, sys; importlib.import_module('$1'); sys.exit(0)" 2>/dev/null
}

# Instala vía brew sólo si no existe el comando de verificación.
install_brew_if_missing() {
  local pkg="$1"
  local check_cmd="${2:-$pkg}"
  if has "$check_cmd"; then
    ok "$pkg — $(version_of $check_cmd) (ya instalado, salto)"
    return 0
  fi
  info "Instalando $pkg ..."
  if brew install "$pkg" >/dev/null 2>&1; then
    ok "$pkg instalado"
    return 0
  else
    err "Falló instalación de $pkg — ejecutá manualmente: brew install $pkg"
    return 1
  fi
}

# Tiempo de inicio
START_TIME=$(date +%s)
INSTALLED_NOW=()
ALREADY_HAD=()

# ============================================================
# Header
# ============================================================
clear
cat <<EOF

${PINK}${B}
   ╔═════════════════════════════════════════════╗
   ║   Creators Latam · Starter Kit Installer    ║
   ║   v1.3 · Instalación inteligente             ║
   ╚═════════════════════════════════════════════╝
${R}
${D}Primero audito qué ya tenés. Después te pregunto qué falta instalar.
Lo que ya está no se reinstala.

Si algo requiere autorización manual (contraseña, popup macOS,
login OAuth), te lo vamos a avisar.${R}

EOF

# ============================================================
# Detección de SO
# ============================================================
if [[ "$OSTYPE" != "darwin"* ]]; then
  err "Este instalador asume macOS. Estás en: $OSTYPE"
  warn "Si estás en Windows o Linux, ver tooling/prerequisitos.md"
  exit 1
fi
ok "macOS $(sw_vers -productVersion 2>/dev/null || echo '?') detectado"
hr
echo

# ============================================================
# AUDITORÍA INICIAL
# ============================================================
say "🔍 Auditoría del sistema"
echo

audit_tool() {
  local name="$1" cmd="$2"
  if has "$cmd"; then
    local v; v="$(version_of $cmd)"
    ok "$name → v$v"
    ALREADY_HAD+=("$name")
  else
    err "$name → no instalado"
  fi
}

audit_pip() {
  local name="$1" mod="$2"
  if pip_has "$mod"; then
    ok "$name → instalado (import $mod OK)"
    ALREADY_HAD+=("$name")
  else
    err "$name → no instalado"
  fi
}

printf "${B}  Sistema${R}\n"
audit_tool "Homebrew"  brew
audit_tool "git"       git
audit_tool "gh (GitHub CLI)" gh
audit_tool "Python 3"  python3
audit_tool "uv"        uv
audit_tool "Node.js"   node
audit_tool "npm"       npm
audit_tool "ffmpeg"    ffmpeg
audit_tool "Docker"    docker
audit_tool "Claude Code" claude

echo
printf "${B}  Documentos (Python)${R}\n"
audit_pip "marker"     marker
audit_pip "markitdown" markitdown

echo
printf "${B}  Video/Audio${R}\n"
audit_tool "yt-dlp"     yt-dlp
audit_tool "whisper.cpp" whisper-cli
audit_pip  "google-genai" google

echo
printf "${B}  Terminal${R}\n"
for cmd in rg fd bat fzf jq delta glow zoxide tree; do
  if has "$cmd"; then ok "$cmd"; ALREADY_HAD+=("$cmd"); else err "$cmd — falta"; fi
done

echo
hr
echo

# Count missing
MISSING_COUNT=0
check_missing() { has "$1" || MISSING_COUNT=$((MISSING_COUNT+1)); }
check_missing_pip() { pip_has "$1" || MISSING_COUNT=$((MISSING_COUNT+1)); }

for cmd in brew git gh python3 uv node npm ffmpeg docker yt-dlp whisper-cli rg fd bat fzf jq delta glow zoxide tree; do
  check_missing "$cmd"
done
check_missing_pip marker
check_missing_pip markitdown
check_missing_pip google

if [ "$MISSING_COUNT" -eq 0 ]; then
  ok "${B}Todo está instalado. No hay nada que hacer.${R}"
  echo
  info "Si querés forzar una actualización de paquetes brew:"
  info "  ${B}brew upgrade${R}"
  echo
  exit 0
fi

say "📦 Faltan $MISSING_COUNT componentes. Te pregunto bloque por bloque."
echo
hr
echo

# ============================================================
# BLOQUE 1 · Prerrequisitos
# ============================================================
say "[1/5] Prerrequisitos del sistema"
echo

# --- Homebrew ---
if ! has brew; then
  warn "Homebrew no detectado. Base de todo lo demás en Mac."
  if confirm "¿Instalar Homebrew ahora? (requiere contraseña de macOS)" y; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon PATH
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    INSTALLED_NOW+=("Homebrew")
  else
    err "Sin Homebrew no puedo seguir. Saliendo."
    exit 1
  fi
fi

# --- git ---
if ! has git; then
  warn "git no detectado."
  info "Ejecutá: ${B}xcode-select --install${R} y volvé a correr el script."
  if confirm "¿Correr xcode-select --install ahora?" y; then
    xcode-select --install
    warn "Aceptá el popup. Volvé a correr este script al terminar."
    exit 0
  fi
fi

# --- gh ---
if ! has gh; then
  if confirm "¿Instalar GitHub CLI (gh)?" y; then
    install_brew_if_missing gh && INSTALLED_NOW+=("gh")
    warn "Después del script: ${B}gh auth login${R}"
  fi
fi

# --- Python ---
if ! has python3; then
  if confirm "¿Instalar Python 3.12?" y; then
    install_brew_if_missing "python@3.12" python3 && INSTALLED_NOW+=("python3")
  fi
elif ! python3 -c 'import sys; exit(0 if sys.version_info>=(3,11) else 1)' 2>/dev/null; then
  warn "Python actual es < 3.11. Recomendado: 3.12+"
  if confirm "¿Actualizar Python?" n; then
    install_brew_if_missing "python@3.12" python3 && INSTALLED_NOW+=("python@3.12")
  fi
fi

# --- uv ---
if ! has uv; then
  if confirm "¿Instalar uv (gestor Python ultra-rápido)?" y; then
    install_brew_if_missing uv && INSTALLED_NOW+=("uv")
  fi
fi

# --- nvm + Node ---
if ! has node && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  if confirm "¿Instalar nvm + Node LTS?" y; then
    install_brew_if_missing nvm
    mkdir -p ~/.nvm
    INSTALLED_NOW+=("nvm")
    warn "Agregá a ~/.zshrc o ~/.bashrc:"
    info '    export NVM_DIR="$HOME/.nvm"'
    info '    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"'
    info "Después: ${B}nvm install --lts${R}"
  fi
fi

# --- ffmpeg ---
if ! has ffmpeg; then
  if confirm "¿Instalar ffmpeg (requerido por yt-dlp y whisper)?" y; then
    install_brew_if_missing ffmpeg && INSTALLED_NOW+=("ffmpeg")
  fi
fi

# --- Docker ---
if ! has docker; then
  if confirm "¿Instalar Docker Desktop?" n; then
    info "Instalando Docker Desktop (cask) ..."
    brew install --cask docker && INSTALLED_NOW+=("Docker Desktop") || err "Falló instalación"
    warn "Abrí Docker.app una vez manualmente para aceptar permisos."
  fi
fi

# --- Claude Code ---
if ! has claude; then
  if has npm && confirm "¿Instalar Claude Code CLI?" y; then
    info "Instalando via npm ..."
    if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
      ok "Claude Code instalado"
      INSTALLED_NOW+=("Claude Code")
    else
      warn "Falló instalación. Correlo manualmente: npm install -g @anthropic-ai/claude-code"
    fi
  fi
fi

hr
echo

# ============================================================
# BLOQUE 2 · Documentos
# ============================================================
say "[2/5] Conversión de documentos (marker + markitdown)"
echo

if pip_has marker && pip_has markitdown; then
  ok "marker + markitdown ya instalados, salto."
else
  if confirm "¿Instalar marker-pdf + markitdown?" y; then
    if has uv; then
      info "Usando uv (más rápido) ..."
      uv pip install --system marker-pdf 'markitdown[all]' 2>&1 | tail -5 || warn "uv falló, probando con pip"
    fi
    if ! pip_has marker || ! pip_has markitdown; then
      pip3 install --user marker-pdf 'markitdown[all]' 2>&1 | tail -5
    fi
    pip_has marker && ok "marker OK" && INSTALLED_NOW+=("marker") || warn "marker no quedó en PATH"
    pip_has markitdown && ok "markitdown OK" && INSTALLED_NOW+=("markitdown") || warn "markitdown no quedó en PATH"
  fi
fi

hr
echo

# ============================================================
# BLOQUE 3 · Video / Audio
# ============================================================
say "[3/5] Video / Audio (yt-dlp + whisper.cpp + SDK Gemini)"
echo

if has yt-dlp && has whisper-cli && pip_has google; then
  ok "Todo ya instalado, salto."
else
  if confirm "¿Instalar los que faltan?" y; then
    has yt-dlp     || { install_brew_if_missing yt-dlp      && INSTALLED_NOW+=("yt-dlp"); }
    has whisper-cli || { install_brew_if_missing whisper-cpp whisper-cli && INSTALLED_NOW+=("whisper.cpp"); }

    if ! pip_has google; then
      if has uv; then
        uv pip install --system google-genai 2>&1 | tail -3
      else
        pip3 install --user google-genai 2>&1 | tail -3
      fi
      pip_has google && INSTALLED_NOW+=("google-genai")
    fi

    ok "SDK Gemini listo — seteá GEMINI_API_KEY en .env"

    if [ ! -f ~/.whisper-cpp/models/ggml-medium.bin ]; then
      if confirm "¿Descargar modelo whisper 'medium' (~1.5GB)?" n; then
        mkdir -p ~/.whisper-cpp/models
        bash <(curl -s https://raw.githubusercontent.com/ggerganov/whisper.cpp/master/models/download-ggml-model.sh) medium ~/.whisper-cpp/models \
          && ok "modelo medium descargado" \
          || warn "descarga falló — correlo manualmente después"
      fi
    else
      ok "modelo whisper medium ya existe"
    fi
  fi
fi

hr
echo

# ============================================================
# BLOQUE 4 · Terminal productivity
# ============================================================
say "[4/5] Terminal productivity"
echo

TERMINAL_PKGS=(ripgrep:rg fd:fd bat:bat fzf:fzf jq:jq git-delta:delta glow:glow zoxide:zoxide tree:tree)
MISSING_TERM=()
for entry in "${TERMINAL_PKGS[@]}"; do
  pkg="${entry%:*}"
  cmd="${entry#*:}"
  has "$cmd" || MISSING_TERM+=("$entry")
done

if [ ${#MISSING_TERM[@]} -eq 0 ]; then
  ok "Todos los CLI modernos ya instalados, salto."
else
  info "Faltan: $(echo ${MISSING_TERM[@]} | tr ' ' ',' | tr ':' ' ' | awk -F',' '{for(i=1;i<=NF;i++){split($i,a," "); printf "%s ", a[1]}}')"
  if confirm "¿Instalar los que faltan?" y; then
    for entry in "${MISSING_TERM[@]}"; do
      pkg="${entry%:*}"
      cmd="${entry#*:}"
      install_brew_if_missing "$pkg" "$cmd" && INSTALLED_NOW+=("$pkg")
    done
    warn "Activá zoxide + fzf en tu shell:"
    info '    eval "$(zoxide init zsh)"'
    info '    source <(fzf --zsh)'
  fi
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
    ok ".env creado — editalo con tus credenciales reales"
    INSTALLED_NOW+=(".env")
  fi
elif [ -f .env ]; then
  ok ".env ya existe"
fi

hr
echo

# ============================================================
# Resumen final
# ============================================================
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
ELAPSED_MIN=$((ELAPSED / 60))
ELAPSED_SEC=$((ELAPSED % 60))

say "✨ Instalación completada en ${ELAPSED_MIN}m ${ELAPSED_SEC}s"
echo
if [ ${#INSTALLED_NOW[@]} -gt 0 ]; then
  printf "  ${GREEN}Instalado ahora (${#INSTALLED_NOW[@]}):${R} %s\n" "$(IFS=, ; echo "${INSTALLED_NOW[*]}")"
fi
if [ ${#ALREADY_HAD[@]} -gt 0 ]; then
  printf "  ${D}Ya estaba (${#ALREADY_HAD[@]}):${R} ${D}%s${R}\n" "$(IFS=, ; echo "${ALREADY_HAD[*]}")"
fi
echo

info "Próximos pasos:"
echo "    1. Editá ${B}.env${R} con tus credenciales reales."
echo "       (Si usás Claude Code, NO necesitás ANTHROPIC_API_KEY — Claude Code"
echo "        usa tu sesión, no una API key separada.)"
echo "    2. Si instalaste gh → ${B}gh auth login${R}"
echo "    3. Si instalaste nvm → agregalo a tu shell rc y ${B}nvm install --lts${R}"
echo "    4. Abrí tu IDE: ${B}claude${R} (o ${B}cursor .${R})"
echo "    5. Primer paso en cualquier proyecto: invocá al agente ${B}onboarding-pm${R}"
echo "       para armar el Plan Maestro (entregables → stack → equipo)."
echo
info "Dudas → INSTALL.md / tooling/README.md / https://github.com/tamibot/creators-latam-starter"
echo
