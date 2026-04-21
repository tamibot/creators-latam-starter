---
name: 🤖 Nuevo agente propuesto
about: Proponer un agente nuevo para el starter base
title: "[AGENT] "
labels: new-agent
---

> Solo proponer agentes que sean **generales** (aplicables a múltiples proyectos).
> Agentes específicos de un cliente van en `.claude/agents/` del proyecto puntual.

## Nombre propuesto

\<kebab-case, ej: analista-metricas\>

## Rol

- [ ] Operativo (ejecuta trabajo)
- [ ] Supervisor (coordina / audita / aprende)

## Descripción en una frase

\<Cuándo se invoca este agente\>

## Qué hace

1. …
2. …
3. …

## Qué NO hace

- Anti-patrón 1
- Anti-patrón 2

## Tools que necesita

`Read, Write, Edit, Bash, …`

## ¿Se solapa con agentes existentes?

Revisé [`/.claude/agents/README.md`](../../.claude/agents/README.md) y confirmo que no se solapa con:

- `onboarding-pm` — porque …
- `orquestador` — porque …
- etc.

## Proyectos donde ya se probó

- Proyecto A: resultado
- Proyecto B: resultado

Si es una propuesta teórica (sin testear en proyecto real), marcá: ⚠️ NO PROBADO.

## Output esperado

\<Archivo, reporte, cambio concreto\>

## Delegaciones

- A qué agentes invoca / de qué agentes depende.
