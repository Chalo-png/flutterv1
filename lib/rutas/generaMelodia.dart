import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';

class GeneraMelodiaScreen extends StatefulWidget {
  @override
  _GeneraMelodiaScreenState createState() => _GeneraMelodiaScreenState();
}

var notes = ["C", "D", "E", "F", "G", "A", "B"];
var duration = [1, 2, 4];

class _GeneraMelodiaScreenState extends State<GeneraMelodiaScreen> {
  String selectedDifficulty = "";
  List<Note> generatedNotes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genera Melodia'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecciona dificultad',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DifficultyButton(
              text: 'Fácil',
              color: Colors.green,
              isSelected: selectedDifficulty == 'Fácil',
              onTap: () {
                setState(() {
                  selectedDifficulty = 'Fácil';
                });
              },
            ),
            DifficultyButton(
              text: 'Medio',
              color: Colors.orange,
              isSelected: selectedDifficulty == 'Medio',
              onTap: () {
                setState(() {
                  selectedDifficulty = 'Medio';
                });
              },
            ),
            DifficultyButton(
              text: 'Difícil',
              color: Colors.red,
              isSelected: selectedDifficulty == 'Difícil',
              onTap: () {
                setState(() {
                  selectedDifficulty = 'Difícil';
                });
              },
            ),
            // Boton confirmar
            ElevatedButton(
              onPressed: () {
                List<Note> generatedNotes = convertToMusicObjects();
                Navigator.pushNamed(
                  context,
                  '/vistaPrevia',
                  arguments: generatedNotes,
                );
                print("Confirmar");
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
  List<Map<String, dynamic>> generateNotesData() {
    // Handle confirmation action
    int octaveAmount = 4;
    int octaveDuration = 4;
    var data = <Map<String, dynamic>>[];
    for (var i = 0; i < octaveAmount; i++) {
      int localOctave = octaveDuration;
      while (localOctave!=0){
        final r = Random();
        int localDuration = duration[r.nextInt(duration.length)];
        while(localOctave-localDuration<0){
          localDuration = duration[r.nextInt(duration.length)];
        }
        var localNote = {
          'note': notes[r.nextInt(notes.length)]+"4",
          'duration': localDuration,
        };
        data.add(localNote);
        localOctave-=localDuration;
      }
    }
    return data;
  }

  List<Note> convertToMusicObjects() {
    var data = generateNotesData();
    List<Note> musicObjects = [];
    for (var item in data) {
      String noteName = item['note'];
      int duration = item['duration'];

      // Convert note name to Pitch
      Pitch pitch = convertToPitch(noteName);

      // Convert duration to NoteDuration
      NoteDuration noteDuration = convertToNoteDuration(duration);

      // Create Note object
      Note note = Note(
        pitch: pitch,
        noteDuration: noteDuration,
      );

      musicObjects.add(note);
    }
    return musicObjects;
  }

  Pitch convertToPitch(String noteName) {
    switch (noteName) {
      case 'A4':
        return Pitch.a4;
      case 'B4':
        return Pitch.b4;
      case 'C4':
        return Pitch.c4;
      case 'D4':
        return Pitch.d4;
      case 'E4':
        return Pitch.e4;
      case 'F4':
        return Pitch.f4;
      case 'G4':
        return Pitch.g4;
      default:
        throw Exception('Unknown note name: $noteName');
    }
  }

  NoteDuration convertToNoteDuration(int duration) {
    switch (duration) {
      case 1:
        return NoteDuration.quarter;
      case 2:
        return NoteDuration.half;
      case 4:
        return NoteDuration.whole;
      default:
        throw Exception('Unknown duration: $duration');
    }
  }
}

class DifficultyButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  DifficultyButton({required this.text, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : Colors.grey),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}