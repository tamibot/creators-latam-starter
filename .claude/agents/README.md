# Agentes · Creators Latam Starter

Los **15 agentes base** que montamos en todo proyecto. Un agente, un job.

Claude Code los detecta automáticamente desde esta carpeta. Invocalos con `/agents` o dejá que Claude delegue por sí mismo cuando la descripción del agente coincida con la tarea.

## Supervisores (5 · coordinan y auditan)

El trabajo fluye de arriba hacia abajo: el **Onboarding PM** arranca todo proyecto nuevo con las 3 fases metodológicas. Una vez firmado el Plan Maestro, el **Orquestador** toma el relevo para ejecutar.

| # | Nombre | Job en una línea |
|---|---|---|
| 15 | [`onboarding-pm`](onboarding-pm.md) ⭐ | Arranca todo proyecto nuevo. Guía las 3 fases → produce Plan Maestro |
| 13 | [`orquestador`](orquestador.md) | Con plan aprobado: decide a quién delegar cada sub-tarea, en qué orden |
| 06 | [`project-manager`](project-manager.md) | Visión estratégica: estado, plazos, prioridades semanales |
| 09 | [`arquitecto`](arquitecto.md) | Revisa planes técnicos antes de ejecutar |
| 14 | [`guardian-reglas`](guardian-reglas.md) | Audita las 10 reglas de oro pre-commit/release |

## Operativos (10 · ejecutan el trabajo)

| # | Nombre | Job en una línea |
|---|---|---|
| 01 | [`documentador`](documentador.md) | Mantiene la documentación al día |
| 02 | [`github-keeper`](github-keeper.md) | Commits, branches, orden del repo |
| 03 | [`compilador-datos`](compilador-datos.md) | Junta, limpia y estructura datos |
| 04 | [`chronicler`](chronicler.md) | Bitácora viva del proyecto |
| 05 | [`credentials-manager`](credentials-manager.md) | `.env` y accesos — último filtro antes de commit |
| 07 | [`tester`](tester.md) | Sólo testeos. No arregla bugs |
| 08 | [`integraciones`](integraciones.md) | APIs, webhooks, pegamento entre sistemas |
| 10 | [`versionador`](versionador.md) | Reemplaza > duplica. Confía en git |
| 11 | [`purgador`](purgador.md) | Barre lo muerto. Carpeta limpia = contexto limpio |
| 12 | [`diagramador-mermaid`](diagramador-mermaid.md) | Diagramas Mermaid validados, 0 errores de sintaxis |

## Flujo del proyecto

```
Usuario arranca proyecto nuevo
         │
         ▼
┌─────────────────────────────────────────┐
│  15 · Onboarding PM                     │
│  ─ Fase 1: Entregables                  │
│  ─ Fase 2: Stack + research en foros    │
│  ─ Fase 3: Equipo y plan                │
│  → Plan Maestro firmado por cliente     │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│  13 · Orquestador                       │
│  Descompone tareas, delega a especialistas
└─────────────────────────────────────────┘
         │
    ┌────┴─────┬──────┬──────┬──────┐
    ▼          ▼      ▼      ▼      ▼
  01-12       09     06     14    custom
 operativos  arq.    PM   guardian  del proyecto
         │          │             │
         └──────────┴─────────────┘
                    │
                    ▼
         14 · Guardián de Reglas
         (antes de cada commit / release)
```

## Cómo agregar un agente nuevo del proyecto

Durante la **Fase 3 del Plan Maestro**, el `onboarding-pm` puede proponer agentes custom específicos (ej: `analista-kommo`, `generador-reportes-finanzas`).

1. Creá un archivo `mi-agente.md` en esta carpeta.
2. Respetá el formato frontmatter:
   ```markdown
   ---
   name: mi-agente
   description: Cuándo activarlo. Sé específico.
   tools: Read, Write, Bash, Grep
   ---

   Prompt del sistema para el agente.
   ```
3. Un agente = un job. Si se mezcla, reemplazá por dos agentes chicos.

## Nota: orden de invocación ideal

- **Proyecto nuevo:** siempre arranca con `onboarding-pm`.
- **Tareas post-plan:** `orquestador` delega a los especialistas.
- **Antes de commit grande:** `guardian-reglas` audita.
- **Antes de ejecución con impacto:** `arquitecto` revisa el plan técnico.
- **Reporte semanal:** `project-manager` consolida estado.
