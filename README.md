# Creators Latam · Starter Kit para Proyectos con IA

> Un esqueleto listo para arrancar proyectos con Claude Code, Cursor, Codex, Antigravity o cualquier IDE con agentes de IA. Del caos al `output/` en minutos.

**Creators Latam** · [creatorslatam.com](https://www.creatorslatam.com/) · +51 995 547 575

---

## ¿Qué es esto?

Es el **repositorio base** que usamos internamente en Creators Latam para que cualquier proyecto nuevo arranque con:

- **14 agentes pre-configurados** (10 operativos + 4 supervisores: Orquestador, Guardián de Reglas, Project Manager, Arquitecto)
- **3 skills fundacionales** (PDF/Docs → MD, Video/Audio → texto, Plan Paso a Paso)
- **Arquitectura de carpetas estándar** (`output/`, `data_original/`, `documentation/`…)
- **Templates** del "NV" (prompt de arranque con validación), brief de cliente y research de APIs
- **Reglas de oro** ya escritas en `CLAUDE.md` para que el modelo las siga desde el primer mensaje
- **Permisos preaprobados** en `.claude/settings.json` para no estar autorizando cada comando
- **Script de instalación** (`tooling/install.sh`) que te deja todas las herramientas listas

Si trabajás con LLMs en serio, este repo te ahorra ~2 horas en cada proyecto nuevo.

---

## Uso rápido (3 pasos)

```bash
# 1. Clonar como base de un proyecto nuevo
git clone https://github.com/tamibot/creators-latam-starter.git mi-proyecto
cd mi-proyecto && rm -rf .git && git init

# 2. Instalar herramientas (interactivo — te pregunta qué querés)
./tooling/install.sh

# 3. Copiar variables de entorno y abrir tu IDE
cp .env.example .env    # editá con tus credenciales
claude                  # Claude Code detecta todo solo
```

📖 **Guía completa paso a paso:** [`INSTALL.md`](./INSTALL.md)

En Claude Code, al abrir el repo vas a ver los 14 agentes disponibles con `/agents` y los 3 skills con `/skills`.

---

## Estructura del proyecto

```
creators-latam-starter/
├── README.md             → este archivo
├── CLAUDE.md             → reglas de oro que Claude lee automáticamente
├── LLM.md                → manual de bienvenida para cualquier LLM
├── .env.example          → plantilla de credenciales
├── .claude/
│   ├── settings.json     → permisos preaprobados para Claude Code
│   ├── agents/           → los 14 agentes
│   └── skills/           → pdf-a-markdown, video-a-texto, plan-paso-a-paso
├── tooling/
│   ├── install.sh        → instalador interactivo de herramientas
│   └── README.md         → qué hace cada herramienta, qué instala
├── templates/            → NV prompt, brief cliente, research API
├── workflows/            → flujos específicos del proyecto
├── documentation/        → todo lo que te pasa el cliente
├── data_original/        → PDFs, screenshots, raw data
├── output/               → los entregables finales (lo único que el cliente ve)
└── docs/                 → landing (GitHub Pages)
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
| 12 | Diagramador Mermaid | Diagramas validados, 0 errores de sintaxis |
| 13 | Orquestador | Decide a quién delegar cada sub-tarea, y en qué orden |
| 14 | Guardián de Reglas | Audita que el proyecto cumpla las 10 reglas de oro |

Detalles completos en [`.claude/agents/`](./.claude/agents/).

### Supervisión del escuadrón

Los agentes 06, 09, 13 y 14 son **supervisores** — no ejecutan tareas, coordinan y auditan:

- **Project Manager** (06) — visión estratégica (plazos, estado, prioridades semanales).
- **Arquitecto** (09) — revisa planes *antes* de ejecutar. Filtro de calidad anticipado.
- **Orquestador** (13) — delegación táctica: "para esta tarea específica, ¿quién la hace?"
- **Guardián de Reglas** (14) — auditoría pre-commit/release: verifica las 10 reglas de oro.

---

## Skills fundacionales

Viven en `.claude/skills/`.

- **`pdf-a-markdown`** → convierte PDFs/DOCX/XLSX en MD con marker o markitdown.
- **`video-a-texto`** → YouTube/TikTok/archivos locales a texto vía Gemini, yt-dlp o whisper.
- **`plan-paso-a-paso`** → obliga al sistema a pensar antes de paralelizar.

---

## Herramientas que instala `install.sh`

Detalle completo en [`tooling/README.md`](./tooling/README.md).

| Categoría | Qué se instala |
|---|---|
| **Prerrequisitos** | Homebrew, git, gh, Python 3.12, uv, nvm+Node LTS, ffmpeg, Docker Desktop |
| **Documentos** | `marker-pdf`, `markitdown` |
| **Video/Audio** | `yt-dlp`, `whisper.cpp`, SDK `google-genai` |
| **Terminal** | `ripgrep`, `fd`, `bat`, `fzf`, `jq`, `delta`, `glow`, `zoxide`, `tree` |
| **Diagramas** | `@mermaid-js/mermaid-cli` (on-demand vía npx) |

El script es **interactivo**: pregunta antes de cada bloque. Si ya tenés algo, lo saltea.

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

## ❓ Preguntas frecuentes

### ¿Esto corre en Windows?
El script `tooling/install.sh` asume macOS. **Para Windows**, pedile a Claude/Cursor que aplique lo mismo usando `winget` o `scoop` en lugar de `brew`. Los paquetes Python/Node/Docker tienen instaladores nativos. En Linux, reemplazá `brew` por `apt`/`dnf`.

### ¿Necesito todas las herramientas?
No. El instalador es **interactivo**: te pregunta bloque por bloque. Los prerrequisitos sí los recomendamos todos. El resto depende del proyecto (si no vas a procesar video, saltealo).

### ¿Por qué viene Gemini y no otros modelos?
El skill `video-a-texto` aprovecha que **Gemini acepta video como input directo** (hasta ~1h) — algo que Claude y GPT-4 todavía no ofrecen de forma nativa tan simple. Conseguís el token gratis en [aistudio.google.com/apikey](https://aistudio.google.com/apikey). Para el resto de tareas, usá el LLM que prefieras.

### ¿Qué hace `.claude/settings.json`?
Define qué comandos puede ejecutar Claude Code sin pedirte autorización cada vez. Pre-aprobamos los seguros (`git`, `brew`, `pip`, `npm`, etc.) y **bloqueamos** los peligrosos (`rm -rf /`, `git push --force`, lectura de `.env`). Si querés ser más estricto, editá ese archivo.

### ¿Es seguro dar tantos permisos preaprobados?
El `.claude/settings.json` tiene una lista blanca (lo que se permite) y una **lista negra crítica** (lo que nunca se permite, como `rm -rf`, force-push o leer `.env`). Igual el agente te pide confirmación para operaciones destructivas o que afectan repos remotos.

### ¿Puedo agregar mis propios agentes?
Sí. Creá un `.md` en `.claude/agents/` con el frontmatter estándar (ver cualquier agente existente). Claude Code lo detecta al reiniciar.

### ¿Cómo actualizo el starter a una versión más nueva?
```bash
git remote add starter https://github.com/tamibot/creators-latam-starter.git
git fetch starter
git merge starter/main --allow-unrelated-histories
# Resolver conflictos si los hay (el Versionador te ayuda)
```

### ¿Por qué no hay herramienta de web scraping?
La sacamos a propósito para mantener el starter liviano. Si la necesitás para un proyecto específico, agregala en `tooling/` del proyecto y documentala.

### ¿Qué diferencia tiene con los starters de Vercel/Next?
Aquellos son templates de código. Éste es un **starter de proceso**: reglas, agentes, skills, estructura. Se monta **sobre** cualquier stack técnico.

### Me rompió algo el instalador, ¿qué hago?
El script nunca borra nada y saltea lo que ya tenés. Si algo falló, revisá el output — te dice qué paquete específico no pudo instalar y probablemente tengas que correrlo manualmente (`brew install <pkg>`) para ver el error real.

---

## Contacto

¿Querés que montemos el sistema completo para tu empresa? Automatizamos gestión de clientes con ChatBots con IA + CRM, 24/7.

- 🌐 [creatorslatam.com](https://www.creatorslatam.com/)
- 📱 +51 995 547 575

---

**Creators Latam** · Documento vivo · v1.1
