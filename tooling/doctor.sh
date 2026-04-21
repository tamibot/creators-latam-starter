#!/usr/bin/env bash
# ============================================================
# Creators Latam · Starter · Doctor
# ============================================================
# Diagnóstico del estado actual del proyecto.
# Chequea: herramientas, frontmatter agentes, env vars,
# git remote, plan maestro, permisos archivos.
#
# Uso:
#   ./tooling/doctor.sh            # solo reportar
#   ./tooling/doctor.sh --fix      # aplicar fixes seguros
# ------------------------------------------------------------

set -u

B='\033[1m'; D='\033[2m'; PINK='\033[38;5;205m'; GREEN='\033[38;5;42m'
YELLOW='\033[38;5;220m'; RED='\033[38;5;196m'; R='\033[0m'

say()  { printf "${B}%s${R}\n" "$*"; }
ok()   { printf "  ${GREEN}✓${R} %s\n" "$*"; }
warn() { printf "  ${YELLOW}!${R} %s\n" "$*"; }
err()  { printf "  ${RED}✗${R} %s\n" "$*"; }
info() { printf "  ${D}%s${R}\n" "$*"; }
hr()   { printf "${D}─────────────────────────────────────────────${R}\n"; }

FIX_MODE=false
[[ "${1:-}" == "--fix" ]] && FIX_MODE=true

ISSUES=0
FIXED=0

cat <<EOF

${PINK}${B}
   ╔═════════════════════════════════════════════╗
   ║      Creators Latam · Project Doctor        ║
   ╚═════════════════════════════════════════════╝
${R}
EOF

[ "$FIX_MODE" = true ] && info "Modo --fix: aplica correcciones seguras automáticamente."
echo
hr

# ============================================================
# 1. HERRAMIENTAS BASE
# ============================================================
say "1. Herramientas base"
for cmd in git brew python3 node claude; do
  if command -v "$cmd" &>/dev/null; then
    ok "$cmd OK"
  else
    err "$cmd NO instalado"
    ISSUES=$((ISSUES+1))
  fi
done
hr

# ============================================================
# 2. GIT
# ============================================================
say "2. Git"

if [ ! -d .git ]; then
  err "No estás en un repo git. Corré: git init"
  ISSUES=$((ISSUES+1))
else
  ok "Repo git inicializado"

  if git remote -v | grep -q origin; then
    ok "Remote 'origin' configurado: $(git remote get-url origin)"
  else
    warn "Sin remote 'origin'. ¿Vas a trabajar local? Si no, agregá con: gh repo create"
  fi

  # Uncommitted changes
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    warn "Hay cambios sin commitear"
  fi
fi
hr

# ============================================================
# 3. .ENV
# ============================================================
say "3. Variables de entorno (.env)"

if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    if [ "$FIX_MODE" = true ]; then
      cp .env.example .env
      ok ".env creado desde .env.example"
      FIXED=$((FIXED+1))
    else
      warn ".env no existe. Ejecutá --fix o: cp .env.example .env"
    fi
  else
    warn "No hay .env ni .env.example"
  fi
else
  ok ".env existe"
  # Permisos
  perms=$(stat -f "%OLp" .env 2>/dev/null || stat -c "%a" .env 2>/dev/null)
  if [ "$perms" != "600" ]; then
    if [ "$FIX_MODE" = true ]; then
      chmod 600 .env
      ok "Permisos de .env corregidos a 600"
      FIXED=$((FIXED+1))
    else
      warn "Permisos de .env son $perms (recomendado: 600). Corregí con: chmod 600 .env"
      ISSUES=$((ISSUES+1))
    fi
  else
    ok "Permisos .env = 600"
  fi
fi

# .env no debe estar tracked por git
if [ -f .env ] && git ls-files --error-unmatch .env >/dev/null 2>&1; then
  err "¡CRÍTICO! .env está trackeado por git. Sacalo con: git rm --cached .env"
  ISSUES=$((ISSUES+1))
fi

if [ ! -f .gitignore ] || ! grep -q "^\.env$\|^\.env\*" .gitignore 2>/dev/null; then
  warn ".env no está en .gitignore"
fi
hr

# ============================================================
# 4. ESTRUCTURA DE CARPETAS
# ============================================================
say "4. Estructura canónica"
for dir in .claude/agents .claude/skills templates documentation output data_original workflows; do
  if [ -d "$dir" ]; then
    ok "$dir/"
  else
    if [ "$FIX_MODE" = true ]; then
      mkdir -p "$dir"
      touch "$dir/.gitkeep"
      ok "$dir/ creado"
      FIXED=$((FIXED+1))
    else
      warn "$dir/ no existe"
      ISSUES=$((ISSUES+1))
    fi
  fi
done
hr

# ============================================================
# 5. AGENTES · FRONTMATTER
# ============================================================
say "5. Agentes · frontmatter"
agent_count=0
bad_frontmatter=0
duplicate_names=0

if [ -d .claude/agents ]; then
  for f in .claude/agents/*.md; do
    [ -f "$f" ] || continue
    [[ "$(basename "$f")" == "README.md" ]] && continue
    agent_count=$((agent_count+1))

    if [ "$(head -1 "$f")" != "---" ]; then
      err "$f: no empieza con '---'"
      bad_frontmatter=$((bad_frontmatter+1))
      continue
    fi

    if ! head -10 "$f" | grep -q "^name:"; then
      err "$f: falta 'name:'"
      bad_frontmatter=$((bad_frontmatter+1))
    fi

    if ! head -10 "$f" | grep -q "^description:"; then
      err "$f: falta 'description:'"
      bad_frontmatter=$((bad_frontmatter+1))
    fi
  done

  # Nombres duplicados
  dup=$(grep -h "^name:" .claude/agents/*.md 2>/dev/null | sort | uniq -d)
  if [ -n "$dup" ]; then
    err "Nombres duplicados: $dup"
    duplicate_names=1
    ISSUES=$((ISSUES+1))
  fi

  if [ $bad_frontmatter -eq 0 ] && [ $duplicate_names -eq 0 ]; then
    ok "$agent_count agentes OK"
  else
    ISSUES=$((ISSUES + bad_frontmatter))
  fi
else
  warn ".claude/agents/ no existe"
fi
hr

# ============================================================
# 6. SKILLS
# ============================================================
say "6. Skills"
skill_count=0
if [ -d .claude/skills ]; then
  for d in .claude/skills/*/; do
    [ -d "$d" ] || continue
    skill="$d/SKILL.md"
    if [ -f "$skill" ]; then
      skill_count=$((skill_count+1))
      if [ "$(head -1 "$skill")" != "---" ]; then
        err "$skill: falta frontmatter"
        ISSUES=$((ISSUES+1))
      fi
    fi
  done
  ok "$skill_count skills encontrados"
else
  warn ".claude/skills/ no existe"
fi
hr

# ============================================================
# 7. SETTINGS.JSON
# ============================================================
say "7. Claude Code settings"
if [ -f .claude/settings.json ]; then
  if python3 -c "import json; data=json.load(open('.claude/settings.json')); assert 'permissions' in data and 'deny' in data['permissions']" 2>/dev/null; then
    ok "settings.json válido con deny rules"
  else
    err "settings.json inválido o falta deny rules"
    ISSUES=$((ISSUES+1))
  fi
else
  warn ".claude/settings.json no existe"
fi
hr

# ============================================================
# 8. PLAN MAESTRO
# ============================================================
say "8. Plan Maestro"
if [ -f documentation/plan-maestro.md ]; then
  ok "plan-maestro.md existe"
  # Buscar firmas
  firmas=$(grep -c "Aprobado por cliente: .*fecha: [0-9]" documentation/plan-maestro.md 2>/dev/null || echo 0)
  if [ "$firmas" -ge 3 ]; then
    ok "$firmas firmas detectadas (las 3 fases parecen firmadas)"
  elif [ "$firmas" -gt 0 ]; then
    warn "Solo $firmas firmas (necesitás 3, una por fase). Correr ./tooling/validate-plan.sh"
  else
    warn "Plan sin firmas. No deberías estar en ejecución aún."
  fi
else
  info "Sin plan-maestro.md. Si es proyecto nuevo → invocar agente 'onboarding-pm'"
fi
hr

# ============================================================
# 9. GITLEAKS (opcional pero recomendado)
# ============================================================
say "9. Secrets scanning"
if command -v gitleaks &>/dev/null; then
  if gitleaks detect --source . --no-git --no-banner -q 2>/dev/null; then
    ok "gitleaks: sin secrets detectados"
  else
    err "gitleaks encontró posibles secrets. Correr: gitleaks detect --source . --no-git --verbose"
    ISSUES=$((ISSUES+1))
  fi

  # Hook instalado?
  if [ -f .git/hooks/pre-commit ] && grep -q gitleaks .git/hooks/pre-commit 2>/dev/null; then
    ok "pre-commit hook de gitleaks activo"
  else
    warn "Recomendado instalar pre-commit hook: ./tooling/install-gitleaks-hook.sh"
  fi
else
  warn "gitleaks no instalado. Recomendado: brew install gitleaks"
fi
hr

# ============================================================
# 10. ARCHIVOS GRANDES COMMITEADOS
# ============================================================
say "10. Archivos grandes"
if [ -d .git ]; then
  large=$(git ls-files 2>/dev/null | xargs -I {} sh -c 'size=$(stat -f "%z" "{}" 2>/dev/null || stat -c "%s" "{}" 2>/dev/null); if [ "$size" -gt 5242880 ]; then echo "{} ($(( size / 1024 / 1024 ))MB)"; fi' 2>/dev/null || true)
  if [ -n "$large" ]; then
    warn "Archivos >5MB commiteados (mejor en data_original/ con .gitignore):"
    echo "$large" | sed 's/^/    /'
  else
    ok "Sin archivos grandes commiteados"
  fi
fi
hr

# ============================================================
# RESUMEN
# ============================================================
echo
if [ $ISSUES -eq 0 ]; then
  ok "${B}✨ Todo OK. El proyecto está sano.${R}"
  [ $FIXED -gt 0 ] && info "Corregidas automáticamente: $FIXED"
  exit 0
else
  err "${B}Se encontraron $ISSUES issues.${R}"
  [ $FIXED -gt 0 ] && info "Corregidas automáticamente: $FIXED"
  info "Correr con ${B}--fix${R} para aplicar correcciones seguras."
  info "Ver INSTALL.md para guía completa."
  exit 1
fi
