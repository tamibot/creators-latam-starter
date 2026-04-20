# Template · Research de API antes de integrar

> Para cada API nueva que vamos a integrar, research obligatorio ANTES de tocar código. No se salta nunca.

---

# Research API · <nombre del servicio>

**Fecha:** YYYY-MM-DD
**Investigado por:** <agente o humano>
**Link docs oficiales:** https://...

---

## 01 · Riesgos

- ¿Qué puede salir mal?
- ¿Historial de caídas? (revisar status page: https://status....)
- ¿Hay issues abiertos críticos en GitHub / foros?
- ¿La empresa está en riesgo de quiebra / pivote?

**Fuentes consultadas:**
- [ ] Status page oficial
- [ ] GitHub issues últimos 3 meses
- [ ] Reddit `/r/<servicio>` últimos 6 meses
- [ ] HackerNews threads

---

## 02 · Sugerencias de quienes ya integraron

- ¿Qué dicen en foros de devs?
- ¿Qué librería cliente recomiendan?
- ¿Qué patrones comunes emergen? (retry, batching, caching...)

**Fuentes consultadas:**
- [ ] StackOverflow
- [ ] Dev.to / Medium
- [ ] Discord/Slack comunidades

---

## 03 · Alternativas

- ¿Qué competidores directos hay?
- ¿Por qué elegiríamos éste vs. los otros?

| Opción | Pros | Contras | Precio |
|---|---|---|---|
| <servicio elegido> | | | |
| Alternativa 1 | | | |
| Alternativa 2 | | | |

---

## 04 · Limitaciones

- **Rate limits:** ...
- **Regiones:** (¿funciona desde LatAm?)
- **Tamaño máximo de payload:** ...
- **Features faltantes vs. lo que necesitamos:** ...
- **Sandbox disponible:** sí/no
- **Versionado de API:** estable / beta / cambia seguido

---

## 05 · Precios

| Tier | Qué incluye | Costo | ¿Sirve para nuestro caso? |
|---|---|---|---|
| Free | | | |
| Pro | | | |
| Enterprise | | | |

**Trampas en la letra chica:**
- ¿Cobran overage si pasás el tier?
- ¿Tienen mínimo anual?
- ¿Hay features que son "Enterprise only" sin aviso?

**Proyección mensual para nuestro caso:**
- Volumen estimado: ...
- Tier recomendado: ...
- Costo mes estimado: USD ...

---

## ✅ Recomendación final

- **¿Integramos?** SÍ / NO / SÍ CON CAVEATS
- **Tier recomendado:** ...
- **Alertas para el usuario:**
  - ...
  - ...
- **Siguiente paso:** si aprobamos, invocar a `integraciones` con este documento.

---

## 🔗 Referencias

- Docs oficiales: ...
- Status page: ...
- GitHub: ...
- Pricing: ...
