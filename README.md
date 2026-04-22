# Creators Latam · Starter Kit

[![Version](https://img.shields.io/badge/version-1.11.0-ff3b77)](./CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/license-MIT-8b3fff)](./LICENSE)
[![Agentes](https://img.shields.io/badge/agentes-32-ff2d8a)](./.claude/agents/README.md)
[![Skills](https://img.shields.io/badge/skills-5-14b87a)](./.claude/skills/README.md)
[![CI](https://github.com/tamibot/creators-latam-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/tamibot/creators-latam-starter/actions/workflows/ci.yml)
[![Landing](https://img.shields.io/badge/landing-online-2563eb)](https://tamibot.github.io/creators-latam-starter/)

> **Una base para trabajar con IA — no una caja cerrada.**
>
> Metodología de 4 pasos (Entregable → Stack → Equipo → Plan), 32 agentes pre-configurados y 5 skills listos. Todo extensible: cada proyecto suma sus propios agentes y herramientas arriba de esta base.

**Creators Latam** · [creatorslatam.com](https://www.creatorslatam.com/) · +51 995 547 575

🌐 **Landing:** [tamibot.github.io/creators-latam-starter](https://tamibot.github.io/creators-latam-starter/)

---

## Qué es esto (y qué no es)

### ES
- Una **forma de trabajar** con IA validada en proyectos reales.
- Un **punto de partida** que se clona al arrancar cada proyecto.
- Una **base extensible**: 32 agentes + 5 skills + templates + tooling, sobre la cual cada proyecto suma lo específico.
- Un **contrato metodológico**: 4 fases firmables (Entregable → Stack → Equipo → Plan) antes de ejecutar.

### NO ES
- Un boilerplate de código (eso depende de tu stack).
- Una alternativa a pensar el problema.
- Una colección cerrada — cada proyecto lo puede **extender libremente**.
- Una receta única — la metodología aplica, las herramientas varían.

---

## La metodología (el corazón)

Antes de tocar una sola API, pasamos por **4 pasos**. Ninguno se saltea. Cada uno termina con firma del cliente.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│      🎯      │     │      🛠️      │     │      👥      │     │      🚀      │
│              │     │              │     │              │     │              │
│  Entregable  │ ──► │    Stack     │ ──► │    Equipo    │ ──► │     Plan     │
│              │     │              │     │              │     │              │
│  Pensar      │     │ Investigar,  │     │ Agentes +    │     │ Consolidado, │
│  desde el    │     │ no adivinar  │     │ custom +     │     │ firmado,     │
│  final       │     │              │     │ Gantt        │     │ ejecutable   │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
```

**Output:** un único `documentation/plan-maestro.md` que el cliente firma. **Sin plan firmado, no arranca ejecución.**

Detalles en [`templates/plan-maestro.md`](./templates/plan-maestro.md) · lo guía el agente [`onboarding-pm`](./.claude/agents/onboarding-pm.md).

---

## Uso rápido (3 comandos)

```bash
# 1. Clonar como base de tu proyecto
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto && rm -rf .git && git init

# 2. Instalar herramientas (detecta qué ya tenés, instala solo lo que falta)
./tooling/install.sh

# 3. Abrir Claude Code y arrancar el plan
claude
> Usá el skill plan-maestro para generar el scaffold, después invocá a kickoff-cliente
```

Guía completa paso a paso: [`INSTALL.md`](./INSTALL.md)

### Nota sobre credenciales

Si usás Claude Code como IDE, **no necesitás** `ANTHROPIC_API_KEY` — Claude Code usa su propia sesión. Solo la necesitás si hacés llamadas directas a la API de Anthropic desde código.

---

## Estructura del repo

```
creators-latam-starter/
│
├── 📘 README.md              · este archivo
├── 🧠 CLAUDE.md              · reglas de oro (Claude las lee auto)
├── 🤖 LLM.md                 · manual para cualquier LLM
├── 📖 INSTALL.md             · guía paso a paso end-to-end
├── 📝 CHANGELOG.md           · historial de versiones
├── ⚖️ LICENSE                · MIT
├── 🔐 .env.example           · plantilla de credenciales
│
├── .claude/
│   ├── settings.json         · permisos preaprobados (default)
│   ├── settings/             · variantes (development, production, onboarding)
│   ├── agents/               · 32 agentes pre-configurados ⭐ el corazón
│   ├── skills/               · 5 skills (pdf, video, plan-maestro, plan-paso-a-paso, fechas)
│   └── commands/             · slash commands custom (/plan-maestro, /status, /doctor, ...)
│
├── templates/
│   ├── plan-maestro.md       · ⭐ template de las 4 fases
│   ├── nv-prompt.md          · prompt de arranque con validación
│   ├── api-research.md       · research por herramienta externa
│   ├── handoff-final.md      · paquete final al cliente
│   └── retrospectiva.md      · retro post-proyecto
│
├── tooling/
│   ├── install.sh            · instalador inteligente (detecta y salta)
│   ├── doctor.sh             · health check del proyecto
│   ├── validate-plan.sh      · verifica firmas antes de ejecutar
│   ├── migrate.sh            · actualiza tu proyecto al último starter
│   ├── check-duplicates.sh   · detecta agentes/skills solapados
│   ├── new-agent.sh          · wizard interactivo para crear agentes custom
│   ├── install-gitleaks-hook.sh · pre-commit para detectar secrets
│   └── README.md             · qué hace cada herramienta
│
├── .github/
│   ├── workflows/ci.yml      · valida frontmatter, links, shell, HTML, duplicados
│   ├── ISSUE_TEMPLATE/       · bug / feature / new-agent
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── dependabot.yml
│
├── docs/                     · landing (GitHub Pages)
│
└── Carpetas del proyecto (vacías al clonar, se llenan con el trabajo):
    ├── workflows/            · flujos específicos (n8n JSON, scripts)
    ├── documentation/        · plan-maestro, bitácora, status, mapa-sistema, stack/
    ├── data_original/        · raw del cliente (PDFs, screenshots) — sagrado
    └── output/               · entregables finales al cliente
```

---

## El escuadrón de agentes (32)

Viven en [`.claude/agents/`](./.claude/agents/). **Un agente, un job.**

### Agrupados por función

- **🤝 Arranque del proyecto** (3): kickoff-cliente, onboarding-pm, mapa-sistema
- **🎼 Coordinación** (4): orquestador, project-manager, arquitecto, status-dashboard
- **📡 Monitoreo continuo** (1): project-monitor
- **🛡️ Auditoría** (3): guardian-reglas, security-auditor, analizador-patrones
- **📦 Ejecución de trabajo** (7): compilador-datos, integrador-herramientas, integraciones, tester, test-debug-loop, github-keeper, credentials-manager
- **📄 Entregables** (4): excel-builder, html-renderer, pdf-exporter, dashboard-builder
- **🗂️ Documentación** (4): documentador, chronicler, diagramador-mermaid, comentarios-adicionales
- **🧹 Mantenimiento** (4): versionador, purgador, archivero, rollback-manager
- **💰 Operación** (2): cost-tracker, handoff-cliente
- **👋 Colaboración** (1): onboarder-colaborador

Lista completa con emojis y jobs en [`.claude/agents/README.md`](./.claude/agents/README.md).

### ¿Cómo agrego agentes custom para mi proyecto?

Durante la Fase 3 del Plan Maestro, el `onboarding-pm` sugiere qué agentes custom crear. Después:

```bash
./tooling/new-agent.sh     # wizard interactivo
```

Te pregunta nombre, descripción, tools, rol (op/sup) y genera el archivo con frontmatter válido. Se puede ejecutar también desde Claude Code con `/new-agent`.

---

## Skills fundacionales (5)

| Skill | Cuándo se invoca |
|---|---|
| [`plan-maestro`](./.claude/skills/plan-maestro/SKILL.md) | ⭐ Al arranque — genera scaffold del Plan Maestro |
| [`pdf-a-markdown`](./.claude/skills/pdf-a-markdown/SKILL.md) | Todo PDF/DOCX/XLSX → MD antes de que el modelo lo lea |
| [`video-a-texto`](./.claude/skills/video-a-texto/SKILL.md) | YouTube / archivos locales → texto |
| [`plan-paso-a-paso`](./.claude/skills/plan-paso-a-paso/SKILL.md) | Antes de procesar volumen alto |
| [`formato-fechas`](./.claude/skills/formato-fechas/SKILL.md) | Normaliza fechas del proyecto a ISO 8601 |

---

## Las 10 reglas de oro

1. **Plan Maestro antes de ejecutar.** Las 4 fases firmadas, no negociable.
2. **GitHub primero.** Repo conectado, permisos de terminal, `.env` en local.
3. **Un cliente = una carpeta madre.** Incluso tu propia agencia.
4. **Compilá a los 500k tokens.** No esperes al millón.
5. **Reemplazar > duplicar.** Nada de `plan_v2_final_final.md`.
6. **Todo lo final va a `output/`.** Cero excepciones.
7. **Un agente, un job.** Los multipropósito confunden.
8. **El NV nunca arranca sin confirmar.** "Decime dudas antes de iniciar" es fijo.
9. **Plan paso a paso > paralelo.** Paralelización mal hecha colapsa.
10. **Si no avanza, no es el modelo.** Es el prompt, el contexto o el plan.

Completas en [`CLAUDE.md`](./CLAUDE.md).

---

## Comandos esenciales

### De Claude Code (nativos)
- `/compact` — compilar contexto (crítico a los ~500k tokens).
- `ESC ESC` — rewind a un turno anterior.
- `/clear` — limpiar chat sin cerrar proyecto.
- `/cost` — ver uso de tokens.
- `/doctor` — health check del setup.

### Custom del starter (en `.claude/commands/`)
- `/plan-maestro` — genera scaffold del plan.
- `/status` — invoca status-dashboard y muestra inline.
- `/doctor` — corre `tooling/doctor.sh`.
- `/retrospectiva` — arranca retro post-proyecto.
- `/new-agent` — wizard para crear agentes custom.

### Scripts de tooling
```bash
./tooling/install.sh        # instalar herramientas (inteligente)
./tooling/doctor.sh         # diagnóstico del proyecto
./tooling/validate-plan.sh  # chequea firmas del Plan Maestro
./tooling/check-duplicates.sh   # detecta agentes solapados
./tooling/migrate.sh        # actualizar al último starter
./tooling/new-agent.sh      # wizard crear agente custom
```

---

## Cómo se extiende esta base

La base no cubre todo — cada proyecto suma lo específico. Patrones típicos:

### Agentes custom del proyecto
```bash
./tooling/new-agent.sh  # → .claude/agents/<nombre>.md
```
Ejemplos: `analista-kommo`, `generador-reporte-ventas`, `sync-shopify`.

### Skills custom
```bash
mkdir -p .claude/skills/mi-skill
# Crear SKILL.md con frontmatter
```

### Herramientas externas (MCP / APIs)
El agente `integrador-herramientas` investiga con jerarquía **API > SDK > MCP > webhook > n8n > UI**. Research documentado en `documentation/stack/<herramienta>.md`.

### Templates del proyecto
Cualquier MD de estructura repetida: `briefing-reunion.md`, `sprint-review.md`, etc.

### Workflows
`workflows/*.json` de n8n, Zapier, scripts reutilizables.

**Regla:** lo que sea específico de un proyecto queda en ese proyecto. Si detectás un patrón en 3+ proyectos, proponé subirlo al starter base (label `improvement-from-project` en issues).

---

## Mejora continua

El sistema **aprende con los proyectos** gracias a 3 agentes:
- `comentarios-adicionales` — recoge feedback post-fase.
- `analizador-patrones` — mensualmente agrega patrones entre proyectos.
- `retrospectiva.md` — retro de cierre alimenta al analizador.

Cuando el analizador detecta un patrón en N proyectos, sugiere subirlo al starter como nuevo agente/skill/template.

---

## Trabajo colaborativo

El repo es tu **oficina compartida**:

1. **Invitás** colaboradores en GitHub.
2. **Clonan** + corren `./tooling/install.sh`.
3. **Branches + PRs**: nunca direct-to-main.
4. **El `guardian-reglas` audita** antes de cada merge.
5. **El `onboarder-colaborador`** genera welcome personalizado por nuevo miembro.
6. **El `mapa-sistema`** mantiene un inventario visual actualizado.

---

## Preguntas frecuentes

### ¿Esto corre en Windows?
El `install.sh` asume macOS. Para Windows: pediles a Claude/Cursor que adapte con `winget` o `scoop`. Linux: reemplazar `brew` por `apt`/`dnf`.

### ¿Puedo usar Cursor en vez de Claude Code?
Sí. `.claude/` es específico de Claude Code, pero `CLAUDE.md`, reglas y templates son universales.

### ¿Cuánto tarda la instalación?
Primera vez en Mac vacía: 15–30 min (marker descarga ~2GB de modelos). Siguientes: segundos, el installer detecta qué ya tenés.

### ¿Esto es una agencia o un producto?
Ninguna de las dos: es una **forma de trabajar** open source. Creators Latam la usa día a día con sus clientes. Podés usarla igual, adaptarla o contratarnos para montar el sistema en tu empresa.

---

## Contacto

- 🌐 [creatorslatam.com](https://www.creatorslatam.com/)
- 📧 info@creatorslatam.com
- 📱 +51 995 547 575
- 💬 [WhatsApp directo](https://wa.me/51995547575)
- 🐛 [Issues en GitHub](https://github.com/tamibot/creators-latam-starter/issues)

---

**Creators Latam** · Lima, Perú · Starter Kit v1.9 · Una forma de trabajar, no un stack
