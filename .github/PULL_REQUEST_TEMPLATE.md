## Qué cambia

\<Resumen corto\>

## Por qué

\<Problema que resuelve / valor que agrega\>

## Tipo de cambio

- [ ] 🐛 Bug fix
- [ ] ✨ Feature nueva
- [ ] 🤖 Agente nuevo / mejorado
- [ ] 🛠️ Skill / tooling
- [ ] 📝 Docs / landing
- [ ] ♻️ Refactor sin cambios funcionales
- [ ] 🔒 Security fix

## Checklist del guardián

- [ ] No hay credenciales hardcoded (`grep -i "sk-\|ghp_\|AIza"`)
- [ ] `.env` no está incluido
- [ ] Archivos grandes (>5MB) no commiteados
- [ ] Si agregué un agente: frontmatter válido + único
- [ ] Si agregué un skill: SKILL.md con frontmatter
- [ ] Si agregué un script: `chmod +x` y `bash -n` syntax OK
- [ ] Si cambié la landing: probé en `file://` local primero
- [ ] Corrí `./tooling/doctor.sh` y pasa

## Impacto en otros archivos

- [ ] CHANGELOG.md actualizado
- [ ] README.md badges / conteos ajustados (si aplica)
- [ ] `.claude/agents/README.md` actualizado (si agregué agente)
- [ ] `documentation/mapa-sistema.md` se va a regenerar

## Cómo testear

\<Pasos para que el reviewer pruebe\>

## Screenshots (si aplica)

\<Si cambiaste landing o UI\>

---

🤖 **Guardián de Reglas** — auditar antes de mergear:
`@claude invocá guardian-reglas`
