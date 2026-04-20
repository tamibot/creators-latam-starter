# Skills · Creators Latam Starter

Skills que Claude Code monta automáticamente al detectar esta carpeta.

## Skills base

| Nombre | Cuándo |
|---|---|
| [`pdf-a-markdown`](pdf-a-markdown/SKILL.md) | Todo PDF entra acá antes de ser leído por el modelo |
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
