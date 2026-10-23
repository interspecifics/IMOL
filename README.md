# IMOL Light

Cámara, graphic score y cuatro voces de SuperCollider: espectral, granular
ambient, multicanal y Reflection ambient. Incluye monitor OSC, medidores de
audio y controles Solo/Mute. Esta rama contiene únicamente la versión Light,
sin control de iluminación, DMX, motores ni niebla.

## Descargar esta versión

```sh
git clone --branch imol-light --single-branch https://github.com/interspecifics/IMOL.git IMOL
cd IMOL/imol_light
```

La descarga incluye el código, las dependencias declaradas, 19 grabaciones MP3
completas con sus metadatos, 19 muestras comprimidas sin pérdida y los parciales
de todas las grabaciones. No requiere Max ni otra copia del proyecto IMOL.
Los programas externos y las dependencias Python se instalan en cada equipo.

## Instalar en macOS

1. Instalar [Python 3.13](https://www.python.org/downloads/macos/) y
   [SuperCollider](https://supercollider.github.io/downloads).
   Colocar SuperCollider en `/Applications`.
2. Desde la carpeta `imol_light`, ejecutar:

```sh
python3.13 -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python tools/prepare_audio.py
.venv/bin/python tools/launch.py --check
```

3. Conectar la cámara, elegir la salida de audio del sistema e iniciar:

```sh
.venv/bin/python tools/launch.py --display 0
```

Aceptar el permiso de cámara. En adelante también se puede abrir
`start_imol_light.command`. El monitor se abre junto al motor sonoro.

## Instalar en Ubuntu

Desde `imol_light`, en Ubuntu Desktop 22.04, 24.04 o 26.04 LTS, Intel/AMD de 64 bits:

```sh
bash install_ubuntu.sh
bash start_imol_light.sh
```

Ejecutar sin sudo: el instalador solicita la contraseña cuando la necesita.
Instala SuperCollider, prepara Python y convierte las muestras incluidas a WAV.
Usa PipeWire en 24.04/26.04 y JACK en 22.04; si JACK no está configurado,
seleccionar la interfaz y arrancarlo en QjackCtl antes de iniciar IMOL.
Consultar la [guía Ubuntu](imol_light/INSTALACION_UBUNTU_ES.txt) para detalles.
La instalación Ubuntu tiene pruebas simuladas; falta validarla en un equipo real.

## Audio incluido

- `assets/archives/`: las grabaciones completas en MP3 y sus metadatos RTF,
  usados por el score. Se conservan los créditos de las grabaciones.
- `assets/samples/`: primeros 60 segundos del primer canal de cada WAV original,
  en FLAC sin pérdida. Es exactamente el segmento que carga el motor con su
  configuración predeterminada.
- `assets/audio/`: WAV generados localmente por `tools/prepare_audio.py`.
  El preparador verifica las muestras y conserva cualquier WAV ya existente.
- `sound/data/partials/`: seis bancos de 83 parciales por grabación.

Los WAV generados, entornos virtuales y registros quedan fuera de Git. El banco
incluido tiene un máximo de 60 segundos por muestra: subir `sampleSeconds` no
añade material. Para usar muestras más largas hay que aportar WAV completos.
El score sí analiza los MP3 completos. No se necesita Git LFS.

## Uso y cierre

El audio cargado en el score selecciona sus parciales. Los estados y la cámara
controlan las capas. **Play** recorre el análisis visual; el sonido puede seguir
activo mientras el score está en pausa. En el monitor, usar **Solo** para
escuchar una voz y **SECO** para comparar sin efectos.

Cerrar el score o pulsar **Ctrl+C** en el terminal detiene la sesión. Para usar
el IDE de SuperCollider, abrir `sound/supercollider/main.scd` y ejecutar el
archivo completo. Detener con `~imolStop.value;`, esperar un segundo y volver
a ejecutar el archivo completo para cargar cambios. No iniciar simultáneamente
el motor desde el IDE y desde el lanzador.

## Solución rápida de problemas

- WAV ausentes: ejecutar `.venv/bin/python tools/prepare_audio.py`.
- Cámara incorrecta: añadir `--camera-auto-disable --camera-index 0`; probar
  otro índice si hace falta. Imagen girada: añadir `--camera-rotate 0`.
- Puerto ocupado: cerrar sesiones que utilicen OSC 9001 o el servidor 57130.
- Sin sonido: revisar la salida del sistema, los medidores y Solo/Mute.
  Consultar `runtime/supercollider.log` si el motor no arranca.

La comprobación `--check` no activa cámara ni sonido. La validación física del
equipo de destino se hace después, con cámara y escucha.

Más detalles: [guía macOS](imol_light/INSTALACION_ES.txt),
[documentación y pruebas](imol_light/README.md).
