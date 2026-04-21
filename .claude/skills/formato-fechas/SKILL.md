---
name: formato-fechas
description: Normaliza formato de fechas en docs del proyecto. Detecta formatos inconsistentes (dd/mm/yyyy vs yyyy-mm-dd vs "21 Abril 2026") y los convierte a ISO 8601 (YYYY-MM-DD) en todo el repo. Úsalo periódicamente o antes de un handoff donde la consistencia importa.
---

# Skill · Formato de fechas

## Cuándo invocarlo

- **Antes de un handoff al cliente** — el `handoff-cliente` lo dispara.
- **Periódico** — mensualmente en la auditoría del `guardian-reglas`.
- **Cuando detectás mezcla** — si ves `21/04/2026` y `2026-04-21` en el mismo doc.

## Formato canónico

Usamos **ISO 8601** en todo:

| Tipo | Formato canónico | Ejemplo |
|---|---|---|
| Fecha | `YYYY-MM-DD` | `2026-04-21` |
| Fecha + hora | `YYYY-MM-DDTHH:MM:SS±HH:MM` | `2026-04-21T14:30:00-05:00` |
| Solo mes-año | `YYYY-MM` | `2026-04` |
| Solo año | `YYYY` | `2026` |

## Excepciones (no tocar)

- **Material visible al cliente final** (entregables en `output/`) puede usar formato localizado: `21 Abr 2026`.
- **Citas textuales** en documentos legales — respetá el formato original.
- **URLs y slugs** — si una URL contiene fecha, dejala.

## Patrones a detectar y normalizar

```bash
# dd/mm/yyyy
21/04/2026 → 2026-04-21

# dd-mm-yyyy
21-04-2026 → 2026-04-21

# Month DD, YYYY
April 21, 2026 → 2026-04-21

# DD de Mes de YYYY
21 de Abril de 2026 → 2026-04-21

# DD Mes YYYY
21 Abril 2026 → 2026-04-21
```

## Script base

```python
#!/usr/bin/env python3
"""Normaliza fechas en archivos Markdown del repo."""
import re
import sys
from pathlib import Path

MESES_ES = {
    'enero': '01', 'febrero': '02', 'marzo': '03', 'abril': '04',
    'mayo': '05', 'junio': '06', 'julio': '07', 'agosto': '08',
    'septiembre': '09', 'octubre': '10', 'noviembre': '11', 'diciembre': '12',
    'ene': '01', 'feb': '02', 'mar': '03', 'abr': '04',
    'may': '05', 'jun': '06', 'jul': '07', 'ago': '08',
    'sep': '09', 'oct': '10', 'nov': '11', 'dic': '12',
}

def normalize(text: str) -> str:
    # dd/mm/yyyy → yyyy-mm-dd
    text = re.sub(
        r'\b(\d{1,2})/(\d{1,2})/(\d{4})\b',
        lambda m: f"{m.group(3)}-{m.group(2).zfill(2)}-{m.group(1).zfill(2)}",
        text
    )
    # dd-mm-yyyy → yyyy-mm-dd (cuidado: no tocar yyyy-mm-dd ya canónico)
    text = re.sub(
        r'\b(\d{1,2})-(\d{1,2})-(\d{4})\b',
        lambda m: f"{m.group(3)}-{m.group(2).zfill(2)}-{m.group(1).zfill(2)}"
            if int(m.group(1)) > 31 == False else m.group(0),
        text
    )
    # DD de Mes de YYYY → YYYY-MM-DD
    pattern_es = r'\b(\d{1,2})\s+de\s+(enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre)\s+de\s+(\d{4})\b'
    text = re.sub(
        pattern_es,
        lambda m: f"{m.group(3)}-{MESES_ES[m.group(2).lower()]}-{m.group(1).zfill(2)}",
        text, flags=re.IGNORECASE
    )
    return text

def process_file(path: Path, dry_run: bool = True) -> int:
    original = path.read_text()
    normalized = normalize(original)
    if original == normalized:
        return 0
    changes = sum(1 for a, b in zip(original.splitlines(), normalized.splitlines()) if a != b)
    if dry_run:
        print(f"[DRY-RUN] {path}: {changes} líneas cambiarían")
    else:
        path.write_text(normalized)
        print(f"✓ {path}: {changes} líneas normalizadas")
    return changes

if __name__ == '__main__':
    dry_run = '--apply' not in sys.argv
    scope = [
        Path('documentation'),
        Path('templates'),
    ]
    total = 0
    for base in scope:
        if not base.exists(): continue
        for md in base.rglob('*.md'):
            total += process_file(md, dry_run=dry_run)
    print(f"\nTotal: {total} cambios")
    print("Agregá --apply para aplicar." if dry_run else "")
```

Guardalo como `tooling/normalize-dates.py`.

## Flujo estándar

1. **Dry run:** `python3 tooling/normalize-dates.py`
2. **Revisar** los cambios propuestos.
3. **Aplicar:** `python3 tooling/normalize-dates.py --apply`
4. **Commit:** `git add -A && git commit -m "chore: normalizar formato de fechas a ISO"`

## Alcance

Por default normaliza en:
- `documentation/**/*.md`
- `templates/**/*.md`

NO toca:
- `output/**` (contenido final al cliente)
- `data_original/**` (raw del cliente)
- Archivos `.json` (tienen formato propio, no reformat)
- `CHANGELOG.md` (puede tener citas)

## Reglas duras

1. **Siempre dry-run primero.** Nunca `--apply` directo sin revisar.
2. **Commit con cambios en bloque** — no mezclar con otros cambios.
3. **No tocar `output/`** — puede romper entregables.
4. **ISO 8601 siempre** en docs internos.
5. **Formato localizado OK** en material para cliente final.

## Delegaciones

- `versionador` → si crea duplicados (docs con y sin fechas raras), reemplazar.
- `chronicler` → registrar que se corrió la normalización.
