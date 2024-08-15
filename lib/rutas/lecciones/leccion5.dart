import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
/// Screen for Lesson 1.
class Leccion5Screen extends StatelessWidget {
  const Leccion5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lección 1 - Sonido y Silencio'),
      ),
      body:
          const PulsePage(), // Show the theoretical mode at the beginning of the lesson
    );
  }
}
class PulsePage extends StatefulWidget {
  const PulsePage({super.key});

  @override
  _PulsePageState createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache(prefix: 'assets/');
  double _bpm = 60.0; // Velocidad inicial del metrónomo (beats por minuto)
  StreamSubscription? _metronomeSubscription;

  @override
  void initState() {
    super.initState();
    // Precargar los archivos de audio
    _audioCache.loadAll(['latido_lento.mp3', 'latido_rapido.mp3', 'latido_normal.mp3']);
  }

  void _playHeartSound(String speed) async {
    String fileName = speed == 'slow' ? 'latido_lento.mp3' : 'latido_rapido.mp3';
    final filePath = await _audioCache.loadPath(fileName);
    await _audioPlayer.play(AssetSource(filePath));
  }


  void _startMetronome() {
    if (_metronomeSubscription != null) {
      _metronomeSubscription!.cancel();
    }

    Duration interval = Duration(milliseconds: (60000 / _bpm).round());
    _metronomeSubscription = Stream.periodic(interval).listen((_) async {
      final filePath = await _audioCache.loadPath('latido_normal.mp3');
      await _audioPlayer.play(AssetSource(filePath));
    });
  }

  void _stopMetronome() {
    _metronomeSubscription?.cancel();
    _audioPlayer.stop();
  }

  @override
  void dispose() {
    _stopMetronome();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concepto de Pulso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reproducción de sonidos del corazón:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _playHeartSound('slow'),
                  child: Text('Sonido Lento'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _playHeartSound('fast'),
                  child: Text('Sonido Rápido'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Metrónomo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _startMetronome,
                  child: Text('Iniciar Metrónomo'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _stopMetronome,
                  child: Text('Detener Metrónomo'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Slider(
              value: _bpm,
              min: 40,
              max: 200,
              divisions: 16,
              label: '$_bpm BPM',
              onChanged: (value) {
                setState(() {
                  _bpm = value;
                  // Ajustar la velocidad del metrónomo si es necesario
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}