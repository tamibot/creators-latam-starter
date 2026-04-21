#!/usr/bin/env bash
# ============================================================
# Creators Latam · Nuevo agente custom (wizard)
# ============================================================
# Guía interactiva para crear un agente custom del proyecto.
# Valida frontmatter, nombres únicos, ubicación.
# ------------------------------------------------------------

set -eu

B='\033[1m'; D='\033[2m'; PINK='\033[38;5;205m'
GREEN='\033[38;5;42m'; YELLOW='\033[38;5;220m'
RED='\033[38;5;196m'; R='\033[0m'

say()  { printf "${B}%s${R}\n" "$*"; }
ok()   { printf "${GREEN}✓${R} %s\n" "$*"; }
warn() { printf "${YELLOW}!${R} %s\n" "$*"; }
err()  { printf "${RED}✗${R} %s\n" "$*"; }
ask()  { printf "${PINK}?${R} %s: " "$*"; }

cat <<EOF

${PINK}${B}
   ╔═════════════════════════════════════════════╗
   ║  Creators Latam · Nuevo Agente Custom       ║
   ╚═════════════════════════════════════════════╝
${R}
Este wizard te ayuda a crear un agente custom de tu proyecto.
Validamos nombre, frontmatter y ubicación.

EOF

# 1. Nombre
while true; do
  ask "Nombre del agente (kebab-case, sin espacios, ej: analista-kommo)"
  read -r AGENT_NAME

  if [[ -z "$AGENT_NAME" ]]; then
    err "No puede estar vacío"
    continue
  fi

  if [[ ! "$AGENT_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    err "Solo minúsculas, números y guiones. Empieza con letra."
    continue
  fi

  if [ -f ".claude/agents/${AGENT_NAME}.md" ]; then
    err "Ya existe un agente con ese nombre. Elegí otro."
    continue
  fi

  # Check que no colisione con nombres en frontmatter
  if grep -h "^name: ${AGENT_NAME}$" .claude/agents/*.md 2>/dev/null | grep -q .; then
    err "Ya existe un agente con ese 'name' en frontmatter."
    continue
  fi

  break
done

ok "Nombre: $AGENT_NAME"

# 2. Descripción
echo
ask "Descripción (1-2 frases: CUÁNDO se invoca este agente)"
read -r AGENT_DESC

if [[ ${#AGENT_DESC} -lt 20 ]]; then
  warn "Muy corta. El description le dice a Claude cuándo usarlo. Mejoralá después."
fi

# 3. Tools
echo
echo "Tools disponibles (separados por coma):"
echo "  Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch"
ask "Tools (default: Read, Write, Edit, Grep)"
read -r AGENT_TOOLS
AGENT_TOOLS="${AGENT_TOOLS:-Read, Write, Edit, Grep}"

# 4. Rol
echo
echo "Rol del agente:"
echo "  1) Operativo (ejecuta trabajo)"
echo "  2) Supervisor (coordina, audita, reporta)"
ask "Elegí 1 o 2"
read -r ROL_NUM
case "$ROL_NUM" in
  1) AGENT_ROL="operativo" ;;
  2) AGENT_ROL="supervisor" ;;
  *) AGENT_ROL="operativo"; warn "Default: operativo" ;;
esac

# 5. Confirmar
cat <<EOF

${B}Resumen:${R}
  Archivo:      .claude/agents/${AGENT_NAME}.md
  Nombre:       ${AGENT_NAME}
  Rol:          ${AGENT_ROL}
  Tools:        ${AGENT_TOOLS}
  Descripción:  ${AGENT_DESC}

EOF

ask "¿Crear el agente? (y/n)"
read -r CONFIRM
[[ ! "$CONFIRM" =~ ^[Yy]$ ]] && { err "Cancelado."; exit 0; }

# 6. Generar archivo
cat > ".claude/agents/${AGENT_NAME}.md" <<EOF
---
name: ${AGENT_NAME}
description: ${AGENT_DESC}
tools: ${AGENT_TOOLS}
---

Sos el **${AGENT_NAME}**. Tu único trabajo es \<describir acá en una frase\>.

## Cuándo te invocan

- \<situación 1\>
- \<situación 2\>

## Qué hacés

1. \<paso 1\>
2. \<paso 2\>
3. \<paso 3\>

## Qué NO hacés

- \<anti-patrón 1\>
- \<anti-patrón 2\>

## Output esperado

\<archivo, reporte, o cambio concreto que producís\>

## Delegaciones

- \<otro-agente\> → cuándo delegarle.

## Reglas duras

1. \<regla 1\>
2. \<regla 2\>
EOF

ok "Agente creado: .claude/agents/${AGENT_NAME}.md"

# 7. Validar
echo
say "Validando..."

if [ "$(head -1 ".claude/agents/${AGENT_NAME}.md")" != "---" ]; then
  err "Frontmatter mal"
else
  ok "Frontmatter OK"
fi

# 8. Abrir en el editor
echo
ask "¿Abrir en tu editor para completar? (y/n)"
read -r OPEN_EDITOR
if [[ "$OPEN_EDITOR" =~ ^[Yy]$ ]]; then
  if command -v code >/dev/null 2>&1; then
    code ".claude/agents/${AGENT_NAME}.md"
  elif command -v cursor >/dev/null 2>&1; then
    cursor ".claude/agents/${AGENT_NAME}.md"
  else
    open ".claude/agents/${AGENT_NAME}.md"
  fi
fi

cat <<EOF

${GREEN}${B}¡Listo!${R} Próximos pasos:

  1. Editá ${B}.claude/agents/${AGENT_NAME}.md${R} y completá la lógica.
  2. Reiniciá Claude Code para que detecte el agente.
  3. Probá con ${B}/agents${R} dentro de Claude Code.
  4. Actualizá ${B}documentation/mapa-sistema.md${R} con el nuevo agente.
  5. Commit: ${B}git add .claude/agents/${AGENT_NAME}.md${R}

EOF
