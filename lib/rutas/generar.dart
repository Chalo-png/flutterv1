import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test2/widgets/widget_musicSheet/MusicSheetWidget.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';
import 'package:test2/widgets/widget_practiceMode/practiceMode.dart';

//Todas las notas del Piano
var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
//Solo en el PMV se considera la escala C
var scales = [[0, 2, 4, 5, 7, 9, 11]];
//Solo en PMV se consideran acordes mayores y menores
var chords = [[0, 4, 7], [0, 3, 7]];
//Solo en PMC se considera negra, blanca y redonda
var duration = [1, 2, 4];
var durationProb = [[0.1, 0.3, 0.6], [0.3, 0.4, 0.3], [0.7, 0.2, 0.1]];
var chordDurarion = [2, 4];
//Progresión de acordes clasica
var chordProggresion = [[0, 3, 4, 4], [0, 0, 3, 4], [0, 3, 0, 4], [0, 3, 4, 3]];


class GeneratorDisplayScreen extends StatefulWidget {
  @override
  _DifficultyPageState createState() => _DifficultyPageState();
}
class _DifficultyPageState extends State<GeneratorDisplayScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  var _notesToPlay = [];
  int _currentIndex = 0;
  bool _isPlaying = false;

  String selectedDifficulty = "Fácil";
  List<Note> generatedNotes = [];
  bool clicked = false;
  var _data = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar melodia"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                ElevatedButton(
                  onPressed: () {
                    generatedNotes = convertToMusicObjects();
                    setState(() {
                      clicked = true;
                      resetCreation();
                    });
                  },
                  child: Text('Confirmar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: resetCreation(),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: clicked? Colors.green: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            onPressed: () {
              if(generatedNotes.length!=0){
                _isPlaying = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicSheetDisplayScreenPracticeMode(notes: generatedNotes),
                  ),
                );
              }
            },
            child: Text('¡Practicar!'),
          ),
        ],
      )
    );
  }
  Future<void> playNotes(var notes) async {
    if(notes!=_notesToPlay){
      _notesToPlay = notes;
      // Detener la reproducción actual si está en curso
      await stop();
      await Future.delayed(Duration(milliseconds: 500));
      if(notes==_notesToPlay){
        _currentIndex = 0;
        _isPlaying = true;
        await _playNextNote();
      }
    }
  }
  Future<void> _playNextNote() async {
    print(_notesToPlay);
    for (var currentNote in _notesToPlay) {
      if(_isPlaying){
        String soundPath = '${currentNote['note']}.mp3'; // Ruta al archivo de sonido

        await _audioPlayer.play(AssetSource(soundPath)); // Reproducir el sonido

        await Future.delayed(Duration(seconds: currentNote['duration'])); // Esperar la duración de la nota
        if(_audioPlayer!=null){
          await _audioPlayer.release();
        }
      }else{
        break;
      }
    }
    _isPlaying = false;
    /*
    while(_isPlaying && _currentIndex < _notesToPlay.length) {
      var currentNote = _notesToPlay[_currentIndex];

      String soundPath = '${currentNote['note']}.mp3'; // Ruta al archivo de sonido

      await _audioPlayer.play(AssetSource(soundPath)); // Reproducir el sonido

      await Future.delayed(Duration(seconds: currentNote['duration'])); // Esperar la duración de la nota
      
      if(_audioPlayer!=null){
        await _audioPlayer.release();
      }
      
      _currentIndex++;
    }
    _isPlaying = false;
    */
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentIndex = 0;
  }
  Widget resetCreation(){
    _audioPlayer.setReleaseMode(ReleaseMode.release);
    var creation =  generatedNotes.isEmpty ? const Text("Selecciona una dificultad para crear una canción!") : MusicSheetWidget(notes: generatedNotes,);
    playNotes(_data);
    return creation;
  }
  @override
  void dispose(){
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
  List<Map<String, dynamic>> generateNotesData() {
    int compassAmount = 4; //Numero de compases de la partitura a generar
    int compassDuration = 4; //Numero de tiempos dentro de cada compas
    var data = <Map<String, dynamic>>[]; //Datos a devolver
    final rand = Random(); //Random
    var selectedScale = scales[rand.nextInt(scales.length)]; //Escala elegida al azar
    var selectedNotes = selectedScale.map((idx)=> notes[idx]).toList(); //Notas que corresponden a esa escala
    var selectedProgression = chordProggresion[rand.nextInt(chordProggresion.length)]; //Progresion elegida al azar
    int diff = selectedDifficulty == 'Fácil' ? 0 : selectedDifficulty=='Medio' ? 1 : 2; //Dificultad en valor entero
    for (var i = 0; i < compassAmount; i++) {
      int localCompass = compassDuration; //Contador de tiempos del compas local
      int localProgression = selectedProgression[i % selectedProgression.length]; //Nota base del compas local (Nota Corazón)
      while (localCompass!=0){ 
        final r = Random(); //Random
        String note; //Nota (o notas) local
        int localDuration = 5; //Duración de la nota actual
        bool isChord = false; //Transformar nota actual en acorde?
        //(r.nextInt(10) < diff*2)&&(localCompass>1); 
        do {
          if(isChord){
            localDuration = chordDurarion[r.nextInt(chordDurarion.length)];
          }else{
            var localProb = durationProb[diff];
            var randDouble = r.nextDouble();
            double counter = 0.0;
            for (var j = 0; j < localProb.length; j++) {
              counter += localProb[j];
              if(counter>=randDouble){    
                localDuration = duration[j];
                break;
              }
            }
          }
        } while (localCompass-localDuration<0);
        note = selectedNotes[localProgression + r.nextInt(3)]+"4";
        /*
        if(!isChord){
          note = selectedNotes[localProgression + r.nextInt(3)]+"4";
        }else{

        }*/
        var localNote = {
          'note': note,
          'duration': localDuration,
        };
        data.add(localNote);
        localCompass-=localDuration;
      }
    }
    _data = data;
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
      case 'C5':
        return Pitch.c5;
      case 'D5':
        return Pitch.d5;
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