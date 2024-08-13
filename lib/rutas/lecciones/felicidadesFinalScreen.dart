import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatbotEmocionesFinalScreen.dart';

class FelicidadesFinalScreen extends StatefulWidget {
  const FelicidadesFinalScreen({super.key});
  @override
  FelicidadesFinalScreenState createState() => FelicidadesFinalScreenState();
}

class FelicidadesFinalScreenState extends State<FelicidadesFinalScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();

  void reproducirSonido(String assetPath) async {
    if (audioPlayer.state != PlayerState.playing) {
      await audioPlayer.play(AssetSource(assetPath));
    } else {
      await audioPlayer2.play(AssetSource(assetPath));
    }
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.play(AssetSource('aplausos.mp3'));
    audioPlayer2.play(AssetSource('trompeta.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Liberar recursos del AudioPlayer
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
            const Text(
              'Felicidades, terminaste la lección 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '¡Te has ganado una estrellita!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const ChatbotEmocionesFinalScreen()),
                );
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}