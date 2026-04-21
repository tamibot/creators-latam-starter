# Skills · Creators Latam Starter

Skills que Claude Code monta automáticamente desde esta carpeta.

## Skills base (4)

| Skill | Cuándo se invoca |
|---|---|
| [`plan-maestro`](plan-maestro/SKILL.md) | ⭐ Al arranque — genera scaffold del Plan Maestro |
| [`pdf-a-markdown`](pdf-a-markdown/SKILL.md) | Todo PDF/DOCX/XLSX entra acá antes de ser leído |
| [`video-a-texto`](video-a-texto/SKILL.md) | YouTube / archivos locales → texto |
| [`plan-paso-a-paso`](plan-paso-a-paso/SKILL.md) | Antes de procesar volumen alto |

## Agregar skills del proyecto

```bash
mkdir -p .claude/skills/mi-skill
# Crear SKILL.md con frontmatter: name, description
```

```markdown
---
name: mi-skill
description: Cuándo se invoca. Sé específico.
---

# Skill body
```
