import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test2/rutas/generaMelodia.dart';
import 'package:test2/widgets/widget_musicSheet/MusicSheetWidget.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';
import 'package:test2/widgets/widget_musicSheet/src/music_objects/note/note.dart';
import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicSheetDisplayScreenPracticeMode extends StatefulWidget {
  final List<Note> notes;

  MusicSheetDisplayScreenPracticeMode({Key? key, required this.notes})
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

  // Variables logica tiempo real
  final isRecording = ValueNotifier<bool>(false);
  FlutterPianoAudioDetection fpad = FlutterPianoAudioDetection();
  Stream<List<dynamic>>? result;
  List<String> realtimeNotes = [];
  List<String> tempNotes = [];
  String printText = "";
  Timer? _timer;
  bool checkear_nota = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    fpad.prepare();
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
    getResult();
  }

  void stop() {
    fpad.stop();
  }

  void getResult() {
    result = fpad.startAudioRecognition();
    result!.listen((event) {
      List<String> updatedNotes = fpad.getNotes(event);
      Map<String, String> notesDetail = fpad.getKeyNotesAndVelocity(event);

      // Actualiza tempNotes sin setState
      _updateTempNotes(updatedNotes);
      // Aquí decides cuándo llamar a _advanceSheet()
      if (shouldAdvance() && checkear_nota) {
        _advanceSheet();
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
      _timer = Timer(Duration(milliseconds: 750), () {
        print(tempNotes);
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
    return _isNoteCorrect(realtimeNotes, expectedNote);
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
                  child: MusicSheetWidgetAux(notes: widget.notes),
                ),
                Positioned(
                  top: 75, // Ajustar según necesidad
                  left: 139 +
                      (widget.notes[0].buildNote(ClefType.treble).objectWidth / 2) *
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
                        stop();
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
