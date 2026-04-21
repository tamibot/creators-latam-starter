# Skills · Creators Latam Starter

Skills que Claude Code monta automáticamente al detectar esta carpeta.

## Skills base

| Nombre | Cuándo se invoca |
|---|---|
| [`pdf-a-markdown`](pdf-a-markdown/SKILL.md) | Todo PDF/DOCX/XLSX entra acá antes de ser leído por el modelo |
| [`video-a-texto`](video-a-texto/SKILL.md) | Videos o audios (YouTube, archivos locales, grabaciones) → texto |
| [`plan-paso-a-paso`](plan-paso-a-paso/SKILL.md) | Antes de procesar volumen alto o ejecutar tareas largas |

## Agregar skills del proyecto

```bash
mkdir -p .claude/skills/mi-skill
# Crear SKILL.md con frontmatter: name, description
```

Formato:
```markdown
---
name: mi-skill
description: Cuándo se invoca. Sé específico.
---

# Skill body
```
