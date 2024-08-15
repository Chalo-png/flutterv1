import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FelicidadesWidget extends StatefulWidget {
  final String mensaje;
  final VoidCallback onContinue; // Callback para manejar la acción del botón

  const FelicidadesWidget({
    Key? key,
    required this.mensaje,
    required this.onContinue,
  }) : super(key: key);

  @override
  FelicidadesWidgetState createState() => FelicidadesWidgetState();
}

class FelicidadesWidgetState extends State<FelicidadesWidget> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    reproducirSonido();
  }

  /// Método para reproducir el sonido.
  void reproducirSonido() async {
    await audioPlayer.play(AssetSource('acertar.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Felicitaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.mensaje,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: widget.onContinue,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
