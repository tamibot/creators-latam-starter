# Agentes · Creators Latam Starter

Los **22 agentes base** que montamos en todo proyecto. Un agente, un job.

Claude Code los detecta automáticamente desde esta carpeta. Invocalos con `/agents` o dejá que Claude delegue por sí mismo cuando la descripción del agente coincida con la tarea.

## Supervisores (7 · coordinan, auditan, aprenden)

El trabajo fluye de arriba hacia abajo: **Kickoff Cliente** abre el proyecto, **Onboarding PM** arranca con las 3 fases, y una vez firmado el Plan Maestro, el **Orquestador** toma el relevo para ejecutar.

| # | Nombre | Job en una línea |
|---|---|---|
| 18 | [`kickoff-cliente`](kickoff-cliente.md) 🚀 | Primera reunión con cliente nuevo — minuta + brief + preview |
| 15 | [`onboarding-pm`](onboarding-pm.md) ⭐ | Guía las 3 fases → produce Plan Maestro |
| 13 | [`orquestador`](orquestador.md) | Con plan aprobado: decide a quién delegar y en qué orden |
| 06 | [`project-manager`](project-manager.md) | Visión estratégica: estado, plazos, prioridades |
| 09 | [`arquitecto`](arquitecto.md) | Revisa planes técnicos antes de ejecutar |
| 14 | [`guardian-reglas`](guardian-reglas.md) | Audita las 10 reglas pre-commit/release |
| 19 | [`mapa-sistema`](mapa-sistema.md) 🗺️ | Catálogo visual de agentes/skills/integraciones |
| 20 | [`analizador-patrones`](analizador-patrones.md) 🧠 | Modo aprendizaje: patrones entre proyectos |

## Operativos (15 · ejecutan el trabajo)

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
| 12 | [`diagramador-mermaid`](diagramador-mermaid.md) | Diagramas Mermaid validados, 0 errores |
| 16 | [`test-debug-loop`](test-debug-loop.md) 🔁 | Loop prueba → error → fix → re-prueba |
| 17 | [`integrador-herramientas`](integrador-herramientas.md) 🔌 | Conecta APIs/MCP/n8n via la mejor opción |
| 21 | [`comentarios-adicionales`](comentarios-adicionales.md) 📝 | Feedback estructurado post-fase |
| 22 | [`archivero`](archivero.md) 🗄️ | Curador activo: versionador + purgador + naming + ubicación |

## Flujo del proyecto

```
Primera llamada con cliente
         │
         ▼
┌─────────────────────────────────────────┐
│  18 · kickoff-cliente                   │
│  Minuta + brief + preview entregables   │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│  15 · onboarding-pm                     │
│  ─ Fase 1: Entregables                  │
│  ─ Fase 2: Stack + research en foros    │
│  ─ Fase 3: Equipo y plan                │
│  → Plan Maestro firmado por cliente     │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│  13 · orquestador                       │
│  Descompone tareas y delega             │
└─────────────────────────────────────────┘
         │
    ┌────┴─────┬──────┬──────┬──────┬──────┐
    ▼          ▼      ▼      ▼      ▼      ▼
  01-12,    09     06     14    16-17,  custom
  22       arq.    PM   guardian 21-22   proyecto
  operativos                    (nuevos)
         │                             │
         └─────────────┬───────────────┘
                       ▼
              14 · guardian-reglas
              (antes de cada commit / release)
                       ▼
              21 · comentarios-adicionales
              (feedback post-fase)
                       ▼
              20 · analizador-patrones
              (mensualmente, analiza N proyectos)
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
4. CI valida frontmatter automáticamente en cada push.

## Orden de invocación ideal

- **Primera llamada con cliente:** `kickoff-cliente`.
- **Proyecto nuevo post-kickoff:** `onboarding-pm` → las 3 fases.
- **Tareas post-plan:** `orquestador` delega a los especialistas.
- **Conectar una herramienta externa:** `integrador-herramientas`.
- **Debugear un flujo que falla:** `test-debug-loop`.
- **Antes de commit grande:** `guardian-reglas`.
- **Antes de ejecutar con impacto:** `arquitecto`.
- **Limpieza periódica:** `archivero`.
- **Ver el inventario completo:** `mapa-sistema`.
- **Post-fase o handoff:** `comentarios-adicionales` pide feedback.
- **Mensualmente (interno):** `analizador-patrones`.
