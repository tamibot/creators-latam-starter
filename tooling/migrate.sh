#!/usr/bin/env bash
# ============================================================
# Creators Latam · Migrate from starter
# ============================================================
# Actualiza tu proyecto a la última versión del starter.
# - Agrega el starter como remote si no existe.
# - Trae los cambios vía merge.
# - Reporta conflictos (NO los resuelve automáticamente).
#
# Uso:
#   ./tooling/migrate.sh            # dry-run: muestra qué cambiaría
#   ./tooling/migrate.sh --apply    # aplica el merge
# ------------------------------------------------------------

set -u

B='\033[1m'; GREEN='\033[38;5;42m'; YELLOW='\033[38;5;220m'
RED='\033[38;5;196m'; PINK='\033[38;5;205m'; D='\033[2m'; R='\033[0m'

say()  { printf "${B}%s${R}\n" "$*"; }
ok()   { printf "  ${GREEN}✓${R} %s\n" "$*"; }
warn() { printf "  ${YELLOW}!${R} %s\n" "$*"; }
err()  { printf "  ${RED}✗${R} %s\n" "$*"; }
info() { printf "  ${D}%s${R}\n" "$*"; }
hr()   { printf "${D}─────────────────────────────────────────────${R}\n"; }

APPLY=false
[[ "${1:-}" == "--apply" ]] && APPLY=true

STARTER_REMOTE_URL="https://github.com/tamibot/creators-latam-starter.git"
STARTER_REMOTE_NAME="starter"
STARTER_BRANCH="main"

cat <<EOF

${PINK}${B}
   ╔═════════════════════════════════════════════╗
   ║    Creators Latam · Starter Migration       ║
   ╚═════════════════════════════════════════════╝
${R}

Este script sincroniza tu proyecto con la última versión del starter.
EOF

[ "$APPLY" = true ] || info "Modo dry-run. Agregá ${B}--apply${R} para ejecutar."
echo
hr

# ============================================================
# 1. Pre-flight
# ============================================================
say "1. Pre-flight"

if [ ! -d .git ]; then
  err "No estás en un repo git. Abortando."
  exit 1
fi
ok "Repo git OK"

if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  warn "Tenés cambios sin commitear:"
  git status --short | head -10 | sed 's/^/    /'
  if [ "$APPLY" = true ]; then
    err "Commiteá o stasheá antes de migrar. Abortando."
    exit 1
  fi
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
ok "Branch actual: $CURRENT_BRANCH"
hr

# ============================================================
# 2. Configurar remote del starter
# ============================================================
say "2. Remote del starter"

if git remote | grep -q "^${STARTER_REMOTE_NAME}$"; then
  CURRENT_URL=$(git remote get-url "$STARTER_REMOTE_NAME")
  if [ "$CURRENT_URL" != "$STARTER_REMOTE_URL" ]; then
    warn "Remote 'starter' apunta a $CURRENT_URL"
    if [ "$APPLY" = true ]; then
      git remote set-url "$STARTER_REMOTE_NAME" "$STARTER_REMOTE_URL"
      ok "Remote actualizado a $STARTER_REMOTE_URL"
    fi
  else
    ok "Remote 'starter' OK"
  fi
else
  info "Remote 'starter' no existe."
  if [ "$APPLY" = true ]; then
    git remote add "$STARTER_REMOTE_NAME" "$STARTER_REMOTE_URL"
    ok "Remote 'starter' agregado"
  else
    info "[dry-run] Agregaría: git remote add starter $STARTER_REMOTE_URL"
  fi
fi
hr

# ============================================================
# 3. Fetch
# ============================================================
say "3. Fetch del starter"

if [ "$APPLY" = true ]; then
  git fetch "$STARTER_REMOTE_NAME" "$STARTER_BRANCH" 2>&1 | sed 's/^/  /'
  ok "Fetch OK"
else
  info "[dry-run] Ejecutaría: git fetch $STARTER_REMOTE_NAME $STARTER_BRANCH"
fi
hr

# ============================================================
# 4. Mostrar cambios que vendrían
# ============================================================
say "4. Preview de cambios"

if git rev-parse "${STARTER_REMOTE_NAME}/${STARTER_BRANCH}" >/dev/null 2>&1; then
  info "Commits nuevos del starter (últimos 10):"
  git log --oneline "HEAD..${STARTER_REMOTE_NAME}/${STARTER_BRANCH}" 2>/dev/null | head -10 | sed 's/^/    /'
  echo

  info "Archivos que cambiarían (resumen):"
  git diff --stat "HEAD...${STARTER_REMOTE_NAME}/${STARTER_BRANCH}" 2>/dev/null | head -20 | sed 's/^/    /'
  echo
else
  info "Fetch aún no hecho — correr con --apply primero para ver el preview."
fi
hr

# ============================================================
# 5. Merge (solo con --apply)
# ============================================================
say "5. Merge"

if [ "$APPLY" != true ]; then
  info "[dry-run] Ejecutaría:"
  info "    git merge ${STARTER_REMOTE_NAME}/${STARTER_BRANCH} --allow-unrelated-histories"
  echo
  info "Para aplicar, volvé a correr con ${B}--apply${R}"
  exit 0
fi

info "Mergeando ${STARTER_REMOTE_NAME}/${STARTER_BRANCH}..."
if git merge "${STARTER_REMOTE_NAME}/${STARTER_BRANCH}" --allow-unrelated-histories --no-edit 2>&1 | sed 's/^/  /'; then
  echo
  MERGE_STATUS=$?
  if [ -z "$(git ls-files --unmerged)" ]; then
    ok "Merge completado sin conflictos"
    echo
    info "Próximos pasos:"
    info "  1. Revisar cambios: ${B}git log --oneline -10${R}"
    info "  2. Testear todo sigue funcionando"
    info "  3. Invocar ${B}archivero${R} para limpiar duplicados post-merge"
    info "  4. Pushear: ${B}git push origin ${CURRENT_BRANCH}${R}"
  fi
else
  echo
  err "Merge con conflictos."
  echo
  warn "Archivos en conflicto:"
  git diff --name-only --diff-filter=U | sed 's/^/    /'
  echo
  info "Pasos para resolver:"
  info "  1. Abrí cada archivo y resolvé los conflictos (buscá <<<<<<<)"
  info "  2. Invocá al agente ${B}versionador${R} si hay versiones duplicadas"
  info "  3. ${B}git add <archivos>${R}"
  info "  4. ${B}git commit${R} para cerrar el merge"
  info "  5. Correr ${B}./tooling/doctor.sh${R} para validar todo"
  echo
  info "Para abortar el merge: ${B}git merge --abort${R}"
  exit 1
fi
