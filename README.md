# IMOL Light

Graphic score con cámara y cuatro voces de SuperCollider.

## Instalación

### Descargar

```sh
git clone --branch imol-light --single-branch https://github.com/interspecifics/IMOL.git IMOL
cd IMOL/imol_light
```

Conectar la cámara y los altavoces antes de iniciar el programa.

### Ubuntu

Desde una terminal del escritorio de Ubuntu Desktop 22.04, 24.04 o 26.04 LTS,
Intel/AMD de 64 bits:

```sh
bash install_ubuntu.sh
bash start_imol_light.sh
```

Ejecutar sin sudo. El instalador solicita la contraseña cuando la necesita.
En Ubuntu 22.04, configurar la interfaz e iniciar JACK en QjackCtl antes de
abrir IMOL. En Ubuntu 24.04 y 26.04 se utiliza PipeWire.

### macOS

Instalar [Python 3.13](https://www.python.org/downloads/macos/) y
[SuperCollider](https://supercollider.github.io/downloads). Colocar SuperCollider
en `/Applications`. Desde la carpeta `imol_light`:

```sh
python3.13 -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python tools/prepare_audio.py
.venv/bin/python tools/launch.py --check
```

Abrir `start_imol_light.command` o ejecutar:

```sh
.venv/bin/python tools/launch.py --display 0
```

Aceptar el permiso de acceso a la cámara.

## Inicio automático en Ubuntu

Desde la carpeta `imol_light`, ejecutar una vez, sin sudo:

```sh
bash install_autostart_ubuntu.sh
```

IMOL se inicia al entrar al escritorio. Para arrancar al encender el equipo sin
intervención, activar el inicio de sesión automático en Configuración → Usuarios.
Configurar la suspensión y el bloqueo de pantalla según el uso de la instalación.

Para probar el inicio desde una terminal del escritorio, con IMOL cerrado:

```sh
bash install_autostart_ubuntu.sh --run
```

Para seleccionar otra pantalla, reinstalar con `--display 1`. Para desactivar
futuros inicios, ejecutar `bash install_autostart_ubuntu.sh --remove`.

Las actualizaciones y consultas de registros pueden hacerse por SSH. El arranque
con `--run` necesita el entorno de la sesión gráfica del equipo.

## Funcionamiento

El score carga las grabaciones de `assets/archives` y sus metadatos. El audio
seleccionado determina los parciales de la voz espectral. La cámara controla
la evolución de las voces. Esperar a que termine el aprendizaje del fondo.

- **Play/Pause:** inicia o pausa el recorrido del análisis visual. Pausar el
  score no silencia necesariamente las voces.
- **F10:** libera o restaura la prioridad de pantalla para acceder a otras ventanas.
- **Monitor audio:** muestra la recepción OSC, los medidores y los controles de sonido.
- **Solo / Mute:** permite escuchar una voz por separado o silenciarla.
- **Con efectos / SECO:** permite escuchar las voces con o sin sus efectos externos.
- **Salida general:** controla el volumen de la mezcla mediante **Nivel** y
  **dB salida**. Un nivel de cero silencia la salida. Ajustar el volumen final
  de escucha desde la bocina.

Los controles del monitor son temporales. Para guardar el volumen de arranque,
editar `master` y `outputGainDb` en `sound/supercollider/config.scd` y reiniciar IMOL.

Cerrar el score o pulsar **Ctrl+C** en la terminal que lo inició detiene el
programa y el sonido. Cerrar solo el monitor no detiene la sesión.

## Cámara y pantalla

En Ubuntu, consultar las cámaras disponibles con `v4l2-ctl --list-devices`.
Para elegir una cámara y una pantalla al iniciar manualmente:

```sh
bash start_imol_light.sh --camera-auto-disable --camera-index 0 --display 0
```

Cambiar los índices según los dispositivos disponibles. Añadir `--camera-rotate 0`
si no se necesita girar la imagen. Conectar el proyector antes de iniciar la sesión.
Si el escritorio ignora la prioridad de ventana, usar una sesión X11/Xorg cuando
esté disponible.

## Comprobación y registros

Desde la carpeta `imol_light`, en Ubuntu:

```sh
bash start_imol_light.sh --check
tail -n 100 runtime/autostart.log runtime/supercollider.log
```

`--check` revisa dependencias y archivos sin activar cámara ni sonido.
`autostart.log` contiene los mensajes del inicio automático y del score;
`supercollider.log`, los del motor de sonido. Para regenerar los WAV incluidos:

```sh
.venv/bin/python tools/prepare_audio.py
```

Si no hay sonido, revisar **Salida general**, Solo/Mute y la salida seleccionada
en Ubuntu o macOS. Si la cámara no aparece, comprobar su conexión y el dispositivo
seleccionado. Cerrar cualquier sesión anterior de IMOL antes de iniciar otra.

## Actualizar

Desde la carpeta del repositorio:

```sh
git pull --ff-only origin imol-light
```

Cerrar y volver a iniciar IMOL para usar la versión descargada.
