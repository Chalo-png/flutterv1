# test2

1. Deben descargar `onsets_frames_wavinput.tflite` desde [este enlace](https://github.com/WonyJeong/flutter_piano_audio_detection).
2. Crear carpeta `assets` donde se indica en el repo del punto 1.
3. Cambiar la ruta `"C:\Users\Carlos\StudioProjects\test2\android\app\src\main\assets\onsets_frames_wavinput.tflite"` en `pubspec.yaml` a la de su computador.

# Configuración de Firebase

Para configurar Firebase, sigue estos pasos:[Guia oficial Prefiera NPM por su sanidad](https://firebase.google.com/docs/cli?hl=es-419)

1. Instalar Node.js + NPM y **AGREGAR AL PATH**.
    - [Guía de instalación](https://aryanvij02.medium.com/add-firebase-to-flutter-on-windows-f83546e13b10) (no continuar con el step 2).

2. Ejecutar el siguiente comando para instalar Firebase CLI:
    ```bash
    npm install -g firebase-tools
    ```
    - Se recomienda instalarlo con npm, no con el archivo exe.

3. Iniciar sesión en Firebase:
    ```bash
    firebase login
    ```
    - Usa la cuenta asociada al proyecto.

4. Verificar la lista de proyectos en Firebase:
    ```bash
    firebase projects:list
    ```
    - Debería aparecer `piano-colors`.

5. Configurar Firebase en el proyecto Flutter:
    - [Guía de configuración](https://firebase.google.com/docs/flutter/setup?hl=es&platform=ios).
    - Asegúrate de que el nombre del paquete sea igual al de `android/app/build.gradle` en el campo `applicationId` durante el paso de `flutterfire configure`, o arrojará un error.

6. Los pasos 3.3 y 3.4 ya están incluidos en el repositorio.
