# Agentes · Creators Latam Starter

Los **11 agentes base** que montamos en todo proyecto. Un agente, un job.

Claude Code los detecta automáticamente desde esta carpeta. Invocalos con `/agents` o dejá que Claude delegue por sí mismo cuando la descripción del agente coincida con la tarea.

| # | Nombre | Job en una línea |
|---|---|---|
| 01 | [`documentador`](documentador.md) | Mantiene la documentación al día |
| 02 | [`github-keeper`](github-keeper.md) | Commits, branches, orden del repo |
| 03 | [`compilador-datos`](compilador-datos.md) | Junta, limpia y estructura datos |
| 04 | [`chronicler`](chronicler.md) | Bitácora viva del proyecto |
| 05 | [`credentials-manager`](credentials-manager.md) | `.env` y accesos — último filtro antes de commit |
| 06 | [`project-manager`](project-manager.md) | Visión de arriba, prioridades, delegaciones |
| 07 | [`tester`](tester.md) | Sólo testeos. No arregla bugs |
| 08 | [`integraciones`](integraciones.md) | APIs, webhooks, pegamento entre sistemas |
| 09 | [`arquitecto`](arquitecto.md) | Revisa planes antes de ejecutar |
| 10 | [`versionador`](versionador.md) | Reemplaza > duplica. Confía en git |
| 11 | [`purgador`](purgador.md) | Barre lo muerto. Carpeta limpia = contexto limpio |

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
