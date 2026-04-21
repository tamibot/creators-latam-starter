# Variantes de `.claude/settings.json`

Tres perfiles de permisos según el entorno.

## Cómo usar

El archivo activo es `.claude/settings.json` (en la raíz de `.claude/`). Para cambiar de perfil:

```bash
# Activar perfil development (amplio, default)
cp .claude/settings/development.json .claude/settings.json

# Activar perfil production (restrictivo)
cp .claude/settings/production.json .claude/settings.json

# Activar perfil onboarding (muy restrictivo, para aprender)
cp .claude/settings/onboarding.json .claude/settings.json
```

Tras el cambio, **reiniciá Claude Code** para que lea la nueva config.

## Perfiles

| Perfil | Cuándo usarlo | Filosofía |
|---|---|---|
| [`development.json`](./development.json) | Day-to-day, MVP, prototipos | Permisivo. Bloquea sólo lo destructivo crítico. |
| [`production.json`](./production.json) | Cambios en infra / datos reales | Restrictivo. Pide aprobación para más comandos. |
| [`onboarding.json`](./onboarding.json) | Colaborador nuevo aprendiendo | Muy restrictivo. Casi todo requiere aprobación explícita. |

## Settings local (no versionado)

Si querés permisos extra personales sin modificar el settings compartido:

```bash
cp .claude/settings.json .claude/settings.local.json
# Editar con tus permisos adicionales
```

`.claude/settings.local.json` está en `.gitignore` — nunca se commitea. Claude Code lo mergea con el settings principal.
