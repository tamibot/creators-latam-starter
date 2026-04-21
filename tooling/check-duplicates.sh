#!/usr/bin/env bash
# ============================================================
# Creators Latam · Detector de duplicados
# ============================================================
# Busca agentes/skills con funcionalidad solapada.
# Detecta:
#   - Nombres similares (distancia Levenshtein)
#   - Descripciones con keywords solapadas
#   - Tools idénticos + descripciones similares
# ------------------------------------------------------------

set -u

B='\033[1m'; GREEN='\033[38;5;42m'; YELLOW='\033[38;5;220m'
RED='\033[38;5;196m'; PINK='\033[38;5;205m'; D='\033[2m'; R='\033[0m'

say()  { printf "${B}%s${R}\n" "$*"; }
ok()   { printf "  ${GREEN}✓${R} %s\n" "$*"; }
warn() { printf "  ${YELLOW}!${R} %s\n" "$*"; }
err()  { printf "  ${RED}✗${R} %s\n" "$*"; }
hr()   { printf "${D}─────────────────────────────────────────────${R}\n"; }

cat <<EOF

${PINK}${B}
   ╔═════════════════════════════════════════════╗
   ║    Creators Latam · Check Duplicates        ║
   ╚═════════════════════════════════════════════╝
${R}

Buscando agentes/skills con funcionalidad potencialmente duplicada.

EOF

ISSUES=0

# ============================================================
# 1. Nombres de agentes duplicados (exacto)
# ============================================================
say "1. Nombres de agentes — exactos"

DUP=$(grep -h "^name:" .claude/agents/*.md 2>/dev/null | sort | uniq -d)
if [ -n "$DUP" ]; then
  err "Nombres duplicados:"
  echo "$DUP" | sed 's/^/    /'
  ISSUES=$((ISSUES+1))
else
  ok "Sin nombres duplicados"
fi
hr

# ============================================================
# 2. Nombres similares (heurística simple)
# ============================================================
say "2. Nombres de agentes — similares"

# Extraer nombres sin prefijos comunes y sin sufijos
NAMES=$(ls .claude/agents/*.md 2>/dev/null | grep -v README | xargs -n1 basename | sed 's/\.md$//')
FOUND=0

while IFS= read -r name; do
  # Buscar nombres que compartan 2+ palabras o sean substrings
  while IFS= read -r other; do
    [ "$name" = "$other" ] && continue

    # ¿Uno contiene al otro?
    if [[ "$name" == *"$other"* ]] || [[ "$other" == *"$name"* ]]; then
      # Filtro de ruido
      if [[ ${#name} -gt 4 ]] && [[ ${#other} -gt 4 ]]; then
        warn "Nombres con substring: $name ↔ $other"
        FOUND=$((FOUND+1))
        ISSUES=$((ISSUES+1))
      fi
    fi

    # ¿Comparten 2+ palabras?
    IFS='-' read -ra N1 <<< "$name"
    IFS='-' read -ra N2 <<< "$other"
    SHARED=0
    for w1 in "${N1[@]}"; do
      for w2 in "${N2[@]}"; do
        [ ${#w1} -gt 3 ] && [ "$w1" = "$w2" ] && SHARED=$((SHARED+1))
      done
    done
    if [ "$SHARED" -ge 2 ]; then
      warn "$name ↔ $other comparten $SHARED palabras"
      FOUND=$((FOUND+1))
      ISSUES=$((ISSUES+1))
    fi
  done <<< "$NAMES"
done <<< "$NAMES" | sort -u

[ "$FOUND" -eq 0 ] && ok "Sin nombres similares detectados"
hr

# ============================================================
# 3. Descripciones con keywords solapadas
# ============================================================
say "3. Descripciones con funciones solapadas"

# Keywords críticas que indican overlap si aparecen en múltiples agentes
KEYWORDS=(
  "convierte PDF"
  "genera Excel"
  "genera PDF"
  "audita"
  "valida credenciales"
  "primera reunión"
  "orquesta"
  "delega"
  "conecta APIs"
  "integra"
)

for kw in "${KEYWORDS[@]}"; do
  matches=$(grep -li "$kw" .claude/agents/*.md 2>/dev/null | grep -v README | wc -l | tr -d ' ')
  if [ "$matches" -gt 1 ]; then
    warn "Keyword \"$kw\" aparece en $matches agentes:"
    grep -li "$kw" .claude/agents/*.md 2>/dev/null | grep -v README | xargs -n1 basename | sed 's/^/    /'
    ISSUES=$((ISSUES+1))
  fi
done
hr

# ============================================================
# 4. Tools idénticos + descripción similar
# ============================================================
say "4. Agentes con mismo set de tools"

# Extraer (nombre, tools) por agente
TEMPFILE=$(mktemp)
for f in .claude/agents/*.md; do
  [[ "$(basename "$f")" == "README.md" ]] && continue
  NAME=$(grep "^name:" "$f" | head -1 | cut -d: -f2 | tr -d ' ')
  TOOLS=$(grep "^tools:" "$f" | head -1 | cut -d: -f2 | tr -d ' ' | tr ',' '\n' | sort -u | paste -sd, -)
  echo "$TOOLS|$NAME" >> "$TEMPFILE"
done

DUP_TOOLS=$(cut -d'|' -f1 "$TEMPFILE" | sort | uniq -d)
if [ -n "$DUP_TOOLS" ]; then
  while IFS= read -r tools_set; do
    [ -z "$tools_set" ] && continue
    AGENTS=$(grep "^${tools_set}|" "$TEMPFILE" | cut -d'|' -f2 | paste -sd, -)
    warn "Mismo set de tools [$tools_set]:"
    echo "    → agentes: $AGENTS"
    echo "    (chequear manualmente si hacen cosas distintas)"
  done <<< "$DUP_TOOLS"
else
  ok "Sin sets idénticos de tools"
fi
rm -f "$TEMPFILE"
hr

# ============================================================
# 5. Skills duplicados
# ============================================================
say "5. Skills"

DUP_SKILLS=$(grep -h "^name:" .claude/skills/*/SKILL.md 2>/dev/null | sort | uniq -d)
if [ -n "$DUP_SKILLS" ]; then
  err "Skills con nombres duplicados:"
  echo "$DUP_SKILLS" | sed 's/^/    /'
  ISSUES=$((ISSUES+1))
else
  ok "Sin skills duplicados"
fi
hr

# ============================================================
# 6. Templates redundantes (heurística simple)
# ============================================================
say "6. Templates potencialmente redundantes"

# Templates con tamaños similares + keywords cruzadas → sospechoso
TEMPLATE_COUNT=$(ls templates/*.md 2>/dev/null | wc -l | tr -d ' ')
ok "$TEMPLATE_COUNT templates encontrados"

# Check específico: si existen brief-cliente.md Y plan-maestro.md, brief puede ser redundante
if [ -f templates/brief-cliente.md ] && [ -f templates/plan-maestro.md ]; then
  warn "brief-cliente.md + plan-maestro.md ambos existen."
  warn "Revisá si brief-cliente es redundante con Fase 1 del plan-maestro."
fi
hr

# ============================================================
# RESUMEN
# ============================================================
echo
if [ "$ISSUES" -eq 0 ]; then
  ok "${B}✨ Sin duplicados detectados.${R}"
  exit 0
else
  warn "${B}Se encontraron $ISSUES posibles duplicados.${R}"
  warn "Son advertencias — revisá manualmente. Puede que sean intencionales."
  exit 0
fi
