# Banco portátil

`archives/` conserva las 19 grabaciones completas en MP3 y sus metadatos RTF.
Los créditos y las fuentes de cada grabación se encuentran en esos metadatos.

`samples/` contiene el primer canal y hasta 60 segundos de cada WAV procesado
del proyecto, comprimidos sin pérdida en FLAC PCM16. Se conserva la frecuencia
de muestreo original. El manifiesto incluye tamaño en muestras y SHA-256.

Desde `imol_light`, después de instalar las dependencias:

```sh
.venv/bin/python tools/prepare_audio.py
```

Esto genera `audio/*.wav` para SuperCollider; no cambia los WAV existentes.
Los MP3 completos alimentan el score y conservan la identidad de los parciales.
Los WAV históricos completos no están incluidos: el banco cubre exactamente
el límite de lectura predeterminado del motor, de 60 segundos por grabación.
