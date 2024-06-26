import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test2/models/user.dart';
import 'package:test2/widgets/widget_musicSheet/MusicSheetWidget.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';
import 'package:test2/widgets/widget_musicSheet/src/music_objects/note/note.dart';
import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/practicaM.dart';

class MusicSheetDisplayScreenPracticeMode extends StatefulWidget {
  final List<Note> notes;
  final int? songId;

  MusicSheetDisplayScreenPracticeMode({Key? key, required this.notes, this.songId})
      : super(key: key);

  @override
  _MusicSheetDisplayScreenPracticeModeState createState() =>
      _MusicSheetDisplayScreenPracticeModeState();
}

class _MusicSheetDisplayScreenPracticeModeState extends State<MusicSheetDisplayScreenPracticeMode> {
  double _currentOffset = 0.0;
  int _buttonPressCount = 0;
  double adjust = 30.025;

  // Initialize songId directly from widget
  int? get songId => widget.songId;

  // Variables logica tiempo real
  final isRecording = ValueNotifier<bool>(false);
  FlutterPianoAudioDetection fpad = FlutterPianoAudioDetection();
  Stream<List<dynamic>>? result;
  List<String> realtimeNotes = [];
  List<String> tempNotes = [];
  String printText = "";
  Timer? _timer;
  Stopwatch _stopwatch = Stopwatch();
  bool checkear_nota = true;
  int fallas = 0;
  double aciertosSave = 0.0;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    fpad.prepare();
    tempNotes.clear();
    for (int i = 0; i < widget.notes.length; i++) {
      if (i == 0) {
        widget.notes[i] = Note(
          pitch: widget.notes[i].pitch,
          noteDuration: widget.notes[i].noteDuration,
          color: Colors.blue,
        );
      } else {
        widget.notes[i] = Note(
          pitch: widget.notes[i].pitch,
          noteDuration: widget.notes[i].noteDuration,
          color: Colors.black,
        );
      }
    }

    // Activar automáticamente el botón después de 1 segundo
    Timer(Duration(seconds: 1), () {
      if (mounted) {
        isRecording.value = true;
        start();
      }
    });
  }

  Future<void> _checkPermission() async {
    if (!(await Permission.microphone.isGranted)) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        // Permiso denegado, puedes mostrar un mensaje o tomar otra acción
      }
    }
  }

  void start() {
    fpad.start();
    _stopwatch.start();
    getResult();
  }

  void stop(bool showDialog) {
    fpad.stop();
    _stopwatch.stop();
    if(showDialog){
      if(songId!=null){
        handleSave();
      }
      showEndDialog();
    }
  }

  void getResult() {
    result = fpad.startAudioRecognition();
    result!.listen((event) {
      List<String> updatedNotes = fpad.getNotes(event);

      // Actualiza tempNotes sin setState
      _updateTempNotes(updatedNotes);

      if (checkear_nota && tempNotes.isNotEmpty) {
        print(tempNotes);
        if (shouldAdvance()) {
          _advanceSheet();
        } else {
          tempNotes.clear();
          fallas++;
        }
      }
    });
  }

  void _updateTempNotes(List<String> updatedNotes) {
    // Añadir solo las notas que no estén ya en tempNotes
    for (var note in updatedNotes) {
      if (!tempNotes.contains(note)) {
        tempNotes.add(note);
      }
    }

    if (_timer == null || !_timer!.isActive) {
      _timer = Timer(Duration(milliseconds: 2000), () {
        checkear_nota = true;
        realtimeNotes = List.from(tempNotes);
        tempNotes.clear();
      });
    }
  }

  bool shouldAdvance() {
    // Implementa tu lógica para decidir cuándo avanzar en la partitura
    // Por ejemplo, puedes comparar realtimeNotes con las notas esperadas.
    // Devuelve true si se cumplen las condiciones para avanzar.
    Note expectedNote = widget.notes[_buttonPressCount];
    return _isNoteCorrect(tempNotes, expectedNote);
  }

  void _advanceSheet() {
    setState(() {
      if (_buttonPressCount < widget.notes.length - 1) {
        _currentOffset -= _calculateTotalWidth(_buttonPressCount);

        // Actualiza la nota siguiente en la partitura
        widget.notes[_buttonPressCount + 1] = Note(
          pitch: widget.notes[_buttonPressCount + 1].pitch,
          noteDuration: widget.notes[_buttonPressCount + 1].noteDuration,
          color: Colors.blue,
        );

        _buttonPressCount++;
        checkear_nota = false;
      }
      // Si se toca la última nota, detener la grabación
      else {
        if(isRecording.value==true){
          tempNotes.clear();
          isRecording.value = false;
          stop(true);
        }
      }
    });
  }

  bool _isNoteCorrect(List<String> currentNote, Note expectedNote) {
    String expectedPitch = pitchExtension(expectedNote.pitch);
    // Comprueba que la altura y duración de la nota son correctas
    return currentNote.contains(expectedPitch);
  }

  String pitchExtension(Pitch pitch) {
    String name = pitch.toString().split('.').last;
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }

  double _calculateTotalWidth(int count) {
    double width = 0.0;
    BuiltNote buildNote = widget.notes[count].buildNote(ClefType.treble);
    BuiltNote buildNoteNext = widget.notes[count + 1].buildNote(ClefType.treble);

    width += (buildNote.objectWidth / 2 + buildNoteNext.objectWidth / 2) * adjust;

    return width;
  }

  List<PracticaM> setupPracticaForSave(int songId, int cantAciertos, double tasaAciertos, int elapsedTime) {
    PracticaM practica = PracticaM(
      songId: songId,
      cantAciertos: cantAciertos,
      tasaAciertos: tasaAciertos,
      songSpeed: 1.0,
      sentimiento: "happy",
      secondsToComplete: elapsedTime,
    );
    List<PracticaM> practicaList = [];
    practicaList.add(practica);
    return practicaList;
  }

  User setupUserForSave(List<PracticaM> practica, int userId, String email, String password, String userType) {
    User user = User(
      id: userId,
      email: email,
      password: password,
      userType: userType,
      practicas: practica, // Optional practica object
    );

    return user;
  }

  double getTasaAciertos() {
    //aciertos/total
    double res = widget.notes.length / (widget.notes.length + fallas);
    aciertosSave = res;
    return res;
  }

  void handleSave() {
    if (songId != null) {
      int cantNotas = widget.notes.length;
      double tasaAciertos = getTasaAciertos();
      int elapsedTime = _stopwatch.elapsed.inSeconds;
      List<PracticaM> currPracticaAsList = setupPracticaForSave(songId!, cantNotas, tasaAciertos, elapsedTime);
      String email = "user@example.com";
      String password = "securePassword";
      String userType = "Alumno";
      User currUser = setupUserForSave(currPracticaAsList, 1, email, password, userType);

      storeUser(currUser);
    }
  }

  void showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Canción completada'),
          content:
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: songId!=null ? <Widget>[Text("Tasa de aciertos ${aciertosSave} + Cantidad de notas ${widget.notes.length} + intentos ${fallas}"), Text('¿Quieres repetir la canción o volver al menú principal?')]:<Widget>[Text('¿Quieres repetir la canción o volver al menú principal?')], 
            ),
            ),
          actions: <Widget>[
            TextButton(
              child: Text('Repetir'),
              onPressed: () {
                Navigator.of(context).pop();
                // Logic to repeat the song
                repeatSong();
              },
            ),
            TextButton(
              child: Text('Volver'),
              onPressed: () {
                Navigator.of(context).pop();
                // Logic to go back to the main menu
                goToMainMenu();
              },
            ),
          ],
        );
      },
    );
  }

  void repeatSong() {
    setState(() {
      tempNotes.clear();
      _buttonPressCount = 0;
      _currentOffset = 0.0;
      for (int i = 0; i < widget.notes.length; i++) {
        if (i == 0) {
          widget.notes[i] = Note(
            pitch: widget.notes[i].pitch,
            noteDuration: widget.notes[i].noteDuration,
            color: Colors.blue,
          );
        } else {
          widget.notes[i] = Note(
            pitch: widget.notes[i].pitch,
            noteDuration: widget.notes[i].noteDuration,
            color: Colors.black,
          );
        }
      }
      isRecording.value = true;
      start();
    });
  }

  void goToMainMenu() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mostrar un diálogo o realizar alguna acción personalizada
        bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('¿Qué deseas hacer?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    stop(false);
                    Navigator.pushNamed(context, '/cancionesPrecargadas'); // Volver a canciones
                  },
                  child: Text('Volver a Canciones'),
                ),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Logic to repeat the song
                    repeatSong();
                  },
                  child: Text('Repetir Canción'),
                ),
              ],
            ),
          ),
        );

        // Si shouldPop es null, significa que se cerró el diálogo sin elegir ninguna opción
        // Devuelve false para evitar que Flutter maneje el pop
        return shouldPop != null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modo práctica'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  // Ajusta según tu implementación de MusicSheetWidgetAux
                  Positioned(
                    left: _currentOffset,
                    child: MusicSheetWidgetAux(notes: widget.notes),
                  ),
                  Positioned(
                    top: 75, // Ajustar según necesidad
                    left: 139 +
                        (widget.notes[0]
                                .buildNote(ClefType.treble)
                                .objectWidth /
                            2) *
                            adjust, // Ajustar según necesidad
                    child: Container(
                      width: 4, // Ancho de la línea vertical
                      height: 120, // Altura de la línea vertical
                      color: Colors.blueGrey, // Color de la línea vertical
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ValueListenableBuilder(
                  valueListenable: isRecording,
                  builder: (context, value, widget) {
                    if (value == false) {
                      return FloatingActionButton(
                        onPressed: () {
                          isRecording.value = true;
                          start();
                        },
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.mic),
                      );
                    } else {
                      return FloatingActionButton(
                        onPressed: () {
                          isRecording.value = false;
                          stop(false);
                        },
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.adjust),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MusicSheetWidgetAux extends StatelessWidget {
  final List<Note> notes;

  MusicSheetWidgetAux({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      width: MediaQuery.of(context).size.width,
      height: 200,
      color: Colors.grey[200],
      child: Center(
        child: MusicSheetWidget(notes: notes),
      ),
    );
  }
}
