#!/usr/bin/env bash
# ============================================================
# Creators Latam · Instalar pre-commit hook con gitleaks
# ============================================================
# Bloquea commits que tengan secrets detectados.
# ------------------------------------------------------------

set -eu

GREEN='\033[38;5;42m'; YELLOW='\033[38;5;220m'
RED='\033[38;5;196m'; B='\033[1m'; R='\033[0m'

ok()   { printf "${GREEN}✓${R} %s\n" "$*"; }
warn() { printf "${YELLOW}!${R} %s\n" "$*"; }
err()  { printf "${RED}✗${R} %s\n" "$*"; }

if [ ! -d .git ]; then
  err "No estás en un repo git"
  exit 1
fi

if ! command -v gitleaks >/dev/null 2>&1; then
  warn "gitleaks no está instalado. Instalando..."
  if command -v brew >/dev/null 2>&1; then
    brew install gitleaks
  else
    err "Brew no encontrado. Instalá gitleaks manualmente: https://github.com/gitleaks/gitleaks"
    exit 1
  fi
fi

HOOK_FILE=.git/hooks/pre-commit

cat > "$HOOK_FILE" <<'EOF'
#!/usr/bin/env bash
# Pre-commit hook generado por tooling/install-gitleaks-hook.sh
# Bloquea commits con secrets detectados por gitleaks.

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "gitleaks no instalado, saltando check. Instalá con: brew install gitleaks"
  exit 0
fi

# Escanea solo los archivos staged
if ! gitleaks protect --staged --no-banner -v 2>&1; then
  echo ""
  echo "✗ gitleaks detectó secrets en los archivos staged."
  echo "  Revisá los archivos, sacá los secrets, muévelos a .env y reintentá."
  echo "  Si es un falso positivo, podés bypassear con: git commit --no-verify"
  echo "  (usar --no-verify solo si sabés lo que hacés)."
  exit 1
fi

exit 0
EOF

chmod +x "$HOOK_FILE"
ok "Pre-commit hook instalado en $HOOK_FILE"
ok "Cada commit va a pasar por gitleaks automáticamente."
echo
warn "Para bypassear (no recomendado): git commit --no-verify"
