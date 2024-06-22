import 'package:flutter/material.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';
import 'package:test2/widgets/widget_practiceMode/practiceMode.dart';

import '../widgets/widget_musicSheet/MusicSheetWidget.dart';
import '../widgets/widget_musicSheet/src/music_objects/note/note.dart';

final List<Note> estrellitaNotas = [
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  // Más notas
];

final List<Note> runRunNotas = [
  const Note(
      pitch: Pitch.e4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.b4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.g4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.b4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.e4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.b4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.g4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
];

final List<Note> testSong = [
  const Note(
      pitch: Pitch.e4,
      noteDuration: NoteDuration.whole,
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.oneHundredsTwentyEighth
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.b4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.g4,
      noteDuration: NoteDuration.whole
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.whole
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.half
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.half
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.b4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.e4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.b4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.g4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.d4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.half
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.sixteenth
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.eighth
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.whole
  ),
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.sixteenth
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.whole
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.whole
  ),
  const Note(
      pitch: Pitch.a4,
      noteDuration: NoteDuration.quarter
  ),
];

final List<Note> memoriesNotas = [
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
];

final List<Note> driveByNotas = [
  const Note(
      pitch: Pitch.c4,
      noteDuration: NoteDuration.quarter
  ),
];

class Cancion {
  final String titulo;
  final String genero;
  final int dificultad;
  final String duracion;
  final List<Note> notas;

  Cancion({
    required this.titulo,
    required this.genero,
    required this.dificultad,
    required this.duracion,
    required this.notas,
  });
}

class CancionesPrecargadas extends StatefulWidget {
  @override
  _CancionesPrecargadasState createState() => _CancionesPrecargadasState();
}

class _CancionesPrecargadasState extends State<CancionesPrecargadas> {
  final List<Cancion> _canciones = [
    Cancion(titulo: 'Estrellita donde estas', genero: 'Infantil', dificultad: 1, duracion: '3 m', notas: estrellitaNotas),
    Cancion(titulo: 'Run run se fue pal norte', genero: 'Folclor', dificultad: 2, duracion: '3 m 23 s', notas: runRunNotas),
    Cancion(titulo: 'Memories', genero: 'Infantil', dificultad: 2, duracion: '3 m 40 s', notas: memoriesNotas),
    Cancion(titulo: 'Drive by', genero: 'Soul', dificultad: 3, duracion: '3 m', notas: driveByNotas),
    Cancion(titulo: 'Test Song', genero: 'Test', dificultad: 5, duracion: '2 m', notas: testSong),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canciones Precargadas'),
      ),
      body: ListView.builder(
        itemCount: _canciones.length,
        itemBuilder: (context, index) {
          final cancion = _canciones[index];
          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(cancion.titulo),
            subtitle: Text('${cancion.genero} • ${cancion.duracion}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Icon(
                  i < cancion.dificultad ? Icons.star : Icons.star_border,
                );
              }),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicSheetDisplayScreenPracticeMode(notes: cancion.notas),
                ),
              );
            },
          );
        },
      ),
    );
  }
}