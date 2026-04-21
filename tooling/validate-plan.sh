#!/usr/bin/env bash
# ============================================================
# Creators Latam · Validador del Plan Maestro
# ============================================================
# Verifica que documentation/plan-maestro.md tenga las 3 fases
# completas y firmadas ANTES de permitir ejecución del proyecto.
#
# Exit code:
#   0 = plan firmado, OK avanzar
#   1 = plan no firmado o faltante
#
# Uso como pre-flight:
#   ./tooling/validate-plan.sh && echo "Puedo ejecutar"
# ------------------------------------------------------------

set -u

B='\033[1m'; GREEN='\033[38;5;42m'; YELLOW='\033[38;5;220m'
RED='\033[38;5;196m'; PINK='\033[38;5;205m'; D='\033[2m'; R='\033[0m'

ok()   { printf "${GREEN}✓${R} %s\n" "$*"; }
warn() { printf "${YELLOW}!${R} %s\n" "$*"; }
err()  { printf "${RED}✗${R} %s\n" "$*"; }

PLAN=documentation/plan-maestro.md

printf "\n${PINK}${B}Validador del Plan Maestro${R}\n\n"

# 1. Existe?
if [ ! -f "$PLAN" ]; then
  err "$PLAN no existe."
  echo
  echo "Arrancá invocando al agente ${B}onboarding-pm${R} en Claude Code:"
  echo "    $ claude"
  echo "    > Invocá onboarding-pm para armar el Plan Maestro"
  echo
  exit 1
fi
ok "$PLAN existe"

# 2. Tiene las 3 fases?
FASE1=$(grep -c "^## 🎯 FASE 1" "$PLAN" 2>/dev/null || echo 0)
FASE2=$(grep -c "^## 🛠️ FASE 2" "$PLAN" 2>/dev/null || echo 0)
FASE3=$(grep -c "^## 👥 FASE 3" "$PLAN" 2>/dev/null || echo 0)

if [ "$FASE1" -eq 0 ] || [ "$FASE2" -eq 0 ] || [ "$FASE3" -eq 0 ]; then
  err "Falta alguna fase del plan:"
  [ "$FASE1" -eq 0 ] && echo "    ✗ FASE 1 · Entregables"
  [ "$FASE2" -eq 0 ] && echo "    ✗ FASE 2 · Stack Tecnológico"
  [ "$FASE3" -eq 0 ] && echo "    ✗ FASE 3 · Equipo y Plan"
  echo
  echo "Volvé al agente onboarding-pm a completar."
  exit 1
fi
ok "Las 3 fases presentes en el plan"

# 3. Entregables definidos (Fase 1)?
if ! grep -q "Formato" "$PLAN" || ! grep -q "Columnas" "$PLAN"; then
  warn "Fase 1 parece incompleta (no encuentro formato/columnas de entregables)"
fi

# 4. Stack documentado (Fase 2)?
if ! grep -q "Stack final" "$PLAN"; then
  warn "Fase 2 parece incompleta (falta 'Stack final')"
fi

# 5. Equipo y Gantt (Fase 3)?
if ! grep -q "Plan de trabajo" "$PLAN" && ! grep -q "gantt" "$PLAN"; then
  warn "Fase 3 parece incompleta (falta plan de trabajo con Gantt)"
fi

# 6. FIRMAS — esto es lo crítico
# Patrón esperado: "Aprobado por cliente: [nombre] fecha: [YYYY-MM-DD]"
FIRMAS_CLIENTE=$(grep -cE "Aprobado por cliente: +[A-Za-zÀ-ÿ].* fecha: *[0-9]{4}-[0-9]{2}-[0-9]{2}" "$PLAN" 2>/dev/null || echo 0)
FIRMAS_CL=$(grep -cE "Aprobado por Creators Latam: +[A-Za-zÀ-ÿ].* fecha: *[0-9]{4}-[0-9]{2}-[0-9]{2}" "$PLAN" 2>/dev/null || echo 0)

echo
printf "${B}Firmas detectadas:${R}\n"
printf "  Cliente:            %s / 3\n" "$FIRMAS_CLIENTE"
printf "  Creators Latam:     %s / 3\n" "$FIRMAS_CL"

if [ "$FIRMAS_CLIENTE" -lt 3 ] || [ "$FIRMAS_CL" -lt 3 ]; then
  echo
  err "Plan Maestro ${B}NO está firmado${R} en todas las fases."
  echo
  echo "Cada fase tiene que tener dos firmas al final:"
  echo "    **Aprobado por cliente:** <nombre> fecha: YYYY-MM-DD"
  echo "    **Aprobado por Creators Latam:** <nombre> fecha: YYYY-MM-DD"
  echo
  err "${B}Ejecución BLOQUEADA${R} hasta obtener firmas."
  exit 1
fi

echo
ok "${B}Plan Maestro firmado en las 3 fases ✓${R}"
ok "${B}Listo para ejecución.${R}"
echo
echo "Próximo paso: invocar al agente ${B}orquestador${R} para arrancar."
echo
exit 0
