# Template · Prompt NV (Nota de Voz ejecutable)

> El "NV" es el prompt final, limpio, que le pasás al agente. Sale de procesar un MD sucio con un LLM de contexto grande (Gemini 1.5M o GPT) y condensarlo en este formato.

---

## 🔒 Bloque obligatorio de apertura (NUNCA sacarlo)

```
Antes de comenzar, dime si tienes dudas, qué no te queda claro y qué información te falta.
No inicies nada hasta que yo te avise.
Cuando estés listo, avanzás por pasos; si algo no avanza, te detenés y me avisás.
```

Esto resuelve el 80% de los errores antes de que ocurran.

---

## 📋 Cuerpo del NV

```markdown
# NV · <nombre de la tarea>

## Contexto
<1-2 párrafos: quién es el cliente, qué estamos haciendo, por qué>

## Objetivo
<Qué tiene que existir cuando termine. Criterio de éxito claro.>

## Entrada
- Archivo 1: ruta/al/archivo (qué es)
- Archivo 2: …
- Variable X en `.env`

## Salida esperada
- Ubicación: `output/...`
- Formato: (MD / CSV / JSON / ...)
- Validación: cómo sé que está bien

## Restricciones
- No tocar: ...
- No crear duplicados (ver Versionador)
- Credenciales sólo vía `.env`

## Pasos sugeridos
1. …
2. …
3. …

## Agentes a invocar
- Paso 1 → <agente>
- Paso 3 → <agente>

## Criterio de corte
Si al paso N no hay avance después de X intentos, detenete y avisame.
```

---

## 📌 Tips para armar el NV

- **Sacá todo lo ambiguo.** Si no lo podés explicar, el agente no lo va a ejecutar.
- **Pegá referencias reales.** Rutas de archivo, URLs, IDs. Nada de "el archivo que te pasé".
- **Definí la salida antes que el proceso.** Saber dónde termina es más importante que saber cómo.
- **Incluí el criterio de corte.** Evitás ejecuciones infinitas por prompt ambiguo.

---

## Ejemplo real

```markdown
Antes de comenzar, dime si tienes dudas, qué no te queda claro y qué información te falta.
No inicies nada hasta que yo te avise.
Cuando estés listo, avanzás por pasos; si algo no avanza, te detenés y me avisás.

# NV · Compilar leads de los 3 PDFs del cliente Acme

## Contexto
Acme nos pasó 3 PDFs con listas de leads de eventos diferentes. Necesitamos un CSV único para cargar a Kommo.

## Objetivo
Un único CSV en `output/leads-acme-abril2026.csv` con columnas: nombre, email, teléfono, empresa, fuente_evento.

## Entrada
- `data_original/evento-lima-2026-03.pdf`
- `data_original/evento-bogota-2026-03.pdf`
- `data_original/evento-cdmx-2026-03.pdf`

## Salida esperada
- `output/leads-acme-abril2026.csv`
- Separador: coma, encoding UTF-8.
- Sin duplicados por email.
- Validación: `wc -l output/leads-acme-abril2026.csv` debe devolver ≈ 450 (±10%).

## Restricciones
- No tocar los PDFs originales.
- Emails en minúscula.
- Teléfonos con código de país: `+51...`.

## Pasos sugeridos
1. Convertir los 3 PDFs a MD con el skill `pdf-a-markdown`.
2. Extraer tablas de leads a 3 CSVs temporales.
3. Consolidar a uno solo, deduplicar por email, normalizar teléfonos.
4. Validar conteo y muestrear 10 filas al azar.

## Agentes a invocar
- Paso 1 → compilador-datos + skill pdf-a-markdown
- Paso 3 → compilador-datos
- Paso 4 → tester

## Criterio de corte
Si después del paso 1 algún PDF no se convirtió bien, detenete y avisame.
```
