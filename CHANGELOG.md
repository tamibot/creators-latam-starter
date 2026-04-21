# Changelog

Historial de versiones del **Creators Latam Starter Kit**.

Formato basado en [Keep a Changelog](https://keepachangelog.com/) · sigue [SemVer](https://semver.org/).

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
