---
name: plan-maestro
description: Genera el scaffold inicial del Plan Maestro (documentation/plan-maestro.md) con las 3 fases vacías listas para llenar. Úsalo al arranque de un proyecto nuevo — es el primer paso antes de que el agente onboarding-pm empiece a guiar las fases.
---

# Skill · Plan Maestro (scaffold generator)

## Cuándo invocarlo

Al arranque de cada proyecto nuevo, antes de que `onboarding-pm` comience a guiar las 3 fases. Este skill crea el **esqueleto** del documento con las 3 fases vacías listas para llenar.

## Qué hace

1. Chequea si `documentation/plan-maestro.md` ya existe.
2. Si no existe, copia `templates/plan-maestro.md` a `documentation/plan-maestro.md`.
3. Reemplaza placeholders (`<Cliente>`, `<Proyecto>`, fecha inicio) con info del contexto.
4. Reporta al usuario que el scaffold está listo y sugiere invocar al `onboarding-pm`.

## Uso

Dentro de Claude Code podés invocarlo de dos maneras:

### Opción 1 · Vía Claude directamente
> *"Usá el skill `plan-maestro` para generar el scaffold del plan."*

### Opción 2 · Vía comando directo
```bash
# Si el template existe, copiarlo
test -f documentation/plan-maestro.md && echo "Ya existe" || cp templates/plan-maestro.md documentation/plan-maestro.md

# Reemplazar placeholders (ejemplo con cliente "Acme")
sed -i '' "s|<Cliente>|Acme|g" documentation/plan-maestro.md
sed -i '' "s|<Proyecto>|Sistema de leads WhatsApp|g" documentation/plan-maestro.md
sed -i '' "s|YYYY-MM-DD|$(date +%Y-%m-%d)|g" documentation/plan-maestro.md
```

## Flujo estándar

```
Usuario arranca proyecto nuevo
         │
         ▼
Invoca skill `plan-maestro` → genera scaffold
         │
         ▼
Invoca agente `onboarding-pm` → guía las 3 fases
         │
         ▼
Fase 1 · Entregables (con firma)
         │
         ▼
Fase 2 · Stack (con firma)
         │
         ▼
Fase 3 · Equipo y Plan (con firma)
         │
         ▼
./tooling/validate-plan.sh → chequea firmas
         │
         ▼
Invoca agente `orquestador` → arranca ejecución
```

## Contexto a preguntar antes de generar

Antes de crear el scaffold, hay que tener mínimo:
- **Nombre del cliente** (ej: "Acme Corp")
- **Nombre del proyecto** (ej: "Sistema de leads WhatsApp")
- **Fecha de inicio** (default: hoy)
- **Responsable Creators Latam** (default: usuario actual)

Si falta info, pedírsela al usuario antes de generar.

## Validaciones post-generación

Después de crear el scaffold:
- [ ] El archivo existe en `documentation/plan-maestro.md`
- [ ] No quedaron placeholders `<Cliente>` ni `<Proyecto>` sin reemplazar
- [ ] La fecha de inicio está puesta
- [ ] Existe el directorio `documentation/stack/` (para la Fase 2)
- [ ] Existe el directorio `documentation/kickoff/` (para las reuniones)

Si alguno falla, reportar al usuario y sugerir correrlo a mano.

## Delegaciones

- Después de generar el scaffold → sugerir invocar a **`kickoff-cliente`** si aún no hubo primera reunión, o a **`onboarding-pm`** si ya hay brief.
- Si hay que validar firmas posteriormente → `./tooling/validate-plan.sh`.

## Anti-patrones

- ❌ Generar el scaffold y empezar a llenarlo sin preguntar al usuario.
- ❌ Reemplazar placeholders con datos inventados.
- ❌ Sobrescribir un `plan-maestro.md` existente sin confirmación.

## Ejemplo de mensaje al usuario post-generación

```
✓ Scaffold del Plan Maestro creado en `documentation/plan-maestro.md`.

Tiene las 3 fases vacías con checkpoints de firma.

Próximo paso:
- Si ya hiciste la primera reunión con el cliente: invocá `onboarding-pm`
  para empezar a llenar la Fase 1.
- Si no hubo reunión todavía: invocá `kickoff-cliente` primero.

Comando para validar firmas (cuando lleguen):
    $ ./tooling/validate-plan.sh
```
