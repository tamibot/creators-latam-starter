# Agentes · Creators Latam Starter

Los **14 agentes base** que montamos en todo proyecto. Un agente, un job.

Claude Code los detecta automáticamente desde esta carpeta. Invocalos con `/agents` o dejá que Claude delegue por sí mismo cuando la descripción del agente coincida con la tarea.

## Operativos (los que hacen el trabajo)

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

## Supervisores (los que coordinan y auditan)

| # | Nombre | Job en una línea |
|---|---|---|
| 06 | [`project-manager`](project-manager.md) | Visión estratégica: estado, prioridades, plazos |
| 09 | [`arquitecto`](arquitecto.md) | Revisa planes antes de ejecutar |
| 13 | [`orquestador`](orquestador.md) | Decide a quién delegar cada sub-tarea, y en qué orden |
| 14 | [`guardian-reglas`](guardian-reglas.md) | Audita que el proyecto cumpla las 10 reglas de oro |

## Jerarquía y flujo

```
Usuario → Orquestador
             │
             ├─→ Arquitecto (revisión de plan si corresponde)
             │
             ├─→ Agentes operativos (ejecutan)
             │       │
             │       └─→ Guardian-Reglas (audita antes de commit)
             │
             └─→ Project Manager (reporta estado al usuario)
```

## Cómo agregar un agente nuevo del proyecto

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
