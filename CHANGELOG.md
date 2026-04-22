# Changelog

Historial de versiones del **Creators Latam Starter Kit**.

Formato basado en [Keep a Changelog](https://keepachangelog.com/) · sigue [SemVer](https://semver.org/).

---

## [1.9.0] · 2026-04-21

### Changed · enfoque de comunicación
- Landing y README rearmados con mensaje **"base extensible"**:
  - Reemplaza mensaje anterior "Instalá. Colaborá. Ejecutá." por **"Una base sólida para trabajar con IA"**.
  - Enfatiza que el starter es el **piso común**, sobre el cual cada proyecto suma lo específico.
  - Concepto claro: **"la base te da el piso; encima construís lo tuyo"**.

### Changed · landing · organigrama visual de agentes
- Reemplazada la grid plana de 32 agentes por un **organigrama funcional**:
  - Root node animado: "Creators Latam Starter".
  - Líneas SVG conectoras del root a las 8 ramas funcionales.
  - 8 branches con colores propios:
    1. 🤝 Arranque (3) — kickoff, onboarding-pm, mapa-sistema
    2. 🎼 Coordinación (4) — orquestador, PM, arquitecto, status-dashboard
    3. 📡 Monitoreo (4) — project-monitor, guardian-reglas, security-auditor, analizador
    4. 📦 Ejecución (7) — compilador, integrador, tester, test-debug, github-keeper, credentials, diagramador
    5. 📄 Entregables (4) — excel, html-renderer, pdf-exporter, dashboard-builder
    6. 🗂️ Docs (4) — documentador, chronicler, diagramador, comentarios
    7. 🧹 Mantenimiento (4) — versionador, purgador, archivero, rollback
    8. 🎯 Cierre (3) — handoff, cost-tracker, onboarder-colab
  - Cada branch con emoji + contador + "cuándo se invoca" (día 1 / continuo / pre-firma / etc).
  - Mini-cards de los agentes con emoji individual + AG ID.
  - Hover animado en cada branch (rotate + scale + shadow con color de la rama).
- Nuevo bloque **"Esto es la base. Vos sumás lo específico"** que refuerza el concepto de extensibilidad.

### Changed · README
- Reescrito completo con enfoque **ES / NO ES** al inicio.
- Sección **"Cómo se extiende esta base"** explicita los patrones:
  agentes custom, skills custom, integraciones, templates del proyecto.
- Sección **"Mejora continua"** explica cómo los patrones recurrentes ascienden al starter base.

### Changed · INSTALL.md
- Reordenado por fases numeradas (0 a 8).
- Fase 0 = chequeo previo con one-liner para ver qué tenés.
- Troubleshooting al final con problemas frecuentes resueltos.
- Nota crítica sobre `ANTHROPIC_API_KEY` (no requerida con Claude Code).

### Changed · CLAUDE.md
- Agregada nota en el encabezado sobre extensibilidad: el repo es base común, arriba se suma lo específico.

---

## [1.8.0] · 2026-04-21

### Added · agentes (32 totales · +2)
- **`project-monitor`** (AG 32) 📡 — supervisor CONTINUO. Mantiene `documentation/status.json` (machine-readable) siempre actualizado. Lo pueden consumir dashboards externos, bots, webhooks. Schema versionado con campos fijos (project, plan_status, execution, entregables, milestones, risks, team, costs, quality, next_actions).
- **`rollback-manager`** (AG 33) ⏪ — cuando algo se rompe en ejecución, identifica el último commit verde, calcula el diff, propone 3 estrategias (revert / restore selectivo / hard reset), ejecuta con confirmación doble.

### Added · skills (+1)
- **`formato-fechas`** — normaliza fechas en docs del proyecto a ISO 8601. Detecta formatos mezclados (`dd/mm/yyyy` vs `yyyy-mm-dd` vs "21 de Abril de 2026"). Dry-run por default.

### Added · tooling
- `tooling/check-duplicates.sh` — detecta agentes/skills con funcionalidad solapada. Nombres similares, keywords cruzadas, sets idénticos de tools, templates redundantes.

### Added · slash commands
- `/retrospectiva` — arranca retro post-proyecto con el template.
- `/new-agent` — crea agente custom via `./tooling/new-agent.sh`.

### Added · CI
- Job `agent-references` — valida que cada agente mencionado en docs exista realmente como archivo.
- Job `duplicate-check` — corre `check-duplicates.sh` en cada push.

### Changed · mejoras
- `orquestador`: preflight obligatorio con `validate-plan.sh` antes de delegar ejecución. Evita arrancar sin plan firmado.
- `status-dashboard`: ahora delega a `project-monitor` para sincronizar `status.json` tras regenerar el MD.

### Removed · consolidación
- `templates/brief-cliente.md` eliminado — redundante con Fase 1 del `plan-maestro.md` + lo que produce `kickoff-cliente`.

### Landing
- 32 agentes visibles con emojis (AG 32 📡, AG 33 ⏪).
- Nueva sección **"🛠️ Stack que viene preinstalado"** con 6 categorías (prerequisitos, documentos, audio/video, terminal, seguridad, excel/data) y links a cada repo.
- Nota sobre idempotencia del installer.

---

## [1.7.0] · 2026-04-21

### Removed · consolidación
- **`integraciones`** (AG 08) eliminado — su funcionalidad está cubierta completamente por `integrador-herramientas` (AG 17), que además aplica la jerarquía API > SDK > MCP > webhook.

### Added · 4 agentes nuevos (30 totales)
- `onboarder-colaborador` (AG 28) 👋 — welcome personalizado para colaboradores nuevos del repo. Genera `documentation/onboarding/<nombre>.md` con lectura recomendada, setup local y 3 tickets según rol.
- `html-renderer` (AG 29) 🎨 — convierte MD/contenido a HTML profesional con Mermaid renderizado, tipografía de marca, print styles. **Nunca más imprimas MD directo a PDF.**
- `pdf-exporter` (AG 30) 📄 — toma HTML renderizado, valida visualmente con screenshot preview, exporta PDF con Playwright. Si el preview se ve mal, delega a html-renderer.
- `dashboard-builder` (AG 31) 📊 — dashboards HTML standalone con Chart.js, filtros, tablas ordenables. Un archivo, sin backend.

### Added · tooling
- `tooling/new-agent.sh` — wizard interactivo para crear agentes custom del proyecto. Valida nombre, frontmatter, duplicados.

### Added · slash commands
- `.claude/commands/plan-maestro.md` — `/plan-maestro` genera scaffold y arranca onboarding-pm.
- `.claude/commands/status.md` — `/status` invoca status-dashboard y muestra inline.
- `.claude/commands/doctor.md` — `/doctor` corre `tooling/doctor.sh` y delega fixes.

### Added · variantes de settings
- `.claude/settings/development.json` — perfil permisivo (copia del actual).
- `.claude/settings/production.json` — restrictivo para infra/datos reales.
- `.claude/settings/onboarding.json` — muy restrictivo para colaboradores aprendiendo.
- `.claude/settings/README.md` — cómo switchear entre perfiles.

### Added · templates
- `templates/retrospectiva.md` — retro estructurada post-proyecto, alimenta al analizador-patrones.

### Added · GitHub
- `.github/ISSUE_TEMPLATE/bug_report.md`
- `.github/ISSUE_TEMPLATE/feature_request.md`
- `.github/ISSUE_TEMPLATE/new_agent.md`
- `.github/PULL_REQUEST_TEMPLATE.md` con checklist del guardián.
- `.github/dependabot.yml` para updates mensuales de GitHub Actions.

### Added · landing
- Flujo visual **MD → HTML → PDF** explicando el bug común ("MD directo a PDF queda feo").
- Agentes 28-31 visibles en la grid con emojis (👋 🎨 📄 📊).
- Sección de slash commands (nativos + custom del starter).
- Steps del hero ahora se marcan como "done" (verde ✓) conforme scrolleás las secciones.
- Nav simplificado con link directo a docs.

### Changed
- Total agentes: 27 → 30 (eliminé 1, agregué 4).
- Supervisores: 9 · Operativos: 21.
- Skills: 4 (sin cambios).

---

## [1.6.0] · 2026-04-21

### Added · agentes de ejecución, seguridad y handoff
- **+5 agentes** (27 totales):
  - `status-dashboard` (AG 23) — foto visual del estado actual del proyecto con Gantt de progreso.
  - `excel-builder` (AG 24) — genera .xlsx profesionales con 3 hojas mínimas (Resumen / Datos / Info), formato de marca, filtros, gráficos.
  - `cost-tracker` (AG 25) — estimación pre-firma (Fase 2) y monitoreo mensual de costos API/cloud.
  - `handoff-cliente` (AG 26) — empaquetado final al cliente con checklist obligatorio + template de handoff.
  - `security-auditor` (AG 27) — escanea secrets, dependencias con CVE, permisos, webhooks sin HMAC, OWASP top 10.

### Added · tooling scripts
- `tooling/doctor.sh` — diagnóstico del proyecto. Checkea herramientas, frontmatter de agentes, permisos de `.env`, estructura canónica, gitleaks. Modo `--fix` para correcciones seguras.
- `tooling/validate-plan.sh` — chequea que el Plan Maestro tenga las 3 fases firmadas por cliente + Creators Latam. Bloquea ejecución si no.
- `tooling/migrate.sh` — actualiza tu proyecto con la última versión del starter vía `git merge`. Dry-run por defecto, `--apply` para ejecutar.
- `tooling/install-gitleaks-hook.sh` — instala pre-commit hook con gitleaks para bloquear commits con secrets.

### Added · skill
- `plan-maestro` — skill scaffold generator para crear `documentation/plan-maestro.md` al arranque del proyecto.

### Added · template
- `templates/handoff-final.md` — template del paquete final al cliente (10 secciones firmables).

### Added · landing
- Flujo de 4 pasos destacados (Entregable → Stack → Equipo → Plan) con animación de rotación activa.
- Visualización gráfica de los 27 agentes con **emoji por agente** + skills asociados.
- Plan Maestro visualizado como documento con checklist de firmas.
- Sección "Colaborativo" destacando trabajo en equipo via GitHub.
- Tip sobre `Cmd+Shift+V` / `Ctrl+Shift+V` para ver Markdown renderizado en VS Code / Cursor.
- CTA simplificado con 3 comandos visibles.
- Nav simplificado y más compacto.

### Changed
- Total agentes: 22 → 27 (18 operativos + 9 supervisores).
- Total skills: 3 → 4 (agregado `plan-maestro`).
- Landing más visual, menos texto. Emojis por agente. Animaciones más sutiles.

---

## [1.5.0] · 2026-04-21

### Added
- **7 agentes nuevos** (22 totales):
  - `test-debug-loop` (AG 16) — ciclo automático prueba → error → fix → re-prueba.
  - `integrador-herramientas` (AG 17) — conecta herramientas/MCP priorizando API > SDK > MCP > webhook > n8n.
  - `kickoff-cliente` (AG 18) — facilita primera reunión con cliente nuevo, produce minuta + brief.
  - `mapa-sistema` (AG 19) — genera catálogo visual en `documentation/mapa-sistema.md`.
  - `analizador-patrones` (AG 20) — modo aprendizaje: detecta patrones entre proyectos y sugiere packs/templates.
  - `comentarios-adicionales` (AG 21) — recolector de feedback estructurado post-fase.
  - `archivero` (AG 22) — curador activo del filesystem, orquesta versionador + purgador.
- **Sección landing**: Changelog embebido, Colaboraciones (formulario), Herramientas a conectar (n8n + MCP como ejemplo), Visualización gráfica de agentes con Mermaid.
- **Badges** en README (versión, licencia, agentes, skills).
- **GitHub Actions workflow** para validar shell, links en MDs y frontmatter de agentes en cada push.

### Changed
- Total de agentes: 15 → 22 (11 operativos + 4 supervisores → 15 operativos + 7 supervisores).
- Landing reorganizada para destacar que el starter es **forma de trabajo**, no stack.

---

## [1.4.0] · 2026-04-21

### Added
- **Sección "Qué esperar"** en landing con timeline realista + warning "no te asustes si tarda".
- **Sección "Comandos esenciales"** de Claude Code: `/compact`, `ESC ESC` (rewind), `/clear`, `/cost`, `/doctor`, `/agents`, `/init`, `/config` + atajos (Shift+Tab, Ctrl+R, Ctrl+C).
- **Sección "Mejores prácticas"** con 11 tips en 4 categorías (formatos, comunicación con el modelo, higiene de contexto, seguridad).
- **Sección "Beneficios"** con 4 cards de valor concreto.
- **FAQ expandida**: de 10 a ~20 preguntas, agrupadas (Metodología, Setup, Agentes, Troubleshooting).

### Added · Animaciones
- Barra de progreso de scroll en el top.
- Fade-in on scroll con `IntersectionObserver`.
- Counter animation en stats del hero.
- Pulse ring en números de fase al entrar en viewport.
- Blob pulse en gradientes del hero y CTA.
- Underline animado en nav links al hover.

### Fixed
- `tooling/install.sh`: simplificada una línea con pipes complejos que podía fallar en edge cases.
- `.claude/settings.json`: agregados comandos frecuentes (`xcode-select`, `claude`, `sed`, `awk`, `tr`, `diff`, `tee`, `date`, `uname`, `printenv`).

---

## [1.3.0] · 2026-04-20

### Changed · eje metodológico
- Landing rehecha: el foco ya **no son las herramientas** sino la **metodología de 3 fases**.
- Hero: *"Cómo trabajamos con IA. Metodología primero, herramientas después."*
- Las herramientas pasan a ser bloque secundario ("el sistema que ejecuta").

### Added
- **Agente `onboarding-pm`** (AG 15) — guía las 3 fases obligatorias (Entregables → Stack → Equipo) hasta producir el Plan Maestro.
- **Template `plan-maestro.md`** — documento firmable con las 3 fases, checkpoints por fase, firmas.
- **Instalador inteligente**: audita qué ya tenés antes de instalar, salta lo existente, sale en segundos si todo está.
- **Aclaración crítica** sobre `ANTHROPIC_API_KEY`: no requerida si usás Claude Code.
- Nueva regla 01: **"Plan Maestro antes de ejecutar"**.

### Added · Onboarding PM
- Script de conversación completo para las 3 fases.
- Exige validación explícita del usuario antes de avanzar de fase.
- Rechaza "hacelo como veas" — siempre exige definición.

---

## [1.2.0] · 2026-04-20

### Added · Agentes supervisores
- `orquestador` (AG 13) — coordinador táctico, decide delegaciones.
- `guardian-reglas` (AG 14) — audita las 10 reglas de oro pre-commit/release.

### Added · Documentación
- `INSTALL.md` — guía end-to-end paso a paso desde Mac vacía.
- `tooling/prerequisitos.md` — instalación manual con links a docs oficiales.
- `LICENSE` — MIT.

### Changed
- `agents/README.md` reorganizado: operativos + supervisores + jerarquía visual.
- Landing: tabla de agentes con badge "Supervisor" en AG 13/14.

---

## [1.1.0] · 2026-04-20

### Added
- **Agente `diagramador-mermaid`** (AG 12) — valida sintaxis antes de entregar.
- **Skill `video-a-texto`** — 3 modos: Gemini directo, yt-dlp + Gemini, whisper.cpp local.
- **`tooling/install.sh`** interactivo + `tooling/README.md` con todas las herramientas.
- **`.claude/settings.json`** con permisos preaprobados (lista blanca + deny crítico).
- Prerrequisitos: Homebrew, git, gh, Python 3.12, uv, nvm + Node LTS, ffmpeg, Docker.
- Terminal productivity: ripgrep, fd, bat, fzf, jq, delta, glow, zoxide, tree.

### Changed
- Skill `pdf-a-markdown`: ahora `marker` + `markitdown` (sacadas las 3 opciones genéricas).
- Removido: todo lo relacionado con Firecrawl (se decidió sacar para mantener el starter liviano).

---

## [1.0.0] · 2026-04-19

### Added · lanzamiento inicial
- **11 agentes operativos**: Documentador, GitHub Keeper, Compilador de Datos, Chronicler, Credentials Manager, Project Manager, Tester, Integraciones, Arquitecto, Versionador, Purgador.
- **2 skills fundacionales**: `pdf-a-markdown`, `plan-paso-a-paso`.
- **Templates**: NV prompt, brief-cliente, api-research.
- **Estructura canónica** de carpetas (output/, data_original/, documentation/, workflows/).
- **10 reglas de oro** en `CLAUDE.md`.
- **Landing** con estilo Creators Latam (gradiente purple/pink, tipografía Inter).
- **GitHub Pages** activado desde `/docs`.

---

## Cómo actualizar tu proyecto al starter más nuevo

```bash
# Agregar el starter como remote
git remote add starter https://github.com/tamibot/creators-latam-starter.git

# Traer cambios
git fetch starter

# Mergear (resolver conflictos si los hay)
git merge starter/main --allow-unrelated-histories
```

El agente [`versionador`](./.claude/agents/versionador.md) te ayuda con los conflictos.
El agente [`archivero`](./.claude/agents/archivero.md) limpia después del merge.

---

## Próximas versiones (roadmap corto)

- [ ] **v1.6** — Agente `cost-tracker` (estima costos APIs en el Plan Maestro).
- [ ] **v1.7** — Template `handoff-final.md` (paquete final al cliente).
- [ ] **v1.8** — Pre-commit hooks con `gitleaks` + validación automática de frontmatter.
- [ ] **v2.0** — Versión en inglés.
