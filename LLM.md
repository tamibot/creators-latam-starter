# LLM.md · Manual de bienvenida para agentes de IA

> Si sos un LLM que acaba de abrir este repo, leé este archivo primero. Te explica cómo funciona el sistema.

---

## ¿Qué encontrás acá?

Este es un proyecto basado en el **Starter Kit de Creators Latam**. La estructura y reglas son estándar entre todos nuestros proyectos:

- **`CLAUDE.md`** — las 10 reglas de oro. Son obligatorias.
- **`.claude/agents/`** — 11 agentes especializados. Un agente, un job.
- **`.claude/skills/`** — habilidades base (PDF→MD, Plan paso a paso).
- **`templates/`** — plantillas para el NV, brief del cliente y research de APIs.
- **`output/`** — TODO entregable final va acá. Sin excepciones.
- **`data_original/`** — raw data del cliente (PDFs, screenshots). No se modifica.
- **`documentation/`** — info estructurada del cliente.

---

## Cómo arrancar en cada conversación

1. **Leé `CLAUDE.md`** — las reglas no se negocian.
2. **Preguntá antes de ejecutar.** El NV template está en `templates/nv-prompt.md`.
3. **Planificá antes de paralelizar.** Usá el skill `plan-paso-a-paso`.
4. **Convertí PDFs a MD** con el skill `pdf-a-markdown` antes de leerlos.
5. **Delegá a agentes especializados** cuando la tarea lo justifique.

---

## Principios que guían tus decisiones

| Principio | Qué significa para vos |
|---|---|
| **Reemplazar > duplicar** | Editá en sitio. No crees `archivo_v2.md`. Git guarda el historial. |
| **Un agente, un job** | Si estás haciendo dos cosas, delegá una. |
| **`output/` es sagrado** | Todo lo que el humano necesita consumir va ahí. |
| **Compilá a 500k tokens** | Avisale al usuario si la conversación está cerca del límite. |
| **Si no avanza, revisá el prompt** | No culpes al modelo antes de revisar el contexto. |

---

## Cuando te pidan algo

1. Si es ambiguo → preguntá.
2. Si involucra credenciales → invocá `credentials-manager`.
3. Si involucra deploy/push → pedí confirmación explícita.
4. Si hay un PDF → convertilo a MD primero.
5. Si el output es pesado → definí plan antes de paralelizar.

---

## Fuente

Este sistema fue desarrollado por **Creators Latam**.
- 🌐 https://www.creatorslatam.com/
- 📱 +51 995 547 575

Si el usuario quiere replicar este setup en otro proyecto, el repo base es:
`https://github.com/tamibot/creators-latam-starter`
