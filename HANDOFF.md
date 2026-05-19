# HANDOFF · Estado del proyecto al 2026-05-19

Documento de relevo para que cualquier LLM (o humano) retome el proyecto
sin tener que reconstruir contexto. **Leelo antes de tocar nada.**

Este doc complementa a [`CLAUDE.md`](./CLAUDE.md) (reglas duras) y a
[`LLM.md`](./LLM.md) (bienvenida rápida). Acá está el "compile" con
lecciones, decisiones y estado actual.

---

## 1 · Qué es este repo

`creators-latam-starter` es **la base para arrancar cualquier proyecto
con Claude Code** dentro de Creators Latam. Tiene dos capas:

1. **Base reusable** — 33 agentes, 26 skills, 7 scripts de tooling,
   templates de Plan Maestro, NV, retro, handoff. Lo que sirve para
   cualquier proyecto de IA.
2. **Landing pública** en `docs/index.html` — explica la metodología
   en 4 pasos (00 Instalar → 01 Entregable → 02 Stack → 03 Equipo
   → 04 Plan Maestro). Publicada en GitHub Pages:
   <https://tamibot.github.io/creators-latam-starter/>

**Repo:** <https://github.com/tamibot/creators-latam-starter> · MIT.
**Estado actual:** `PUBLIC` (al 2026-05-19). Si el usuario quiere
moverlo a privado, hay que avisar que GitHub Pages dejará de servirse
en cuentas free.

---

## 2 · Estructura del repo

```
creators-latam-starter/
├── CLAUDE.md               · 10 mandamientos · leído auto por Claude Code
├── LLM.md                  · bienvenida para cualquier LLM
├── HANDOFF.md              · este doc · compile completo
├── README.md               · descripción pública + quick start
├── INSTALL.md              · proceso detallado de instalación
├── CHANGELOG.md            · historial versionado de la base + landing
├── LICENSE                 · MIT
├── .env.example            · template de credenciales (slots vacíos · OK commit)
├── .gitignore              · excluye .env, secrets/, *.key, etc.
│
├── .claude/
│   ├── agents/             · 33 markdowns con frontmatter (uno por agente)
│   ├── skills/             · 26 carpetas con SKILL.md cada una
│   ├── commands/           · slash commands custom (/onboard, /plan, ...)
│   ├── settings.json       · permisos preaprobados (allow/deny tools)
│   ├── settings/           · settings por modo (plan, code, review)
│   └── launch.json         · config de preview server local
│
├── docs/
│   └── index.html          · landing v1.19 · ~3500 líneas vanilla HTML/CSS/JS
│
├── tooling/                · 7 scripts bash + README + prerequisitos
│   ├── install.sh          · installer principal · idempotente + audit
│   ├── doctor.sh           · diagnóstico del entorno
│   ├── migrate.sh          · sube versión de un proyecto existente
│   ├── new-agent.sh        · wizard que crea un agente custom
│   ├── check-duplicates.sh · evita agentes/skills duplicados
│   ├── validate-plan.sh    · verifica que plan-maestro.md esté completo
│   └── install-gitleaks-hook.sh · pre-commit para secrets
│
├── templates/              · plantillas Markdown reusables
│   ├── plan-maestro.md     · template del plan firmable
│   ├── nv-prompt.md        · prompt "no vamos a empezar hasta confirmar"
│   ├── api-research.md     · cómo investigar una API antes de integrarla
│   ├── handoff-final.md    · entregable al cliente al cerrar
│   └── retrospectiva.md    · template de retro al final de fase
│
├── .github/
│   └── workflows/ci.yml    · CI · 8 jobs (shellcheck, agent-validate,
│                              skill-validate, markdown-links,
│                              html-validate, duplicate-check, etc.)
│
├── data_original/.gitkeep  · input crudo del cliente · git-ignored
├── output/.gitkeep         · entregables finales · git-ignored
├── documentation/          · docs estructurada del cliente
└── workflows/              · workflows específicos del proyecto
```

---

## 3 · Metodología · las 4 fases

El starter implementa una metodología que **siempre** se sigue antes
de escribir código:

| Paso | Nombre | Output | Agente responsable |
|------|--------|--------|---------------------|
| **00** | Instalar | repo clonado, herramientas, agentes | `installer` |
| **01** | Entregable | qué recibe el cliente · KPIs · datos · fuente | `onboarding-pm` |
| **02** | Stack | plataformas, credenciales, hosting, presupuesto | `researcher` |
| **03** | Equipo | qué agentes (base + custom) | wizard `new-agent.sh` |
| **04** | Plan Maestro | doc firmable · 01+02+03 consolidados | template + `onboarding-pm` |

**Regla dura:** sin Plan Maestro firmado por el cliente, no se escribe
una línea de código.

---

## 4 · Agentes (33 al 2026-05-19)

Organizados en **8 grupos funcionales**:

- **Arranque** (4) · `onboarding-pm`, `kickoff-cliente`, `researcher`,
  `installer`
- **Coordinación** (3) · `orquestador`, `integrator`, `api-mapper`
- **Monitoreo** (4) · `status-dashboard`, `project-monitor`,
  `analytics-reader`, `cost-tracker`
- **Ejecución** (5) · `data-pipeline`, `sprint-planner`, `documentador`,
  `testeador`, `git-keeper`
- **Entregables** (5) · `html-renderer`, `pdf-exporter`,
  `dashboard-builder`, `excel-builder`, `handoff-cliente`
- **Docs y análisis** (5) · `analizador-patrones`, `diagramador-mermaid`,
  `voice-to-md`, `mapa-sistema`, `retrospectiva`
- **Mantenimiento** (4) · `purgador`, `migrate`, `doctor`, `duplicate-check`
- **Seguridad y guardarrieles** (3) · `guardian-reglas`,
  `credentials-manager`, `security-auditor`

> Cada agente vive en `.claude/agents/<nombre>.md` con frontmatter YAML
> (description, tools, model, etc.) y un cuerpo en Markdown con system
> prompt + ejemplos.

**Cómo se agrega un agente custom del proyecto:** correr
`tooling/new-agent.sh <nombre>` y completar el wizard. Si el patrón
aparece en 3+ proyectos, se promueve al starter base.

---

## 5 · Skills (26 al 2026-05-19)

Dividas en **2 grupos**:

### 5.a · Skills de proceso (5)
- `pdf-a-markdown` · convierte PDFs con `marker` antes de leerlos
- `video-a-texto` · `yt-dlp` + `whisper.cpp` + Gemini análisis
- `plan-paso-a-paso` · obliga a planear antes de paralelizar
- `plan-maestro` · genera el plan firmable
- `formato-fechas` · estándar de fechas del proyecto

### 5.b · Design skills (21 · instaladas en v1.13)
Mezcla de:
- `impeccable/` (de [pbakaus/impeccable](https://github.com/pbakaus/impeccable))
  · principios de diseño elegante con sub-skills `typography`, `color`,
  `layout`, `animate`, `polish`
- `design-motion-principles/` (de
  [kylezantos/design-motion-principles](https://github.com/kylezantos/design-motion-principles))
  · 12 principios de Disney aplicados a UI motion
- `frontend-design/` (de
  [anthropics/claude-code/plugins/frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design))
  · production-grade frontend

Cada skill es una carpeta con `SKILL.md` (frontmatter `name`,
`description`, `triggers` + cuerpo con guías).

---

## 6 · Landing page · `docs/index.html`

Vanilla HTML/CSS/JS de un solo archivo (~3500 líneas). Sin framework,
sin build step. Se sirve directo desde GitHub Pages.

### 6.a · Arquitectura del HTML

```
<!doctype html>
<html lang="es">
<head>
  <!-- preconnect a Google Fonts -->
  <!-- meta tags, OG, favicons -->
  <style> /* todo el CSS · ~2400 líneas */ </style>
</head>
<body>
  <nav.topbar>            <!-- logo + atajos K + Ver repo -->
  <div.rail>              <!-- progress rail con dots por capítulo -->
  <main>
    <section.chapter#c1.hero>    <!-- hero · split layout -->
    <section.chapter#c1b>        <!-- método · 4 pasos overview -->
    <section.chapter#c2>         <!-- 00 Instalar -->
    <section.chapter#c3>         <!-- 01 Entregable · backwards chain -->
    <section.chapter#c4>         <!-- 02 Stack · 6 info types -->
    <section.chapter#c5>         <!-- 03 Equipo · agent grid -->
    <section.chapter#c6>         <!-- 04 Plan Maestro · pipeline SVG -->
    <section.chapter#c7>         <!-- bundle · base + custom -->
    <div.ticker>                 <!-- marquee horizontal -->
    <section.chapter#c8.faq>     <!-- FAQ -->
    <section.chapter#c9.contact-chap.dark> <!-- contacto + footer -->
  </main>
  <div.palette-overlay>          <!-- command palette (tecla K) -->
  <script> /* ~700 líneas vanilla JS · ningún framework */ </script>
</body>
```

### 6.b · Sistema de diseño

- **Tipografía:** [Geist](https://vercel.com/font) sans/mono +
  [Fraunces](https://fonts.google.com/specimen/Fraunces) (italic
  variable, opsz 144, para acentos editoriales)
- **Color tokens:**
  - `--ink` `#0A0F1C` (tinta principal)
  - `--ink-soft` `#3F4453`
  - `--paper` `#FFFFFF`
  - `--bg` `#FAFAFA`
  - `--accent` `#FF2D6F` (rosa Creators)
  - `--accent-2` `#FF5C8A`
  - `--accent-3` `#FFB454` (dorado, para acentos cálidos)
  - `--accent-soft` `#FFE5EE`
  - `--accent-glow` `rgba(255,45,111,.4)`
  - `--line` `rgba(10,15,28,.08)`
  - `--line-strong` `rgba(10,15,28,.16)`
  - `--dark-bg` `#0B0F1A` (sólo en contact-chap)
- **Radios:** `--r-sm 6px`, `--r-md 12px`, `--r-lg 18px`, `--r-xl 24px`
- **Eases (Emil Kowalski):**
  - `--ease-smooth` `cubic-bezier(0.4, 0, 0.2, 1)`
  - `--ease-out-expo` `cubic-bezier(0.16, 1, 0.3, 1)`
  - `--ease-spring` `cubic-bezier(0.34, 1.56, 0.64, 1)`

### 6.c · Animaciones (vivas en v1.19)

| Nombre | Dónde | Qué hace |
|--------|-------|----------|
| Constelación SVG | hero | 32 nodos en 2 anillos + 14 líneas firing |
| 2 anillos dasheados | constelación | rotan 60s + 90s reverse |
| 3 sparks orbitando | constelación | rosa + dorado, distinta velocidad |
| KPI counters | hero KPI strip | 0→N ease-out-expo cuando entran |
| Auto-install run | c2 install | 4 pasos verdes + progress bar 4.2s |
| Backwards chain | c3 entregable | 4 cards entran de derecha a izq |
| Stack info types | c4 stack | 6 cards con hover lift |
| Agent grid firing | c5 equipo | 35 celdas, 3-5 random rosas cada 1.4s |
| Pipeline SVG | c6 plan | 4 paths stroke-draw cuando entra |
| File tree reveal | c7 bundle | 10 líneas stagger 70ms |
| Ticker marquee | post-bundle | 50s loop horizontal |
| Contact ticker | pre-footer | 50s con highlights Fraunces |
| CTA breath | contact button | shadow respira 3.6s |
| Pulse dot | step-tag, hero badge, gh-label | 2.4s |
| Method-step reveal | c1b método | stagger 130ms al entrar |
| 3D tilt | bundle-side, copy-box, constellation | reactive al cursor |

### 6.d · Mobile · breakpoints

- **`max-width: 720px`** · pasada general · padding chapter chico,
  bundle a 1 col, KPI 2 cols, ticker 2× más lento, hero-viz max 300px
- **`max-width: 420px`** · phones chicos · method-flow en cards
  horizontales (icon + texto al lado, no columna vertical), display
  32px, hero-steps en columna, agent-grid a 5 cols, terminal y
  contact ultra tight
- **Mobile-kill-animations block** · apaga TODO loop infinito en
  mobile (conic-rotations, loopSpin, c-link, c-ring pulse, c-node
  active, hero-badge ping, step-tag pulse, orb floaty, drop-shadow
  filters), `scroll-behavior: auto`, `will-change: auto` global

### 6.e · JavaScript · qué hace cada bloque

1. **Type effect en hero** · cycla "Claude Code" → "metodología" → ...
2. **Magnetic buttons** · siguen el cursor a corta distancia
3. **Parallax orbs** · sólo en hover devices
4. **Custom cursor** · `display:none` desde v1.15 (causaba confusión)
5. **Rail progress** · dot activo según chapter en view
6. **IntersectionObserver** · `.in-view` para reveal animations
7. **rAF loop · updateState** · backup del IO para scroll programmatic
8. **visibilitychange** · re-fire updateState al volver a la tab
   (Chrome pausa rAF/IO/scroll cuando tab es hidden)
9. **Command palette (tecla K)** · navega entre capítulos
10. **Copy button** · clipboard + toast "✓ COPIADO"
11. **buildConstellation()** · genera la SVG en runtime
12. **Constellation firing interval** · 900ms · DESKTOP ONLY
13. **kpiCounters()** · count-up con IO trigger
14. **agentFiring()** · 1400ms cells.firing · DESKTOP ONLY
15. **inViewMarks()** · agrega `.in-view` a pipelineViz, fileTree, installRun
16. **tiltCards()** · wrappea hijos en `.tilt-inner`, aplica
    rotateX/Y según mouse · hover-devices only
17. **Ticker pause on hover**

---

## 7 · Lecciones aprendidas (bugs caros)

### 7.a · Mobile / iOS Safari

**El famoso "scroll jump" en móvil:**
1. **URL bar reflow** · iOS Safari muestra/oculta la barra de URL al
   hacer scroll → `100vh` cambia → layout shift. Fix:
   `min-height: 100svh` como override de `100vh`.
2. **`scroll-behavior: smooth`** compite con el reflow del URL bar.
   Fix: `scroll-behavior: auto` dentro de `@media (max-width: 720px)`.
3. **`mask-composite: exclude` + `conic-gradient` rotando** en
   pseudo-elementos absolutos → bbox inestable en iOS Safari → el
   elemento "se alarga y empuja todo". Fix: apagar la animación o
   reemplazar el efecto por `box-shadow inset`.
4. **`filter: blur(60px)` en orbs** del hero · GPU expensive en mobile.
   Fix: `filter: none + opacity: .25` en `@media (max-width: 720px)`.
5. **`will-change: transform` en muchos elementos** crea capas
   compositor que multiplican repaints. Fix: `* { will-change: auto !important }`
   en mobile.

### 7.b · Chrome background tabs

- Cuando una tab está hidden (Chrome automation, tab inactiva, etc.),
  Chrome pausa `requestAnimationFrame`, `IntersectionObserver` y eventos
  de `scroll`. Esto puede hacer que TESTS automatizados muestren bugs
  que NO existen para usuarios reales.
- Fix detectado: agregar `visibilitychange` listener que re-fire
  `updateState()` al volver a la tab.

### 7.c · CSS posicionamiento

- **Las pills flotantes con `bottom: X%`** ancladas a una sección
  cuya altura cambia (porque agregaste contenido) caen FUERA y
  pisan la sección siguiente. Pasó con `.hero .float-tag.ft-3/ft-4`.
- Fix general: usar `top: X%` (no `bottom: X%`) cuando la sección
  crezca verticalmente. O posicionar relativo a un subcontenedor
  de altura conocida.

### 7.d · SVG transforms

- `transform: scale()` aplicado a un `<circle>` SVG via CSS NO usa
  el centro del círculo como pivote por default en algunos browsers.
  Hay que setear `transform-origin: <cx>px <cy>px` explícito desde JS:
  `el.style.transformOrigin = \`\${cx}px \${cy}px\``.

### 7.e · Git workflow con sandbox

- El sandbox de mi entorno bloquea `push directo a main` y `self-merge`.
- Pattern correcto cuando ambos fallan:
  1. Push a feature branch
  2. `gh pr create`
  3. Avisar al usuario el link del PR
  4. El usuario aprueba + squash-merge
  5. `git fetch && git reset --hard origin/main` para sincronizar local
     (el squash-merge reescribe los commits, así que `pull --ff-only`
     falla)

### 7.f · GitHub Pages timing

- Después de push a `main`, GitHub Pages tarda **~30-90 segundos** en
  recompilar.
- Pattern para verificar deploy:
  ```bash
  until curl -sL "https://tamibot.github.io/.../?v=$(date +%s)" \
    | grep -q "vN.N"; do sleep 15; done
  ```
- Cache de browser `cache-control: max-age=600` (10 min). Para
  verificar al instante: `?v=timestamp` query param.

### 7.g · Copyright en uso de libs

- Liberías que intentamos y descartamos:
  - **Lenis (smooth scroll)** · virtualizaba el scroll y rompía
    `getBoundingClientRect`. Removido v1.11.
  - **GSAP** · importado pero no usado, peso extra sin valor. Removido.
  - **canvas-confetti** · agregaba complejidad. Reemplazado por SVG nativo.
- Decisión: **vanilla JS + CSS nativo** para todo. El JS total cabe
  en ~700 líneas legibles.

---

## 8 · Historia de versiones del landing

| Versión | Fecha | Cambio principal |
|---------|-------|------------------|
| v1.0 | abril | scaffold inicial 5 pasos verticales |
| v1.5 | abril | tipografía Inter + acentos rosa |
| v1.8 | abril | rail progress + command palette |
| v1.11 | abril | quitar Lenis (smooth virtualizado roto) |
| v1.12 | abril | rework completo · 4 pasos · framing "base para Claude Code" |
| v1.12.3 | abril | fix visibility change para Chrome tabs hidden |
| v1.13 | abril | impeccable design pass + 22 design skills |
| v1.14 | abril | constelación SVG + KPI counters + pipeline + grid + filetree + 3D tilt |
| v1.15 | abril | método overview chapter + mobile polish + contact fix · custom cursor off |
| v1.17 | abril | apagar todas las rotaciones en mobile · scroll jump fix |
| v1.18 | abril | quitar float-tags, conic-rotation, glow halo · nuevo footer 3-col |
| v1.19 | abril | contact rediseñado + pasada mobile agresiva · CTA breath |

---

## 9 · Comandos útiles

```bash
# instalar todo desde cero
./tooling/install.sh

# diagnóstico del entorno
./tooling/doctor.sh

# crear un agente custom del proyecto
./tooling/new-agent.sh mi-agente

# verificar que el plan-maestro esté completo
./tooling/validate-plan.sh

# subir una versión (migrate)
./tooling/migrate.sh

# preview local del landing (puerto 8787)
python3 -m http.server 8787 --directory docs

# ver el PR abierto
gh pr list

# tail del CI
gh run watch
```

---

## 10 · Credenciales · política

**Nunca se commitea `.env` ni archivos con secrets reales**, ni siquiera
en repos privados. Razones:

1. **GitHub historia git es eterna** · borrar el secret en un commit
   posterior NO lo elimina del historial. Hay que hacer `git filter-repo`.
2. **GitHub Secret Scanning** está activo aún en repos privados. Si
   detecta un token (Anthropic, GitHub, Vercel, etc.), revoca el token
   automáticamente y notifica.
3. **Un repo privado puede pasarse a público** por accidente con un
   click. Los secrets ahora son públicos y van a archivos como Wayback,
   bots de minería, etc.
4. **Colaboradores invitados al privado** ven todo. Si querés que tu
   contractor temporal vea código pero NO los secrets de prod, no
   podés hacerlo si están commiteados.

**Pattern correcto** (ya implementado):
- `.env.example` con slots vacíos (commited)
- `.env` local con valores reales (en `.gitignore`)
- Para compartir credenciales con el equipo: 1Password / Bitwarden /
  Doppler / Infisical
- Para CI: GitHub Secrets (Settings → Secrets and variables → Actions)
- Pre-commit hook con `gitleaks` (ya instalado: `tooling/install-gitleaks-hook.sh`)

---

## 11 · Para retomar el proyecto

1. Leé `CLAUDE.md` (10 mandamientos) primero.
2. Leé este `HANDOFF.md`.
3. Si vas a tocar el landing: leé sección 6 + 7 de este doc.
4. Si arrancás proyecto cliente nuevo: invocá agente `onboarding-pm`
   y seguí las 4 fases hasta firmar el Plan Maestro.
5. **Antes de cualquier deploy:** confirmar con el usuario.
6. **Nunca commitear credenciales** (sección 10).

Si hay dudas: preguntar antes de ejecutar (regla del NV).

---

**Fin del handoff.** Suerte con la siguiente sesión.
