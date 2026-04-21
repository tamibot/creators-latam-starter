---
description: Genera el dashboard de estado del proyecto y lo muestra inline.
---

Invocá al agente `status-dashboard` para generar `documentation/status.md` con el estado actual del proyecto.

Pasos:
1. Invocar al agente `status-dashboard`.
2. Leer el archivo generado `documentation/status.md`.
3. Mostrármelo inline, respetando el formato Markdown (especialmente el Gantt de Mermaid).
4. Si detectás bloqueos o riesgos rojos, resaltálos al inicio.
5. Sugerirme el próximo paso según el estado.

Si el proyecto aún no tiene `plan-maestro.md`, decime que arrancaste mal: debés primero invocar al `onboarding-pm`.
