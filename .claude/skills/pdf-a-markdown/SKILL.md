---
name: pdf-a-markdown
description: Convierte archivos PDF a Markdown usando librerías open-source. Úsalo SIEMPRE que haya un PDF en data_original/ antes de intentar analizarlo. Los modelos leen markdown 10x más rápido y barato que PDFs.
---

# Skill · PDF a Markdown

## Cuándo invocarlo

Toda vez que aparezca un archivo `.pdf` en el proyecto — especialmente en `data_original/` — y necesites que un LLM lo lea.

**Regla:** nunca leas PDFs directamente con el modelo. Siempre convertir primero.

## Por qué

- Los PDFs vienen con layout que confunde al modelo (columnas, tablas, imágenes).
- Pasar un PDF a texto plano o MD reduce tokens 3-10x.
- Markdown preserva estructura (headings, listas, tablas) de forma que el modelo entiende.

## Herramientas recomendadas

### Opción 1 · [MarkItDown](https://github.com/microsoft/markitdown) (Microsoft)
```bash
pip install 'markitdown[all]'
markitdown data_original/documento.pdf > documentation/documento.md
```

Pros: soporta PDF, DOCX, PPTX, XLSX, imágenes con OCR.
Contras: OCR puede ser lento con PDFs grandes.

### Opción 2 · [pdfplumber](https://github.com/jsvine/pdfplumber) + script custom
Mejor para PDFs con tablas complejas.

```python
import pdfplumber

with pdfplumber.open("data_original/doc.pdf") as pdf:
    md = []
    for page in pdf.pages:
        md.append(page.extract_text())
        for table in page.extract_tables():
            md.append(tabla_a_markdown(table))
    open("documentation/doc.md", "w").write("\n\n".join(md))
```

### Opción 3 · [Docling](https://github.com/DS4SD/docling) (IBM)
```bash
pip install docling
docling data_original/doc.pdf --to md --output documentation/
```

Mejor para papers científicos y documentos con muchas fórmulas.

## Flujo estándar

1. **Chequear si ya existe el MD:** `ls documentation/ | grep -i $(basename doc .pdf)`
2. **Elegir herramienta** según tipo de PDF:
   - Documento simple → MarkItDown.
   - Muchas tablas → pdfplumber.
   - Paper técnico → Docling.
3. **Convertir.**
4. **Abrir el MD y verificar** que no se perdió info importante (headers, tablas, etc.).
5. **Guardar en `documentation/`** con nombre claro.
6. **Registrar** la conversión en la bitácora si el doc es importante (via `chronicler`).

## Reglas duras

1. Nunca borrar el PDF original de `data_original/`.
2. Si el PDF tiene más de 50 páginas, usar el skill `plan-paso-a-paso`: convertir por chunks.
3. Si el MD tiene más de 100KB, considerar splittearlo por capítulos.
4. Si el PDF tiene imágenes importantes, extraer aparte: `pdfimages doc.pdf imgs/`.

## Instalación one-liner

```bash
pip install markitdown[all] pdfplumber docling
```

Agregalo al `README.md` del proyecto cuando el skill se use por primera vez.
