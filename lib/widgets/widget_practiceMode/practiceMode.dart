import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test2/models/user.dart';
import 'package:test2/widgets/widget_musicSheet/MusicSheetWidget.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';
import 'package:test2/widgets/widget_musicSheet/src/music_objects/note/note.dart';
import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';

import "package:test2/chatbot/emociones.dart";

import '../../models/practicaM.dart';

class MusicSheetDisplayScreenPracticeMode extends StatefulWidget {
  final List<Note> notes;
  final int? songId;

  MusicSheetDisplayScreenPracticeMode(
      {Key? key, required this.notes, this.songId})
      : super(key: key);

  @override
  _MusicSheetDisplayScreenPracticeModeState createState() =>
      _MusicSheetDisplayScreenPracticeModeState();
}

class _MusicSheetDisplayScreenPracticeModeState
    extends State<MusicSheetDisplayScreenPracticeMode> {
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
  static const int TIMER_RAPIDO = 500;
  static const int TIMER_NORMAL = 2000;
  static const int TIMER_LENTO = 5000;
  // Variable para la duración actual del timer
  int currentTimerDuration = TIMER_NORMAL;
  Stopwatch _stopwatch = Stopwatch();
  bool checkear_nota = true;
  int fallas = 0;
  double aciertosSave = 0.0;
  String sentimiento = "default";
  List<Note> displayNotes = [];
  bool initialWait = false;

  @override
  void initState() {
    super.initState();
    
    fpad.prepare();
    tempNotes.clear();
    addNotesToSheet(Duration(milliseconds: 300));

    isRecording.value = true;
    start();

    Timer(Duration(milliseconds: 3000), () {
      if (mounted) {
        print("Inicio partitura");
        tempNotes.clear();
        initialWait = true;
      }
    });
  }

  void addNotesToSheet(Duration delayBetweenNotes) {
    displayNotes.clear();

    for (int i = 0; i < widget.notes.length; i++) {
      Timer(delayBetweenNotes * i, () {
        setState(() {
          displayNotes.add(Note(
            pitch: widget.notes[i].pitch,
            noteDuration: widget.notes[i].noteDuration,
            color: widget.notes[i].color,
          ));
        });
      });
    }
  }

  

  void start() {
    tempNotes.clear();
    fpad.start();
    _stopwatch.start();
    getResult();
  }

  void stop(bool showDialog) async {
    if (fpad != null) {
      fpad.stop();
    }
    _stopwatch.stop();
    if (showDialog) {
      if (songId != null) {
        await showDialogWithEmocionesCard().then((selectedSentimiento) {
          if (selectedSentimiento != null) {
            updateSentimiento(selectedSentimiento);
          }
        });
        await handleSave(); // Espera a que handleSave() termine
      }
      showEndDialog();
    }
  }

  Future<String?> showDialogWithEmocionesCard() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: EmocionesCard(
            TipoActividad: "practice",
            onSentimientoSelected: (sentimiento) {
              Navigator.of(context).pop(sentimiento);
            },
          ),
        );
      },
    );
  }

  void updateSentimiento(String newSentimiento) {
    setState(() {
      sentimiento = newSentimiento;
    });
  }

  void getResult() {
    result = fpad.startAudioRecognition();
    result!.listen((event) {
      List<String> updatedNotes = fpad.getNotes(event);

      // Actualiza tempNotes sin setState
      _updateTempNotes(updatedNotes);

      if(initialWait){
        if (checkear_nota && tempNotes.isNotEmpty) {
          print(tempNotes);
          if (shouldAdvance()) {
            _advanceSheet();
          } else {
            checkear_nota = false;
            tempNotes.clear();
            changeNoteColorToRed(_buttonPressCount);
            fallas++;
          }
        }
      }
      
    });
  }
  // Método para cambiar la velocidad del timer
  void _changeSpeed(String speed) {
    setState(() {
      switch (speed) {
        case 'Rápido':
          currentTimerDuration = TIMER_RAPIDO;
          break;
        case 'Normal':
          currentTimerDuration = TIMER_NORMAL;
          break;
        case 'Lento':
          currentTimerDuration = TIMER_LENTO;
          break;
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
      _timer = Timer(Duration(milliseconds: currentTimerDuration), () {
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
      if (_buttonPressCount < widget.notes.length) {
        if (_buttonPressCount < widget.notes.length - 1)
          _currentOffset -= _calculateTotalWidth(_buttonPressCount);

        if (_buttonPressCount == widget.notes.length - 1) {
          if (isRecording.value == true) {
            tempNotes.clear();
            isRecording.value = false;
            stop(true);
          }
        }

        // Actualiza la nota siguiente en la partitura
        displayNotes[_buttonPressCount] = Note(
          pitch: widget.notes[_buttonPressCount].pitch,
          noteDuration: widget.notes[_buttonPressCount].noteDuration,
          color: Colors.blue,
        );

        _buttonPressCount++;
        checkear_nota = false;
      } else {
        // Si se toca la última nota, detener la grabación
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
    BuiltNote buildNoteNext =
        widget.notes[count + 1].buildNote(ClefType.treble);

    width +=
        (buildNote.objectWidth / 2 + buildNoteNext.objectWidth / 2) * adjust;

    return width;
  }

  List<PracticaM> setupPracticaForSave(
      int songId, int cantAciertos, double tasaAciertos, int elapsedTime) {
    PracticaM practica = PracticaM(
      songId: songId,
      cantAciertos: cantAciertos,
      tasaAciertos: tasaAciertos,
      songSpeed: 1.0,
      sentimiento: sentimiento,
      secondsToComplete: elapsedTime,
    );
    List<PracticaM> practicaList = [];
    practicaList.add(practica);
    return practicaList;
  }

  User setupUserForSave(List<PracticaM> practica, int userId, String email,
      String password, String userType, int edad) {
    User user = User(
      id: userId,
      email: email,
      password: password,
      userType: userType,
      practicas: practica,
      edad: edad, // Optional practica object
    );

    return user;
  }

  double getTasaAciertos() {
    //aciertos/total
    double res = widget.notes.length / (widget.notes.length + fallas);
    aciertosSave = res;
    return res;
  }

  Future<void> handleSave() async {
    if (songId != null) {
      int cantNotas = widget.notes.length;
      double tasaAciertos = getTasaAciertos();
      int elapsedTime = _stopwatch.elapsed.inSeconds;

      List<PracticaM> currPracticaAsList =
          setupPracticaForSave(songId!, cantNotas, tasaAciertos, elapsedTime);
      String email = "user@example.com";
      String password = "securePassword";
      String userType = "Alumno";
      int edad = 5;
      User currUser = setupUserForSave(
          currPracticaAsList, 2, email, password, userType, edad);

      storeUser(currUser);
    }
  }

  void showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Canción completada'),
          content: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: songId != null
                  ? <Widget>[
                      Text(
                          "Tasa de aciertos ${aciertosSave} + Cantidad de notas ${widget.notes.length} + intentos ${fallas}"),
                      Text(
                          '¿Quieres repetir la canción o volver al menú principal?')
                    ]
                  : <Widget>[
                      Text(
                          '¿Quieres repetir la canción o volver al menú principal?')
                    ],
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
      addNotesToSheet(Duration(seconds: 0));
    });
  }

  void goToMainMenu() {
    tempNotes.clear();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void changeNoteColorToRed(int index) {
  setState(() {
    displayNotes[index] = Note(
      pitch: widget.notes[index].pitch,
      noteDuration: widget.notes[index].noteDuration,
      color: Colors.red,
    );
  });

  // Retrasar la restauración del color a negro si no es azul
  if (displayNotes[index].color != Colors.blue) {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (displayNotes[index].color != Colors.blue) {
          displayNotes[index] = Note(
            pitch: widget.notes[index].pitch,
            noteDuration: widget.notes[index].noteDuration,
            color: Colors.black,
          );
        }
      });
    });
  }
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Modo práctica'),
    ),
    body: Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              Positioned(
                left: _currentOffset,
                child: MusicSheetWidgetAux(notes: displayNotes),
              ),
              Positioned(
                top: 75,
                left: 139 + (widget.notes[0].buildNote(ClefType.treble).objectWidth / 2) * adjust,
                child: Container(
                  width: 4,
                  height: 120,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: currentTimerDuration == TIMER_RAPIDO
                ? 'Rápido'
                : currentTimerDuration == TIMER_NORMAL
                    ? 'Normal'
                    : 'Lento',
            items: <String>['Rápido', 'Normal', 'Lento']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _changeSpeed(newValue);
              }
            },
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: _advanceSheet,
            child: Icon(Icons.arrow_forward),
          ),
        ),
      ],
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
