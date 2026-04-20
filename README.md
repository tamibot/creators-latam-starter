# Creators Latam · Starter Kit para Proyectos con IA

> Un esqueleto listo para arrancar proyectos con Claude Code, Cursor, Codex, Antigravity o cualquier IDE con agentes de IA. Del caos al `output/` en minutos.

**Creators Latam** · [creatorslatam.com](https://www.creatorslatam.com/) · +51 995 547 575

---

## ¿Qué es esto?

Es el **repositorio base** que usamos internamente en Creators Latam para que cualquier proyecto nuevo arranque con:

- **11 agentes pre-configurados** (Documentador, GitHub Keeper, Tester, Arquitecto…)
- **2 skills fundacionales** (PDF → Markdown, Plan Paso a Paso)
- **Arquitectura de carpetas estándar** (`output/`, `data_original/`, `documentation/`…)
- **Templates** del "NV" (prompt de arranque con validación), brief de cliente y research de APIs
- **Reglas de oro** ya escritas en `CLAUDE.md` para que el modelo las siga desde el primer mensaje

Si trabajás con LLMs en serio, este repo te ahorra ~2 horas en cada proyecto nuevo.

---

## Uso rápido (3 pasos)

```bash
# 1. Clonar como base de un proyecto nuevo
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto
rm -rf .git && git init

# 2. Copiar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales reales (NUNCA se sube al repo)

# 3. Abrir con tu IDE favorito
claude       # Claude Code detecta .claude/agents y .claude/skills automáticamente
# o
cursor .
```

En Claude Code, al abrir el repo vas a ver los 11 agentes disponibles con `/agents` y podés invocarlos directamente.

---

## Estructura del proyecto

```
creators-latam-starter/
├── README.md             → este archivo
├── CLAUDE.md             → reglas de oro que Claude lee automáticamente
├── LLM.md                → manual de bienvenida para cualquier LLM
├── .env.example          → plantilla de credenciales
├── .claude/
│   ├── agents/           → los 11 agentes de Claude Code
│   └── skills/           → PDF→MD, Plan Paso a Paso
├── templates/            → NV prompt, brief cliente, research API
├── workflows/            → flujos específicos del proyecto
├── documentation/        → todo lo que te pasa el cliente
├── data_original/        → PDFs, screenshots, raw data
└── output/               → los entregables finales (lo único que el cliente ve)
```

---

## El escuadrón de agentes

Vive en `.claude/agents/`. Un agente, un job.

| # | Agente | Job |
|---|---|---|
| 01 | Documentador | Mantiene la documentación al día |
| 02 | GitHub Keeper | Commits, branches, orden del repo |
| 03 | Compilador de Datos | Junta, limpia y estructura datos |
| 04 | Chronicler | Registro operativo en vivo |
| 05 | Credentials Manager | Gestiona `.env` y accesos |
| 06 | Project Manager | Orden, tiempos, bloqueos |
| 07 | Tester | Único job: testeos |
| 08 | Integraciones | APIs, webhooks, servicios externos |
| 09 | Arquitecto | Revisa el plan antes de ejecutar |
| 10 | Versionador | Reemplaza > duplica. Usa git para historial |
| 11 | Purgador | Barre lo que ya no se usa |

Detalles completos en [`.claude/agents/`](./.claude/agents/).

---

## Skills fundacionales

Viven en `.claude/skills/`.

- **pdf-a-markdown** → convierte PDFs en MD porque los modelos leen MD 10× más rápido.
- **plan-paso-a-paso** → obliga al sistema a pensar antes de paralelizar.

---

## Las 10 reglas de oro (resumen)

1. **GitHub primero.** Repo conectado antes que nada.
2. **Un cliente = una carpeta madre.**
3. **Compilá a los 500k tokens.** No esperes al millón.
4. **Reemplazar > duplicar versiones.** Nada de `plan_v2_final_final.md`.
5. **Purgá lo que ya no se usa.** Carpeta limpia = contexto limpio.
6. **Todo lo final va a `output/`.** Cero excepciones.
7. **Un agente, un job.**
8. **El NV nunca arranca sin confirmar.** Ver `templates/nv-prompt.md`.
9. **Plan paso a paso > todo en paralelo.**
10. **Si no avanza, no es el modelo.** Es el prompt, el contexto o el plan.

Las reglas completas están en [`CLAUDE.md`](./CLAUDE.md).

---

## Filosofía: los tres pilares

1. **IDE** (Claude Code / Cursor / Antigravity) — la interfaz, donde vivís.
2. **Terminal** (bash / zsh) — el control, conecta con tu máquina.
3. **Nube** (GitHub) — el respaldo. Si no está en la nube, no existe.

---

## Contacto

¿Querés que montemos el sistema completo para tu empresa? Automatizamos gestión de clientes con ChatBots con IA + CRM, 24/7.

- 🌐 [creatorslatam.com](https://www.creatorslatam.com/)
- 📱 +51 995 547 575

---

**Creators Latam** · Documento vivo · v1.0
