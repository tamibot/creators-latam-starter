# Creators Latam · Starter Kit para Proyectos con IA

[![Version](https://img.shields.io/badge/version-1.5.0-ff3b77)](./CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/license-MIT-8b3fff)](./LICENSE)
[![Agentes](https://img.shields.io/badge/agentes-22-ff2d8a)](./.claude/agents/README.md)
[![Skills](https://img.shields.io/badge/skills-3-14b87a)](./.claude/skills/README.md)
[![CI](https://github.com/tamibot/creators-latam-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/tamibot/creators-latam-starter/actions/workflows/ci.yml)
[![Landing](https://img.shields.io/badge/landing-online-2563eb)](https://tamibot.github.io/creators-latam-starter/)

> **Metodología primero, herramientas después.** Nuestro método de 3 fases (Entregable → Stack → Equipo) para que los proyectos con IA no fallen por falta de proceso. El starter es el sistema que lo ejecuta.

**Creators Latam** · [creatorslatam.com](https://www.creatorslatam.com/) · +51 995 547 575

🌐 **Landing:** [tamibot.github.io/creators-latam-starter](https://tamibot.github.io/creators-latam-starter/)

---

## La metodología (esto es lo importante)

Antes de tocar una sola API, pasamos por **3 fases obligatorias**. Ninguna se saltea. Cada una termina con firma del cliente.

### FASE 1 · Entregables — pensar desde el final

> *¿Qué cosa concreta recibe el cliente cuando termina el proyecto?*

Definimos **formato, ubicación, estructura, KPIs, fuente de cada dato y criterio de aprobación** antes que nada. Sin esto, cualquier código es al pedo.

**Ejemplo:** si el entregable es `reporte-leads.xlsx`, detallamos columna por columna: `fecha` (de Kommo API), `email` (contacto CRM), `LTV` (suma de deals), `CAC` (spend / conversiones)... y el criterio: *"el cliente abre el Excel y dice sí, esto es lo que necesitaba."*

### FASE 2 · Stack Tecnológico — investigar, no adivinar

> *¿Con qué herramientas producimos los entregables? ¿Cuál elegimos y por qué?*

Acá **no alcanza con lo que dice el cliente**. Para cada herramienta externa, research obligatorio en:
- StackOverflow (últimos 6 meses)
- Reddit / subreddits de la herramienta
- GitHub issues abiertos recientes
- HackerNews threads
- Discord/Slack oficial

Todo queda documentado en `documentation/stack/<herramienta>.md` usando el template [`templates/api-research.md`](./templates/api-research.md).

### FASE 3 · Equipo y Plan — quién lo ejecuta y cuándo

> *¿Qué agentes del starter usamos, qué agentes custom hay que crear, en qué orden?*

Con entregables + stack claros, armamos:
- Agentes del starter que aplican.
- Agentes **custom** del proyecto.
- Skills adicionales.
- **Gantt de ejecución** (Mermaid).
- Puntos de validación con el cliente.

### El output: Plan Maestro

Las 3 fases se consolidan en **un único documento** que el cliente firma: `documentation/plan-maestro.md`.

**Sin Plan Maestro firmado, no arranca nada.**

Template: [`templates/plan-maestro.md`](./templates/plan-maestro.md).
Lo guía el agente [`onboarding-pm`](./.claude/agents/onboarding-pm.md).

---

## ¿Qué es este repo?

El **sistema que ejecuta** la metodología. Cuando el Plan Maestro está firmado, el starter te da:

- **22 agentes pre-configurados** (10 operativos + 5 supervisores, incluyendo el Onboarding PM que guía las 3 fases).
- **3 skills fundacionales** (PDF→MD, Video/Audio→texto, Plan Paso a Paso).
- **Templates** para Plan Maestro, NV, brief, research de APIs.
- **`.claude/settings.json`** con permisos preaprobados (deja de autorizar cada comando).
- **Instalador inteligente** (`tooling/install.sh`) que detecta qué ya tenés y no reinstala.

---

## Uso rápido

```bash
# 1. Clonar como base de un proyecto nuevo
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto && rm -rf .git && git init

# 2. Instalar herramientas (solo lo que falta; si ya tenés todo, es segundos)
./tooling/install.sh

# 3. Abrir Claude Code
claude
# Primer mensaje: "Invocá al agente onboarding-pm para arrancar las 3 fases"
```

📖 **Guía completa paso a paso:** [`INSTALL.md`](./INSTALL.md)

### Nota sobre credenciales

Si usás **Claude Code** como IDE, **no necesitás `ANTHROPIC_API_KEY`** — Claude Code usa su propia sesión. Solo necesitás API keys si tu código hace llamadas directas a APIs (ej: Gemini para el skill de video).

---

## Estructura del proyecto

```
creators-latam-starter/
├── README.md                   → este archivo
├── CLAUDE.md                   → reglas de oro (Claude las lee auto)
├── LLM.md                      → manual de bienvenida para cualquier LLM
├── INSTALL.md                  → guía completa de instalación
├── LICENSE                     → MIT
├── .env.example                → plantilla de credenciales
├── .claude/
│   ├── settings.json           → permisos preaprobados
│   ├── agents/                 → 15 agentes (incluye onboarding-pm)
│   └── skills/                 → pdf-a-markdown, video-a-texto, plan-paso-a-paso
├── tooling/
│   ├── install.sh              → instalador inteligente (detecta y salta)
│   ├── README.md               → qué hace cada herramienta
│   └── prerequisitos.md        → instalación manual paso a paso
├── templates/
│   ├── plan-maestro.md         → ⭐ template de las 3 fases
│   ├── nv-prompt.md            → prompt de arranque para agentes
│   ├── brief-cliente.md        → brief inicial
│   └── api-research.md         → research por herramienta
├── workflows/                  → flujos del proyecto
├── documentation/              → plan-maestro.md + stack/ + bitácora
├── data_original/              → raw del cliente (PDFs, screenshots)
├── output/                     → entregables finales (lo que el cliente ve)
└── docs/                       → landing (GitHub Pages)
```

---

## El escuadrón de agentes (22 total)

Vive en `.claude/agents/`. Un agente, un job.

### Supervisores (coordinan y auditan · 7)

| # | Agente | Job |
|---|---|---|
| 15 | **Onboarding PM** ⭐ | Guía las 3 fases hasta firmar el Plan Maestro |
| 18 | **Kickoff Cliente** | Primera reunión con cliente: minuta + brief + preview Fase 1 |
| 13 | **Orquestador** | Con plan aprobado: descompone y delega tarea por tarea |
| 06 | **Project Manager** | Visión estratégica: estado, plazos, prioridades |
| 09 | **Arquitecto** | Revisa planes técnicos antes de ejecutar |
| 14 | **Guardián de Reglas** | Audita las 10 reglas de oro pre-commit/release |
| 19 | **Mapa Sistema** | Catálogo visual de todos los agentes/skills/integraciones |
| 20 | **Analizador Patrones** | Modo aprendizaje entre proyectos — detecta recurrencias |

### Operativos (ejecutan · 15)

| # | Agente | Job |
|---|---|---|
| 01 | Documentador | Mantiene la documentación al día |
| 02 | GitHub Keeper | Commits, branches, orden del repo |
| 03 | Compilador de Datos | Junta, limpia y estructura datos |
| 04 | Chronicler | Bitácora viva del proyecto |
| 05 | Credentials Manager | Gestiona `.env` y accesos |
| 07 | Tester | Solo testeos, no arregla bugs |
| 08 | Integraciones | APIs, webhooks, servicios externos |
| 10 | Versionador | Reemplaza > duplica |
| 11 | Purgador | Barre lo muerto |
| 12 | Diagramador Mermaid | Diagramas validados, 0 errores de sintaxis |
| 16 | Test-Debug Loop | Ciclo prueba → error → fix → re-prueba con criterio de corte |
| 17 | Integrador Herramientas | Conecta APIs/MCP/n8n priorizando API > SDK > MCP > webhook |
| 21 | Comentarios Adicionales | Recolector de feedback estructurado post-fase |
| 22 | Archivero | Curador activo: orquesta versionador+purgador, detecta misubicaciones |

Durante la Fase 3 del Plan Maestro, el `onboarding-pm` puede proponer agentes custom adicionales.

Detalles: [`.claude/agents/README.md`](./.claude/agents/README.md).

---

## Skills fundacionales

Viven en `.claude/skills/`.

- **`pdf-a-markdown`** → convierte PDFs/DOCX/XLSX con `marker` o `markitdown`.
- **`video-a-texto`** → YouTube/archivos locales → texto (Gemini / yt-dlp / whisper.cpp).
- **`plan-paso-a-paso`** → obliga al sistema a pensar antes de paralelizar.

---

## Las 10 reglas de oro (resumen)

1. **GitHub primero.** Repo conectado antes que nada.
2. **Un cliente = una carpeta madre.**
3. **Compilá a los 500k tokens.** No esperes al millón.
4. **Reemplazar > duplicar.**
5. **Purgá lo que ya no se usa.**
6. **Todo lo final va a `output/`.**
7. **Un agente, un job.**
8. **Plan Maestro antes de ejecutar.** Las 3 fases firmadas.
9. **Plan paso a paso > todo en paralelo.**
10. **Si no avanza, no es el modelo.** Es el prompt, el contexto o el plan.

Completas: [`CLAUDE.md`](./CLAUDE.md).

---

## ❓ FAQ (corta)

- **¿Por qué arrancar con Plan Maestro y no directo al código?** Porque sin entregable definido, stack validado y equipo armado, el código es al pedo. Ahorra semanas.
- **¿Necesito Anthropic API Key?** No si usás Claude Code. Solo si hacés llamadas directas a la API.
- **¿El instalador es lento?** Primera vez: 20–40 min. Siguientes: segundos (detecta qué ya hay).
- **¿Windows?** Pedile a Claude/Cursor que aplique lo mismo con `winget`/`scoop`.

Completa en la [landing](https://tamibot.github.io/creators-latam-starter/#faq).

---

## Contacto

¿Querés que montemos el sistema completo para tu empresa? Automatizamos la gestión de clientes con ChatBots con IA + CRM. 24/7.

- 🌐 [creatorslatam.com](https://www.creatorslatam.com/)
- 📱 +51 995 547 575
- 💬 [WhatsApp directo](https://wa.me/51995547575)

---

**Creators Latam** · Documento vivo · v1.3 · Metodología primero
