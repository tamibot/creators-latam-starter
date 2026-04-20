---
name: plan-paso-a-paso
description: Obliga al sistema a pensar ANTES de paralelizar. Úsalo cuando haya que procesar volumen alto (muchos archivos, muchas llamadas API, muchos registros) o antes de cualquier tarea larga. Decide qué va secuencial y qué paralelo, optimiza recursos, evita que se rompa a la mitad.
---

# Skill · Plan Paso a Paso

## Cuándo invocarlo

- Cuando hay que procesar **más de 10 archivos** en batch.
- Cuando hay que hacer **más de 20 llamadas** a una API.
- Antes de cualquier ejecución que **dure más de 5 minutos**.
- Cuando el usuario dice "hacé esto con todos" y "todos" son muchos.

**Síntoma clásico sin este skill:** "agarré las 50 fotos y las procesé todas juntas → se colapsó la máquina a la mitad y perdí todo lo que había hecho".

## Qué hace

Antes de ejecutar nada, producí un **plan explícito** que responda:

1. **¿Cuántas unidades hay?** Contalas.
2. **¿Cuánto cuesta cada unidad?** Tiempo, tokens, memoria, llamadas.
3. **¿Qué es dependiente?** Si B necesita A, no pueden ir en paralelo.
4. **¿Cuál es el batch size seguro?** Regla base: empezá con 5 en paralelo, escalá si no rompe.
5. **¿Qué hacemos si falla a la mitad?** Plan de reanudación: checkpoints, logs, cola persistente.

## Template de plan

```markdown
# Plan · <nombre tarea>

## Entrada
- Cantidad de unidades: N
- Tipo: (archivos PDF / registros CSV / llamadas API / …)
- Tamaño aprox por unidad: X MB / Y tokens

## Estimación
- Tiempo por unidad: ~Z segundos
- Total secuencial: N × Z = ... minutos
- Total con paralelismo 5: N × Z / 5 = ... minutos
- Tokens totales estimados: ...

## Dependencias
- Paso A debe terminar antes de Paso B porque ...
- Pasos C, D, E son independientes → pueden paralelizar

## Ejecución propuesta
1. (Secuencial) Preparar input: X
2. (Paralelo, batch=5) Procesar unidades 1–50
3. (Secuencial) Consolidar resultado
4. (Secuencial) Validar

## Checkpoints
- Después de cada batch, guardar progreso en `output/.progress.json`.
- Si falla, reanudar desde el último checkpoint.

## Plan de fallo
- Si una unidad falla: loggear, continuar con las demás, reportar al final.
- Si falla el batch completo: parar, reportar al usuario, pedir instrucción.
- Límite duro: abortar si >20% de unidades fallan.
```

## Reglas duras

1. **Nunca ejecutar antes de tener el plan escrito.** Aunque sea corto.
2. **Siempre hay checkpoints** en tareas largas. Si falla a la mitad, no empezamos de cero.
3. **Batch size progresivo:** empezá chico, escalá. Mejor tardar 2 min más que colapsar.
4. **Logs con timestamp** en tareas largas. Para poder diagnosticar sin reejecutar.
5. **Un solo agente hace la orquestación** — no múltiples agentes disparando llamadas a la misma API en paralelo sin coordinación.

## Anti-patrones a evitar

- ❌ "Hacé las 50 conversiones" sin plan → colapsa.
- ❌ "Mandá todos los leads por WhatsApp" sin rate limit → te bloquean la cuenta.
- ❌ Paralelizar escritura al mismo archivo → corruption.
- ❌ `Promise.all(mil_cosas)` → memory blow-up.

## El precio

- ✅ Tardar 30 segundos más en planificar.
- ❌ Tardar 2 horas en debuggear por qué se rompió.

Siempre ganás con el plan.
