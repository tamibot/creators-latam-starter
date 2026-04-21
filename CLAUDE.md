# Instrucciones para Claude Code (y cualquier LLM) · Creators Latam

Este archivo lo lee el modelo automáticamente al abrir el repo. Son las reglas que NO se negocian.

---

## Identidad del proyecto

- **Cliente:** (completar antes de arrancar)
- **Objetivo:** (completar antes de arrancar)
- **Stack principal:** (completar antes de arrancar)
- **Contacto interno:** Creators Latam — +51 995 547 575 — https://www.creatorslatam.com/

Antes de escribir una sola línea de código, leé estas reglas. No las ignores.

---

## Reglas de oro (10 mandamientos)

### 01. GitHub primero
Antes de pensar en agentes, skills o cliente: repo conectado, permisos de terminal otorgados, `.env` en local. Si no, estamos construyendo sobre arena.

### 02. Un cliente = una carpeta madre
Incluso nuestra propia agencia. Cuando referenciás "el contexto de la empresa", debe estar todo junto.

### 03. Compilá a los 500k tokens
No esperes al millón. Compilar temprano es gratis; depurar errores del modelo confundido, no. Cuando la conversación llegue cerca de 500k, resumí y reiniciá conservando el hilo.

### 04. Reemplazar > duplicar versiones
**Nada de `plan_v2_final_final.md`.** El Versionador reemplaza en sitio y usa git para el historial. Si hace falta volver atrás, hay commits.

### 05. Purgá lo que ya no se usa
Carpeta limpia = contexto limpio. El Purgador entra cada cierto tiempo. El ruido en la carpeta es ruido en el modelo.

### 06. Todo lo final va a `output/`
**Cero excepciones.** Si el cliente pide el Excel, está en `output/`. No se busca entre archivos internos.

### 07. Un agente, un job
Cuando un agente hace dos cosas, hace mal las dos. Mejor 14 agentes chicos que 3 "multipropósito" confundidos. Los agentes base están en `.claude/agents/` — 10 operativos + 4 supervisores (`project-manager`, `arquitecto`, `orquestador`, `guardian-reglas`).

### 08. El NV nunca arranca sin confirmar
Toda ejecución larga empieza con:
> *"Antes de comenzar, dime si tienes dudas, qué no te queda claro y qué información te falta. No inicies nada hasta que yo te avise. Cuando estés listo, avanzás por pasos; si algo no avanza, te detenés y me avisás."*

Template completo en [`templates/nv-prompt.md`](./templates/nv-prompt.md).

### 09. Plan paso a paso > todo en paralelo
La paralelización mal hecha colapsa la máquina y quema tokens. Antes de paralelizar, pensar el orden. Skill en [`.claude/skills/plan-paso-a-paso`](./.claude/skills/plan-paso-a-paso/).

### 10. Si no avanza, no es el modelo
Es el prompt, el contexto o el plan. Cambiar de LLM es la última carta, no la primera.

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
├── .claude/agents/        → 14 agentes (10 operativos + 4 supervisores)
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
