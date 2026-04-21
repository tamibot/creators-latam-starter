---
description: Corre ./tooling/doctor.sh y muestra el diagnóstico del proyecto.
---

Ejecutá `./tooling/doctor.sh` y mostrame el output.

Si hay issues reportados:
1. Explicame qué falló y por qué es un problema.
2. Preguntame si querés que los arregle (correr con `--fix`).
3. Para los que no se pueden auto-fix, delegá al agente correspondiente:
   - Credenciales filtradas → `credentials-manager`
   - Archivos duplicados → `versionador`
   - Seguridad → `security-auditor`
   - Carpeta desordenada → `archivero`
