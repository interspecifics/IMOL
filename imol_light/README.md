# IMOL Light — prototipo v0.1

Versión reducida de IMOL: **cámara + graphic score + sonido**. La luz se controla
externamente. Esta carpeta no ejecuta controlador de luminarias, OLA, DMX, motores
ni niebla. Esta rama contiene únicamente la versión Light.

## Contenido

```text
imol_light/
  score/                       Score V2 adaptado, cámara, análisis visual y de audio
    imol_score.py              Aplicación principal
    light_geometry_analyzer.py Análisis de la imagen, no control de luminarias
    cv_state_analyzer.py       Estados visuales aprendidos
    adaptive_osc_controller.py Frecuencia adaptativa de mensajes
    camera_roles.py            Identificación de la cámara del score
  sound/
    supercollider/             Motor de sonido aproximado
      main.scd                Arranque y recursos de esta sesión
      config.scd              Audio, rutas, puerto y niveles
      synthdefs.scd           Cuatro generadores, efectos y salida
      controller.scd         OSC, presets y cambios de muestras
      monitor.scd            Ventana OSC, niveles L/R y controles de escucha
      reference/             Voz original de Paloma, conservada como referencia
    data/                     Presets exportados y bancos espectrales resumidos
      partials/               Un .scd y un .json de parciales por grabación
    max_reference/            Copias de los patches y JavaScript para comparar
  assets/                     MP3 completos, metadatos y banco FLAC portátil
  tools/                      Lanzador y preparación de datos
  tests/                      Pruebas sin cámara y render sin altavoces
  runtime/                    Modelo aprendido, registros y renders locales
  start_imol_light.command    Lanzador para macOS
  requirements.txt            Dependencias Python sin OLA
```

La versión activa del score se deriva de `IMOL_CV_GRAPHIC_SCORE_QT_V2.py`. Se
eliminaron el cliente del puerto 9000, los mensajes `/pattern` y `/set`, la
planificación de sets y su memoria. Se conservan la cámara, la partitura visual,
el análisis de grabaciones y los mensajes de sonido. El modelo visual y la
identificación de cámara se guardan dentro de `runtime/`, separados del original.

## Arranque

En **Ubuntu Desktop 22.04, 24.04 o 26.04 LTS (Intel/AMD de 64 bits)**, desde
esta carpeta:

```sh
bash install_ubuntu.sh
bash start_imol_light.sh
```

El instalador detecta la versión, prepara los paquetes y `.venv`, instala
OpenCV sin ventanas propias y comprueba dependencias y archivos. Ejecutarlo
**sin sudo**; pedirá la contraseña cuando necesite instalar paquetes del sistema.
`--dry-run` muestra el plan sin cambios. Puede repetirse; conserva los entornos
incompatibles en `.venv.backup-*` y guarda el registro en `runtime/`.

Por defecto usa PipeWire en 24.04/26.04 y JACK en 22.04; conserva una elección
anterior o un JACK activo. `--audio jack` y `--audio pipewire` permiten elegir
la ruta (PipeWire requiere 24.04/26.04). En 22.04, si JACK no está configurado,
queda pendiente seleccionar la interfaz y arrancarlo desde QjackCtl.
El instalador genera los WAV desde el banco incluido. La instalación no activa la cámara ni
produce sonido: la prueba física se hace al arrancar. Estas rutas de instalación
tienen pruebas simuladas, pero aún no se han validado en un equipo Ubuntu real.

Guías de instalación y uso en otra computadora:

- [macOS — instalación en español](INSTALACION_ES.txt).
- [Ubuntu — instalación automática y manual en español](INSTALACION_UBUNTU_ES.txt),
  con configuración de audio mediante PipeWire/JACK y dependencias de Linux.

En macOS, con SuperCollider instalado, abrir `start_imol_light.command`.
Para usar directamente el lanzador Python desde esta carpeta:

```sh
python3 tools/launch.py --check
python3 tools/launch.py
```

`--check` comprueba dependencias y archivos sin activar cámara ni audio. El
arranque normal inicia un servidor de audio propio, espera a que SuperCollider
esté listo y abre el score. Cerrar el score o pulsar **Ctrl-C** en el terminal
cierra los procesos de esta ejecución. El lanzador rechaza un puerto OSC ya
ocupado; cerrar los patches de Max que escuchen en 9001 antes de arrancar ambos.

También se pueden iniciar por separado:

```sh
python3 tools/launch.py --mode score --display 0 --camera-auto-disable --camera-index 0
python3 tools/launch.py --mode sound
```

Las opciones no propias del lanzador se pasan al score. La rotación de cámara
heredada es 180°; usar `--camera-rotate 0` si la nueva cámara está derecha.

Para trabajar en el IDE de SuperCollider, abrir `sound/supercollider/main.scd` y
evaluar el archivo completo. Detener con `~imolStop.value;` y esperar un segundo
antes de reiniciar. El servidor dedicado usa el puerto 57130; el receptor del
score usa 9001. Se usan solamente UGens incluidos en SuperCollider.

El lanzador busca primero `.venv/bin/python` y después el intérprete actual. Para una instalación independiente, Python 3.9 o posterior:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python tools/prepare_audio.py
```

Se puede elegir otro intérprete con `--python /ruta/python` y otro ejecutable de
SuperCollider con `--sclang /ruta/sclang`.

## Grabaciones y portabilidad

La rama incluye las 19 grabaciones MP3 completas con sus metadatos en
`assets/archives`, y un banco FLAC sin pérdida en `assets/samples`.
Después de instalar las dependencias, ejecutar `tools/prepare_audio.py` con
el Python del entorno. Verifica el banco y genera `assets/audio/*.wav`, sin
sobrescribir archivos existentes. La configuración ya apunta a `assets/audio`;
el score abre `assets/archives` automáticamente. No depende del proyecto original.

El banco portátil conserva **el primer canal y los primeros 60 segundos** de
cada WAV original, que es lo que utiliza SuperCollider por defecto. Los MP3
completos permiten el análisis íntegro del score. Para usar WAV más largos,
aportarlos con los mismos nombres en `assets/audio` y ajustar `sampleSeconds`.
Subir ese valor por sí solo no amplía el material incluido.

Los cambios de muestra liberan la voz anterior suavemente: 2,5 s en Granular
y 0,6 s en Multicanal. No se precarga toda la colección. El audio del score
selecciona sus propios parciales; el cursor no sincroniza sus trayectorias,
pues los cambios de banco siguen los estados de cámara.

## Audio del score → parciales

Al terminar de cargar y analizar un audio, el score envía `/score/audio` con
su identificador. SuperCollider abre el archivo correspondiente en
`sound/data/partials/`, comienza en su primer banco y evoluciona solamente entre
los seis bancos de esa grabación. El identificador se obtiene del nombre sin
extensión, en minúsculas: el MP3 del archivo y su WAV procesado seleccionan los
mismos parciales. Mantener nombres distintos para grabaciones distintas,
incluso si están en carpetas diferentes. Los nombres con espacios o caracteres
especiales se convierten en identificadores seguros con un sufijo hash.

La selección se repite cada dos segundos, incluso con Play detenido. Así se
recupera al reiniciar SuperCollider; repetir el identificador no reinicia la
evolución. Durante una nueva carga, al fallar esa carga o si faltan bancos válidos,
la capa espectral queda silenciada. Granular y multicanal conservan sus presets
y selección de muestras por `/system/stateB`.

La colección actual tiene **19 archivos de parciales, 114 bancos de 83 voces**:
17 convertidos desde los análisis existentes (Max coll, SPEAR por parcial y
SPEAR por fotograma), y dos generados desde WAV por faltar su análisis:
`protest-in-tahrir-square-cairo` y `the-value-of-noise`.

Si se carga un audio nuevo sin archivo preparado, el score genera y guarda
automáticamente seis bancos FFT usando el audio que acaba de analizar. Basta
con cargarlo en el score; no hace falta reiniciar SuperCollider. La primera
carga añade el tiempo de análisis y requiere escribir en `sound/data/partials/`.
Los bancos se reutilizan en cargas posteriores. Si se sustituye el contenido
de una grabación conservando su nombre, eliminar sus archivos `.scd` y `.json`
de parciales y volver a cargarla para regenerarlos. En otra máquina, copiar
también los parciales nuevos: el envío OSC transmite la identidad, no los datos.

## Capas de SuperCollider

| Capa | Implementación v0.1 | Diferencias conocidas respecto a Max |
|---|---|---|
| Espectral | 83 osciladores con serie triangular truncada; seis bancos por audio seleccionado; máscara suave aleatoria | Resúmenes de parciales originales o picos FFT cuando falta análisis. No reproduce todavía las trayectorias temporales, la máscara simplex, las tres ramas de efectos ni las ráfagas/barridos exactos. |
| Granular | Textura ambient/minimal con `GrainBuf`, ventana Hann, granos largos y espaciados, lectura lenta, filtro suave y paneo lento; máximo de 16 granos | Reinterpreta los presets de Max. Conserva su selección de muestras; la densidad, duración y lectura usan el nuevo mapeo ambient. |
| Multicanal | Diez lectores de buffer con velocidades y paneos independientes | No incluye el timestretch de `groove~`, la división en tres bandas ni la red Gen exacta. La transposición modifica también la velocidad. |
| Reflection | Versión ambient de `resonantReflection`: excitación suave, cinco resonadores, dos osciladores agudos y reverberación | Zonas pentatónicas, transiciones lentas y deriva interna; respuesta menos literal a la cámara. Usa cinco controles sin RGB. |
| Efectos | Delay estéreo con realimentación, filtro, chorus y cola para Espectral/Multicanal; reverberación difusa al 30% para Granular | El granulador evita los ecos rítmicos de la cadena original. No hay equivalencia tímbrica exacta con Gen/Abl. |

Se exportaron los **14 presets del sampler y los 21 de granulStrig**. Los datos
originales están en `sound/data/max_presets.json`; `sound_data.scd` contiene una
selección de parámetros interpretables por estos motores. `/system/stateB`
interpola parámetros continuos; el archivo se elige discretamente. La entrada
habitual está acotada a estados 1–14, por lo que los presets 15–21 se conservan
como material para futuras variantes.

La conversión divide la duración en seis regiones y conserva los 83 parciales
de mayor amplitud máxima en cada región, con frecuencia media ponderada por
amplitud. Los bancos sin análisis previo usan picos FFT de seis fragmentos de
un segundo distribuidos desde el principio hasta el final; no equivalen a un
seguimiento completo de parciales SPEAR. El exportador trabaja con el WAV
original; la generación automática del score usa su análisis mono a 22050 Hz.
Cada banco normaliza amplitudes y completa con voces silenciosas cuando hay
menos de 83 parciales. `manifest.json` registra la procedencia de la colección
exportada; los archivos individuales registran también los audios añadidos por
el score. Los parciales ya están incluidos y no se regeneran al instalar.
Para sustituirlos deliberadamente por aproximaciones FFT de los MP3 completos:

```sh
.venv/bin/python tools/prepare_sound_data.py --audio-folder assets/archives
```

## Voz Reflection

Integra `IMOL_SC_RESREFLEC_SINTH1.scd`, aportado por Paloma Lopez, como una cuarta
voz en `synthdefs.scd` (`imolReflection`). El original se conserva en
`sound/supercollider/reference/`; sus pruebas manuales y su receptor independiente
no se ejecutan al arrancar IMOL Light. Abrir el lanzador habitual o evaluar
`main.scd` completo: no hace falta ejecutar otro archivo.

El receptor original leía ocho valores —incluido RGB—, pero la voz utilizaba
solamente cinco. El contrato integrado es `/reflection/1` con **cinco números**,
en este orden, todos entre 0 y 1:

| Control | Dato que envía el score | Efecto en la voz |
|---|---|---|
| Posición horizontal | Centro de la región / ancho de imagen | Paneo de resonadores: 0 izquierda, 1 derecha |
| Posición vertical | 1 − centro vertical / alto de imagen | Siete zonas pentatónicas entre unos 110 y 262 Hz, con transición de 4 s: arriba más agudo |
| Brillo | Intensidad media de la región, después de ajustes de imagen, / 255 | Curva cuadrática, filtro de 500 a 5000 Hz y osciladores agudos suaves |
| Tamaño | Raíz cuadrada de la proporción entre área del contorno y área total de imagen | Amplitud de los resonadores; 0 indica ausencia y silencia toda la voz |
| Velocidad | Distancia entre centros normalizados / segundos transcurridos, limitada a 1 | Curva cuadrática: de 0,15 a 3 excitaciones suaves por segundo, con envolventes largas |

Se utiliza la región de mayor área, la misma clasificación que el tracker A.
Es una selección por tamaño, no un seguimiento persistente de identidad: si
otra región pasa a ser la mayor, esta toma el control. La primera detección y
la reaparición tras una pérdida comienzan con velocidad cero. Los mensajes
se repiten a la frecuencia de trackers, por defecto 6 Hz, incluso sin movimiento;
desactivar el envío de trackers también desactiva este envío.

La voz arranca silenciosa. Al desaparecer las detecciones se envía tamaño cero;
si la cámara o el envío OSC se interrumpen, se desvanece tras tres segundos sin
actualizaciones. Los controles se suavizan durante 2–4 s y la presencia durante
2 s. La altura tiene una deriva lenta independiente de la cámara; las resonancias
usan proporciones más consonantes, con reverberación estéreo. Se mantiene un
único sintetizador y se recupera al volver la detección.
Sale al mezclador general, con sus propios filtros y limitador, y se
detiene con la sesión. No depende del audio ni del archivo de parciales.

`reflectionLevel` (por defecto 0,18) y `reflectionTimeout` (3 s) están en
`config.scd`. El nivel también puede cambiarse durante la ejecución desde SC:

```supercollider
NetAddr("127.0.0.1", 9001).sendMsg('/imol/layer', "reflection", 0.12);
```

Enviar nivel 0 silencia esta capa. Los mensajes con formato incorrecto —incluido
el antiguo formato de ocho valores— se ignoran. Los valores finitos fuera de
rango se limitan a 0–1.

## Monitor OSC y audio

El monitor se abre al arrancar SuperCollider. Puede cerrarse sin detener el
sonido y abrirse otra vez con **Monitor audio** en el score. En la misma sesión
del IDE de SC también sirve `~imolMonitor.value;`. Para desactivar la apertura
automática, guardar `monitor: false` en `config.scd` y reiniciar.

- **OSC:** dirección, últimos valores, número de mensajes y tiempo desde la
  última recepción. `OK` indica formato admitido; `INVALIDO`, mensaje rechazado;
  `ignorado`, dirección que estas voces no utilizan. Se muestran hasta 48
  direcciones, sin imprimir cada paquete en la consola. Recepción no equivale
  a señal de audio: los medidores permiten comprobar ambas por separado.
- **Espectral:** audio recibido, archivo de parciales y banco actual. Si el
  nombre no cambia al cargar otro audio, revisar `/score/audio`. `Parciales
  cargados` confirma que el archivo se leyó; el medidor confirma actividad de
  salida, no equivalencia tímbrica con el audio original.
- **Audio:** RMS y pico L/R reales de las cuatro voces después de efectos y
  Solo/Mute, antes del master; la salida general se mide después del master.
  Escala −60 a 0 dBFS. `SIN MEDICION` significa que no llegan datos del servidor,
  no una señal silenciosa. Las cifras junto a las barras muestran el pico.
- **Escucha:** ajustar el nivel numérico, usar Solo para aislar una voz o Mute
  para silenciarla. Mute prevalece sobre Solo. `Quitar Solo / Mute` restaura la
  mezcla sin alterar niveles. Los ajustes son temporales; no reescriben config.

Para investigar el granulador, pulsar **Solo** en Granular y alternar **Con
efectos / SECO**. El estado seco se conserva aunque lleguen nuevos controles
OSC. La versión ambient utiliza llegadas aleatorias con respiración lenta:
el objetivo de densidad va de **0,35 a 1,8 granos/s**, modulado internamente
entre el 35% y el 100% de ese valor; no es un pulso regular ni un conteo real.
Los granos duran **0,45–1,8 s**, con ventana Hann y transiciones de 2–3 s.
La lectura lenta (aproximadamente 0,44–0,93x) y un filtro de 800–3500 Hz suavizan
el material. La reverberación difusa al 30% reemplaza el delay granular.

El tracker E controla la voz cuando está disponible; hasta recibirlo, se usa A
para responder también con una sola detección. X recorre la muestra cargada,
Y cambia velocidad de lectura y filtro, el área aumenta duración/densidad y el
movimiento aumenta densidad/dispersión. B controla la anchura estéreo. Sin
trackers, la escena determina posición y timbre. Se conservan los últimos
valores al desaparecer detecciones, incluido E una vez recibido.
El monitor muestra la muestra real y los objetivos de estos parámetros; los
cambios son graduales y las pausas entre granos son intencionales. Para probarlo,
aislar Granular con **Solo**, alternar **SECO** y comparar una región pequeña
quieta con otra grande en movimiento durante al menos 10–15 segundos.

## OSC y mapeos

| Dirección | Contenido | Resultado |
|---|---|---|
| `/score/audio` | string: identificador de grabación; vacío para silenciar | Carga sus propios bancos de parciales; no altera los samples de las otras capas |
| `/reflection/1` | cinco valores: x, y, brillo, tamaño, velocidad | Control de la voz Reflection desde la región de mayor área |
| `/system/state` | float | Velocidad de evolución espectral; cambia banco al cruzar entero o tras 25 eventos con delta ≥ 0,04 |
| `/system/stateB` | float | Interpolación de escenas y selección de muestras |
| `/track/A` | ocho valores | Delay, feedback y transposición multicanal; control granular hasta recibir E |
| `/track/B` | ocho valores | Anchura y feedback de efectos; anchura granular |
| `/track/C` | ocho valores | Amortiguamiento de los efectos con delay |
| `/track/E` | ocho valores | Posición, densidad, duración y timbre granular ambient; velocidades y paneos multicanal |
| `/imol/master` | float 0–1 | Nivel general |
| `/imol/layer` | string + float 0–0,5 | Nivel de `spectral`, `granular`, `groove` o `reflection` |
| `/imol/stop` | sin argumentos | Detiene esta sesión de sonido |
| `/imol/monitor` | sin argumentos | Abre o trae al frente el monitor |

Los trackers conservan `[índice, x, y, ancho, alto, área, dx, dy]`. A/B/C/E son
la primera, segunda, tercera y quinta detección por tamaño. No se generan D/F.
Se mantienen los últimos valores cuando dejan de llegar detecciones. La tasa
adaptativa puede dejar largos intervalos sin mensajes, sin implicar desconexión.

Los mapeos son aproximados: C usa su coordenada vertical como amortiguamiento
común; A usa área normalizada para una transposición de 0,5–2 y su altura para
feedback. No se conserva el escalado casi nulo del área en el patch original.
Los trackers tienen prioridad sobre los parámetros de escena una vez recibidos.
`/state/N`, `/vel/*` y `/feat/*` siguen disponibles desde el score pero no se usan
en estas primeras capas. El botón Play del score recorre el análisis visual;
no arranca ni detiene el motor sonoro.

## Validación y límites

Probado con el entorno Python 3.9 existente y SuperCollider 3.14.1:

- Seis pruebas del score: contrato de cinco valores de Reflection, velocidad,
  reenvío y pérdida de detecciones; selección de audio y reenvío estando en pausa,
  construcción de interfaz sin cámara, contrato de
  trackers, estados sin reproducción de características y ausencia de transporte
  de iluminación.
- Compilación de ocho SynthDefs e inicialización sin arrancar audio.
- Recepción OSC real por loopback, interpolación y rechazo de mensajes mal formados.
- Conversión de los tres formatos, frecuencia FFT, generación de nuevos archivos
  y cobertura de las 19 grabaciones.
- Selección por OSC de las 19 grabaciones, comandos de síntesis, evolución dentro
  de cada grabación, selección repetida, silencio ante errores y recuperación.
- Render de 25 segundos sin altavoces, con señal finita y no silenciosa en las tres capas.
- Granular ambient: mapeos E/A, modo seco y render de 72 s con pausas, contraste
  de actividad entre dos entradas del score, liberación de muestra y caída de reverberación.
- OSC de Reflection: parámetros, rechazo de mensajes mal formados, límites y volumen.
- Render de 17 segundos de Reflection: paneo izquierdo/derecho, silencio inicial,
  pérdida de OSC, recuperación y desaparición de detección.
- Ventana del monitor, recepción OSC, validación, estado espectral, Solo/Mute y
  modo seco; render de cuatro rutas de audio para medir aislamiento y restauración.

```sh
.venv/bin/python tests/test_score.py
.venv/bin/python tests/test_spectral_data.py
.venv/bin/python tests/test_prepare_audio.py
sclang -D tests/check_supercollider.scd
sclang -D tests/check_osc.scd
sclang -D tests/check_audio_selection.scd
sclang -D tests/check_reflection_osc.scd
sclang -D tests/render_supercollider.scd
.venv/bin/python tests/check_render.py
sclang -D tests/check_granular.scd
.venv/bin/python tests/check_granular_render.py --prepare
sclang -D tests/render_granular.scd
.venv/bin/python tests/check_granular_render.py
sclang -D tests/render_reflection.scd
.venv/bin/python tests/check_reflection_render.py
sclang -D tests/check_monitor.scd
sclang -D tests/render_audio_routing.scd
.venv/bin/python tests/check_audio_routing.py
```

El render se guarda en `runtime/sound_check.wav`. Estas pruebas no certifican
equivalencia sonora con Max ni la configuración de la interfaz de audio. Queda
pendiente la sesión de escucha comparativa, la prueba con la cámara real y la
validación prolongada del arranque completo en el equipo de instalación.

Siguiente iteración: recuperar trayectorias espectrales, ajustar los mapeos por
escucha, reproducir la política de voces/presets y decidir la espacialización
definitiva. La salida de esta versión es estéreo; `outputBus` permite elegir
su primer canal físico, pero no implementa todavía una mezcla cuadrafónica.
