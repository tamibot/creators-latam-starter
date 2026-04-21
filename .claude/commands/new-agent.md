---
description: Crea un agente custom del proyecto usando el wizard interactivo.
---

Invocá el script `./tooling/new-agent.sh` que es un wizard interactivo para crear un agente custom del proyecto.

Pasos:
1. Confirmá que existe `./tooling/new-agent.sh`. Si no, avisame.
2. Preguntame:
   - **Nombre** del agente (kebab-case).
   - **Descripción** en 1-2 frases (cuándo se invoca).
   - **Tools** necesarios.
   - **Rol** (operativo o supervisor).
3. Ejecutá `./tooling/new-agent.sh` (el wizard preguntará lo mismo y generará el archivo).
4. Una vez generado, proponeme editar `.claude/agents/<nombre>.md` para completar la lógica.
5. Al terminar:
   - Sugerime correr `./tooling/check-duplicates.sh` para validar que no haya solape.
   - Sugerime actualizar `documentation/mapa-sistema.md` (invocar `mapa-sistema`).
   - Sugerime commit.
