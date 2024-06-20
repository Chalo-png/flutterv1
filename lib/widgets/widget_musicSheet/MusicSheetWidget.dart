import 'package:flutter/material.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';

class MusicSheetWidget extends StatefulWidget {
  const MusicSheetWidget({Key? key}) : super(key: key);

  @override
  _MusicSheetWidgetState createState() => _MusicSheetWidgetState();
}

class _MusicSheetWidgetState extends State<MusicSheetWidget> {
  late List<MusicObjectStyle> musicObjects;
  late Measure measure;
  late Staff staff;
  late Clef initialClef;

  @override
  void initState() {
    super.initState();
    // Inicializar los objetos de música
    initializeMusicObjects();
  }

  void initializeMusicObjects() {
    initialClef = const Clef(ClefType.treble);
    musicObjects = [
      initialClef,
      const Note(
        pitch: Pitch.g4,
        noteDuration: NoteDuration.eighth,
        color: Colors.blue,
      ),
      const Note(
        pitch: Pitch.f4,
        noteDuration: NoteDuration.quarter,
      ),
      const Note(
        pitch: Pitch.f4,
        noteDuration: NoteDuration.half,
      ),
      const Note(
        pitch: Pitch.g4,
        noteDuration: NoteDuration.half,
      ),
      const Note(
        pitch: Pitch.f4,
        noteDuration: NoteDuration.half,
      ),
      const Note(
        pitch: Pitch.g4,
        noteDuration: NoteDuration.half,
      ),
    ];
    measure = Measure(musicObjects);
    staff = Staff([measure]);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height / 2;
    final width = screenSize.width;

    return SimpleSheetMusic(
      initialClef: initialClef,
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      staffs: [staff],
    );
  }
}