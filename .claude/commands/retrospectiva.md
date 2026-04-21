---
description: Arranca la retrospectiva post-proyecto con el template y consolida hallazgos.
---

Vamos a cerrar el proyecto con una retrospectiva estructurada que alimente al `analizador-patrones`.

Pasos:
1. Chequear si existe `documentation/retrospectiva.md`. Si no, copiar `templates/retrospectiva.md` ahí.
2. Preguntame participantes, duración del proyecto, y satisfacción del cliente (1-10).
3. Ir sección por sección:
   - **Números** (desvío tiempo/horas/budget).
   - **Qué funcionó / regular / no funcionó**.
   - **Decisiones clave** con resultado.
   - **Agentes MVP / problemáticos / custom**.
   - **Stack aprendizajes**.
   - **Costos aprendizajes**.
   - **Equipo y colaboración**.
   - **3 aprendizajes transferibles**.
4. Preguntá si hay cambios a proponer al **starter base** (nuevos agentes, skills, reglas, templates).
5. Generá tags al final para que el `analizador-patrones` cruce.

Al terminar:
- Commit: `git add documentation/retrospectiva.md && git commit -m "docs: retro de cierre de proyecto"`.
- Sugerime crear issue al starter con label `improvement-from-project` si hay propuestas.
