import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FelicidadesFinalWidget extends StatefulWidget {
  final String mensaje;
  final String subMensaje;
  final VoidCallback onContinue;

  const FelicidadesFinalWidget({
    Key? key,
    required this.mensaje,
    required this.subMensaje,
    required this.onContinue,
  }) : super(key: key);

  @override
  FelicidadesFinalWidgetState createState() => FelicidadesFinalWidgetState();
}

class FelicidadesFinalWidgetState extends State<FelicidadesFinalWidget> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();

  @override
  void initState() {
    super.initState();
    reproducirSonidos();
  }

  void reproducirSonidos() async {
    await audioPlayer.play(AssetSource('aplausos.mp3'));
    await audioPlayer2.play(AssetSource('trompeta.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioPlayer2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Felicidades!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              size: 100,
              color: Colors.yellow,
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.subMensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 16.0),
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
