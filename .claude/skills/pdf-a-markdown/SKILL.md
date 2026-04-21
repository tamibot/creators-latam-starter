---
name: pdf-a-markdown
description: Convierte archivos PDF (y otros documentos) a Markdown usando marker o MarkItDown. Úsalo SIEMPRE que haya un PDF en data_original/ antes de intentar analizarlo. Los modelos leen markdown 10x más rápido y barato que PDFs.
---

# Skill · PDF / Documento a Markdown

## Cuándo invocarlo

Toda vez que aparezca un archivo `.pdf`, `.docx`, `.pptx`, `.xlsx`, `.html` o imagen escaneada en el proyecto y necesites que un LLM lo lea.

**Regla:** nunca leas PDFs directamente con el modelo. Siempre convertir primero.

## Por qué

- Los PDFs vienen con layout que confunde al modelo (columnas, tablas, imágenes).
- Pasar un documento a texto plano o MD reduce tokens 3–10×.
- Markdown preserva estructura (headings, listas, tablas) de forma que el modelo entiende.

## Las 2 herramientas que usamos

### 1. `marker` — [datalab-to/marker](https://github.com/datalab-to/marker)

**Cuándo:** PDFs largos, técnicos, con tablas complejas, fórmulas o imágenes importantes. Papers académicos. Contratos. Manuales.

**Fortaleza:** mejor calidad del mercado para PDF. Preserva orden de lectura, tablas, ecuaciones LaTeX y extrae imágenes aparte.

**Comando:**
```bash
# Un solo archivo
marker_single data_original/documento.pdf --output_dir documentation/

# Batch (toda una carpeta)
marker data_original/ --output_dir documentation/ --workers 4
```

**Output:** genera una carpeta por documento con:
- `documento.md` — el markdown.
- `documento_meta.json` — metadata (páginas, idioma, etc).
- `imgs/` — imágenes extraídas.

### 2. `markitdown` — [microsoft/markitdown](https://github.com/microsoft/markitdown)

**Cuándo:** todo lo demás. Es más rápido y soporta más formatos.

**Fortaleza:** además de PDF, convierte DOCX, PPTX, XLSX, HTML, imágenes (OCR), audio (transcripción).

**Comando:**
```bash
# Un archivo (cualquier formato)
markitdown data_original/docs/contrato.docx > documentation/contrato.md
markitdown data_original/slides/demo.pptx > documentation/demo.md
markitdown data_original/web/landing.html > documentation/landing.md
```

## Árbol de decisión

```
¿Qué archivo tenés?
│
├── PDF con tablas complejas / ecuaciones / paper científico → marker
├── PDF simple (texto plano, pocos elementos) → markitdown (más rápido)
├── DOCX / PPTX / XLSX → markitdown
├── HTML / Imagen (OCR) → markitdown
└── Audio → video-a-texto (otro skill)
```

## Flujo estándar

1. **Chequear** si ya existe el MD: `ls documentation/ | grep -i $(basename doc .pdf)`
2. **Elegir herramienta** (árbol de decisión arriba).
3. **Convertir.**
4. **Abrir el MD y verificar** que no se perdió info importante (headers, tablas, etc.).
5. **Guardar en `documentation/`** con nombre claro: `nombre-original-sin-espacios.md`.
6. **Registrar** la conversión en la bitácora si el doc es importante (via `chronicler`).

## Reglas duras

1. Nunca borrar el PDF original de `data_original/`.
2. Si el PDF tiene más de 50 páginas, usar el skill `plan-paso-a-paso`: convertir por chunks.
3. Si el MD resultante tiene más de 100KB, considerar splittearlo por capítulos.
4. Si el PDF tiene imágenes importantes, marker ya las extrae a su carpeta. Con markitdown, si necesitás imágenes, usá `pdfimages doc.pdf imgs/`.
5. Nombres de archivo sin espacios ni acentos en el output. `contrato-acme-abril2026.md`, no `Contrato Acme (Abril 2026).md`.

## Instalación

Ver [`tooling/README.md`](../../../tooling/README.md) o correr `./tooling/install.sh`.

Comandos directos:
```bash
pip install marker-pdf markitdown[all]
# o con uv (más rápido)
uv pip install marker-pdf markitdown[all]
```

## Troubleshooting

- **marker tarda mucho la primera vez:** descarga modelos (~2GB). Sólo la primera corrida.
- **markitdown falla con PDF grande:** cambiar a marker, tiene mejor manejo.
- **OCR en imágenes no funciona:** instalar `tesseract`: `brew install tesseract tesseract-lang`.
- **No extrae tablas:** usar marker, no markitdown.
