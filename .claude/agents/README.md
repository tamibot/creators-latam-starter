# Agentes · Creators Latam Starter

**27 agentes** — un agente, un job.

Claude Code los detecta automáticamente. Invocalos con `/agents` o pediles por nombre.

## 🌟 Supervisores (9 · coordinan, auditan, aprenden)

| # | Emoji | Nombre | Job |
|---|---|---|---|
| 18 | 🤝 | [`kickoff-cliente`](kickoff-cliente.md) | Primera reunión: minuta + brief + preview |
| 15 | 🧭 | [`onboarding-pm`](onboarding-pm.md) ⭐ | Guía las 3 fases → Plan Maestro |
| 13 | 🎼 | [`orquestador`](orquestador.md) | Delega qué agente, qué orden |
| 06 | 📊 | [`project-manager`](project-manager.md) | Visión estratégica, plazos, prioridades |
| 09 | 🏗️ | [`arquitecto`](arquitecto.md) | Revisa planes técnicos pre-ejecución |
| 14 | 🛡️ | [`guardian-reglas`](guardian-reglas.md) | Audita las 10 reglas pre-commit |
| 19 | 🗺️ | [`mapa-sistema`](mapa-sistema.md) | Catálogo visual completo del sistema |
| 20 | 🧠 | [`analizador-patrones`](analizador-patrones.md) | Aprende entre proyectos |
| 23 | 📈 | [`status-dashboard`](status-dashboard.md) | Foto del estado actual del proyecto |

## 🛠️ Operativos (18 · ejecutan el trabajo)

| # | Emoji | Nombre | Job |
|---|---|---|---|
| 01 | 📝 | [`documentador`](documentador.md) | Mantiene docs al día |
| 02 | 🐙 | [`github-keeper`](github-keeper.md) | Commits, branches, orden del repo |
| 03 | 📦 | [`compilador-datos`](compilador-datos.md) | Junta, limpia y estructura datos |
| 04 | 📜 | [`chronicler`](chronicler.md) | Bitácora viva |
| 05 | 🔑 | [`credentials-manager`](credentials-manager.md) | Gestiona `.env` y accesos |
| 07 | 🧪 | [`tester`](tester.md) | Solo testea. No arregla |
| 08 | 🔌 | [`integraciones`](integraciones.md) | APIs, webhooks, servicios |
| 10 | 🧷 | [`versionador`](versionador.md) | Reemplaza > duplica |
| 11 | 🧹 | [`purgador`](purgador.md) | Barre lo muerto |
| 12 | 📐 | [`diagramador-mermaid`](diagramador-mermaid.md) | Diagramas Mermaid sin errores |
| 16 | 🔁 | [`test-debug-loop`](test-debug-loop.md) | Prueba → error → fix → re-prueba |
| 17 | 🌐 | [`integrador-herramientas`](integrador-herramientas.md) | Conecta APIs/MCP/n8n (API first) |
| 21 | 💬 | [`comentarios-adicionales`](comentarios-adicionales.md) | Feedback estructurado |
| 22 | 🗄️ | [`archivero`](archivero.md) | Curador del filesystem |
| 24 | 📗 | [`excel-builder`](excel-builder.md) | Genera .xlsx profesionales |
| 25 | 💰 | [`cost-tracker`](cost-tracker.md) | Estima y monitorea costos |
| 26 | 📦 | [`handoff-cliente`](handoff-cliente.md) | Paquete final al cliente |
| 27 | 🔐 | [`security-auditor`](security-auditor.md) | Secrets, CVE, permisos, OWASP |

## Flujo de un proyecto

```
Primera llamada con cliente
         │
         ▼
🤝 kickoff-cliente (18) · minuta + brief
         │
         ▼
🧭 onboarding-pm (15) · guía las 3 fases
         │
         ├──→ Fase 1: Entregables (firma cliente)
         ├──→ Fase 2: Stack (firma cliente)
         └──→ Fase 3: Equipo + Plan (firma cliente)
         │
         ▼
./tooling/validate-plan.sh · chequea firmas
         │
         ▼
🎼 orquestador (13) · descompone tareas y delega
         │
    ┌────┴────┬─────────┬─────────┐
    ▼         ▼         ▼         ▼
  operativos 🏗️ arq.  🛡️ guardian  📊 PM
    │         │         │         │
    └─────────┴─────────┴─────────┘
         │
         ▼
  📗 excel-builder / 🔌 integraciones / 🧪 tester
         │
         ▼
  🔐 security-auditor (pre-release)
         │
         ▼
  📦 handoff-cliente (entrega final)
         │
         ▼
  💬 comentarios-adicionales (feedback)
         │
         ▼
  🧠 analizador-patrones (mensual · aprende)
```

## Agregar agentes custom del proyecto

Durante Fase 3 del Plan Maestro, el `onboarding-pm` puede proponer agentes custom.

```markdown
---
name: mi-agente
description: Cuándo activarlo. Específico.
tools: Read, Write, Bash, Grep
---

Prompt del sistema…
```

CI valida el frontmatter en cada push.

## Cuándo invocar a cada uno

- **Cliente nuevo** → `kickoff-cliente` → `onboarding-pm`
- **Plan firmado, arrancar** → `orquestador`
- **Conectar herramienta nueva** → `integrador-herramientas`
- **Debugear flujo que falla** → `test-debug-loop`
- **Generar Excel** → `excel-builder`
- **Antes de commit grande** → `guardian-reglas`
- **Monthly check** → `analizador-patrones`, `cost-tracker`, `security-auditor`
- **Limpieza filesystem** → `archivero`
- **Ver inventario** → `mapa-sistema`
- **"¿Cómo vamos?"** → `status-dashboard`
- **Entrega final** → `handoff-cliente`
- **Post-fase** → `comentarios-adicionales`
