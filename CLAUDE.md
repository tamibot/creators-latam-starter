# Instrucciones para Claude Code (y cualquier LLM) · Creators Latam

Este archivo lo lee el modelo automáticamente al abrir el repo. Son las reglas que NO se negocian.

> **Importante:** este repo es una **base extensible**, no una caja cerrada. Los 32 agentes y 5 skills son el piso común a todo proyecto. Arriba de esta base, cada proyecto suma lo específico (agentes custom, skills del dominio, workflows puntuales). Si detectás un patrón que aparece en 3+ proyectos, proponelo al starter base.

---

## 🎯 Metodología · lee esto primero

Todo proyecto nuevo pasa por **3 fases obligatorias** antes de ejecutar nada:

1. **FASE 1 · Entregables** — pensar desde el final (qué recibe el cliente).
2. **FASE 2 · Stack Tecnológico** — qué herramientas y por qué (con research en foros).
3. **FASE 3 · Equipo y Plan** — qué agentes, qué orden, qué hitos.

El output: un **Plan Maestro** firmado por el cliente (`documentation/plan-maestro.md`). **Sin plan firmado, no arranca nada.**

Agente que guía las 3 fases: [`onboarding-pm`](./.claude/agents/onboarding-pm.md).
Template: [`templates/plan-maestro.md`](./templates/plan-maestro.md).

---

## Identidad del proyecto

- **Cliente:** (completar tras Fase 1)
- **Objetivo:** (completar tras Fase 1)
- **Stack principal:** (completar tras Fase 2)
- **Contacto interno:** Creators Latam — +51 995 547 575 — https://www.creatorslatam.com/

Si empezás un proyecto nuevo, invocá primero al agente `onboarding-pm`. Él arranca las 3 fases.

---

## Reglas de oro (10 mandamientos)

### 01. Plan Maestro antes de ejecutar
Todo proyecto nuevo arranca con las 3 fases metodológicas (Entregables → Stack → Equipo) guiadas por el `onboarding-pm`. Sin Plan Maestro firmado por el cliente, no se escribe código. Template en [`templates/plan-maestro.md`](./templates/plan-maestro.md).

### 02. GitHub primero
Antes de pensar en agentes, skills o cliente: repo conectado, permisos de terminal otorgados, `.env` en local. Si no, estamos construyendo sobre arena.

### 03. Un cliente = una carpeta madre
Incluso nuestra propia agencia. Cuando referenciás "el contexto de la empresa", debe estar todo junto.

### 04. Compilá a los 500k tokens
No esperes al millón. Compilar temprano es gratis; depurar errores del modelo confundido, no. Cuando la conversación llegue cerca de 500k, resumí y reiniciá conservando el hilo.

### 05. Reemplazar > duplicar versiones
**Nada de `plan_v2_final_final.md`.** El Versionador reemplaza en sitio y usa git para el historial. Si hace falta volver atrás, hay commits.

### 06. Todo lo final va a `output/`
**Cero excepciones.** Si el cliente pide el Excel, está en `output/`. No se busca entre archivos internos.

### 07. Un agente, un job
Cuando un agente hace dos cosas, hace mal las dos. Mejor 32 agentes chicos que 3 "multipropósito" confundidos. Los agentes base están en `.claude/agents/` — 22 operativos + 10 supervisores.

### 08. El NV nunca arranca sin confirmar
Toda ejecución larga empieza con:
> *"Antes de comenzar, dime si tienes dudas, qué no te queda claro y qué información te falta. No inicies nada hasta que yo te avise. Cuando estés listo, avanzás por pasos; si algo no avanza, te detenés y me avisás."*

Template completo en [`templates/nv-prompt.md`](./templates/nv-prompt.md).

### 09. Plan paso a paso > todo en paralelo
La paralelización mal hecha colapsa la máquina y quema tokens. Antes de paralelizar, pensar el orden. Skill en [`.claude/skills/plan-paso-a-paso`](./.claude/skills/plan-paso-a-paso/).

### 10. Si no avanza, no es el modelo
Es el prompt, el contexto o el plan. Cambiar de LLM es la última carta, no la primera.

### ➕ Regla bonus · Purgá lo que ya no se usa
Carpeta limpia = contexto limpio. El Purgador entra cada cierto tiempo. El ruido en la carpeta es ruido en el modelo.

---

## Flujo operativo estándar

```
MD sucio  →  MD limpio (NV)  →  Ejecutás
```

1. **MD sucio:** tiramos contexto, notas, dudas, screenshots. Lo que sea.
2. **MD limpio:** pasamos el sucio por un LLM de contexto grande (Gemini, GPT) y sale el "NV" — prompt estructurado y ejecutable.
3. **Ejecutás:** el NV se le pasa al agente correcto para que arranque (previo "dame dudas").

---

## Arquitectura de carpetas

```
./
├── .claude/settings.json  → permisos preaprobados para Claude
├── .claude/agents/        → 32 agentes (10 operativos + 5 supervisores)
├── .claude/skills/        → 3 skills base (pdf, video, plan)
├── tooling/               → install.sh + docs de herramientas externas
├── templates/             → NV, brief, API research
├── workflows/             → flujos específicos del proyecto
├── documentation/         → lo que pasa el cliente (incluye diagramas)
├── data_original/         → PDFs, raw uploads (no tocar)
├── output/                → entregables finales
└── .env                   → credenciales locales (NUNCA subir)
```

- Todo PDF que entra a `data_original/` se convierte a MD antes de usarse (skill `pdf-a-markdown`).
- Todo video/audio pasa por skill `video-a-texto` antes de análisis.
- Los diagramas van a `documentation/diagramas/` y los hace el agente `diagramador-mermaid`.
- Nada sensible se commitea. `.env` está en `.gitignore`.

---

## Cuando el usuario pide algo ambiguo

**No adivinés.** Preguntá. La regla del NV aplica siempre: si falta contexto, pedilo antes de ejecutar.

## Cuando el usuario pide tocar credenciales

Invocar `credentials-manager` (agente 05). Nunca pegar API keys en un commit, ni siquiera en logs.

## Cuando el usuario pide un deploy o push

Confirmar antes. Push, merge a main, force-push: siempre pedir autorización explícita.

---

## Ranking de LLMs (referencia interna)

1. **GPT 5.4** — mejor razonamiento general.
2. **Gemini Pro 3.1** — contexto largo (1M tokens reales), ideal para compilar MDs sucios.
3. **Claude Opus** — vía Antigravity por consumo gratuito; excelente para agentes.

Cambiar de modelo es una decisión táctica, no un reflejo.

---

Fin del documento. Ahora sí: arrancá.
