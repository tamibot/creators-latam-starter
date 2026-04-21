---
name: video-a-texto
description: Convierte videos o audios a texto/análisis. Úsalo cuando haya que extraer información de un video (YouTube, TikTok, Meet, Zoom, archivo local) o un audio. Soporta 3 modos, Gemini (video directo), yt-dlp (descarga) y whisper.cpp (transcripción local). Elegí según privacidad y costo.
---

# Skill · Video/Audio a texto

## Cuándo invocarlo

- Hay un link de YouTube / TikTok / Instagram / Vimeo que el cliente pasó y necesitás entender qué dice.
- Hay un archivo `.mp4`, `.mov`, `.mp3`, `.wav` en `data_original/`.
- Grabación de reunión (Zoom, Meet) que hay que procesar.
- Llamadas telefónicas del CRM.

## Los 3 modos

### Modo 1 · Gemini API (video directo) — **recomendado por defecto**

Gemini acepta video como input **sin necesidad de transcribir aparte**. Le mandás el `.mp4` y te responde qué ve y qué se dice. Hasta ~1 hora de video.

**Ventaja:** no necesitás extraer audio ni correr whisper. Gemini "mira" frames y escucha audio en un solo paso.

**Requisito:** `GEMINI_API_KEY` en `.env` (conseguir gratis en [aistudio.google.com/apikey](https://aistudio.google.com/apikey)).

**Ejemplo Python:**
```python
import os
from google import genai

client = genai.Client(api_key=os.environ["GEMINI_API_KEY"])

# Subir el video
uploaded = client.files.upload(file="data_original/reunion-cliente.mp4")

# Analizar
response = client.models.generate_content(
    model="gemini-2.5-pro",
    contents=[
        uploaded,
        "Transcribí esta reunión con timestamps. Resumí al final los acuerdos y próximos pasos."
    ]
)

print(response.text)
```

**Casos ideales:**
- Reuniones con cliente donde importa el contenido visual (pantalla compartida).
- Videos de producto donde importa qué se muestra.
- Cuando el cliente no tiene problema con que los datos pasen por Google.

---

### Modo 2 · yt-dlp → Gemini/Whisper (cuando el video está online)

Si el video está en una plataforma (YouTube, TikTok, Instagram, Vimeo, Twitter/X), primero descargalo con `yt-dlp`, después aplicá Modo 1 o 3.

**Descarga:**
```bash
# Mejor calidad posible, formato mp4
yt-dlp -f "bv*+ba/b" --merge-output-format mp4 -o "data_original/%(title)s.%(ext)s" "<URL>"

# Solo audio (más liviano si no necesitás video)
yt-dlp -x --audio-format mp3 -o "data_original/%(title)s.%(ext)s" "<URL>"

# Con subtítulos si existen (más rápido que transcribir)
yt-dlp --write-auto-sub --sub-lang es --skip-download -o "data_original/%(title)s.%(ext)s" "<URL>"
```

**Orden recomendado:**
1. Intentar bajar subtítulos auto (último comando arriba). Si existen, ya tenés el texto.
2. Si no hay subtítulos, descargar audio o video completo.
3. Pasar a Modo 1 (Gemini) o Modo 3 (whisper).

---

### Modo 3 · whisper.cpp (transcripción local, sin nube)

Cuando:
- El contenido es **confidencial** y no puede salir de la máquina.
- Necesitás procesar **mucho volumen** (Gemini cobra por minuto).
- No tenés `GEMINI_API_KEY`.

**Requisito:** `whisper.cpp` instalado y un modelo descargado.

**Extraer audio de un video (si es necesario):**
```bash
ffmpeg -i data_original/video.mp4 -ar 16000 -ac 1 -c:a pcm_s16le /tmp/audio.wav
```

**Transcribir:**
```bash
# Modelo mediano, español, con timestamps
whisper-cli -m ~/.whisper-cpp/models/ggml-medium.bin \
  -f /tmp/audio.wav \
  -l es \
  -ml 16 \
  --output-txt \
  --output-file documentation/transcripcion
```

**Modelos disponibles (descargar una vez):**
| Modelo | Tamaño | Calidad | Velocidad |
|---|---|---|---|
| tiny | 75 MB | baja | ⚡⚡⚡⚡ |
| base | 142 MB | media-baja | ⚡⚡⚡ |
| small | 466 MB | media | ⚡⚡ |
| medium | 1.5 GB | buena | ⚡ |
| large-v3 | 3 GB | muy buena | lento |

**Default recomendado:** `medium` para español, `large-v3` si importa la precisión.

---

## Árbol de decisión

```
¿Dónde está el video/audio?
│
├── Online (YouTube, TikTok, etc.)
│   └── ¿Tiene subtítulos auto?
│       ├── Sí → yt-dlp --write-auto-sub (¡listo!)
│       └── No → yt-dlp descarga → siguiente paso
│
└── Archivo local (.mp4, .mp3, .wav)
    │
    ├── ¿Confidencial? → whisper.cpp (Modo 3)
    ├── ¿Tiene GEMINI_API_KEY? → Gemini directo (Modo 1) ← default
    └── No key + no whisper → pedir una de las dos
```

## Flujo estándar

1. **Identificar fuente:** URL online o archivo local.
2. **Si es online:** correr `yt-dlp --write-auto-sub --skip-download` primero (prueba gratuita de subtítulos).
3. **Si no hay subs:** descargar archivo a `data_original/`.
4. **Elegir modo** según decisión.
5. **Ejecutar** y guardar output en `documentation/transcripciones/`.
6. **Si es una reunión con cliente:** sumar resumen estructurado (participantes, temas, acuerdos, pendientes).

## Reglas duras

1. **Nunca** subir videos/audios con datos personales a Gemini sin confirmar con el usuario. Contenido confidencial → whisper local.
2. **Siempre** guardar transcripciones en `documentation/transcripciones/`, no en `output/` (salvo que el cliente la haya pedido como entregable).
3. Archivos de video en `data_original/` pueden ser grandes — **no commitear al repo** (ya están ignorados en `.gitignore`).
4. Si el video dura más de 1h, usar skill `plan-paso-a-paso`: partir en chunks.
5. `GEMINI_API_KEY` va sólo en `.env`. Nunca en código.

## Instalación

```bash
# Via el script del starter (recomendado)
./tooling/install.sh

# Manual
brew install yt-dlp ffmpeg whisper-cpp
uv pip install google-genai

# Descargar modelo whisper (una vez)
bash <(curl -s https://raw.githubusercontent.com/ggerganov/whisper.cpp/master/models/download-ggml-model.sh) medium
```
