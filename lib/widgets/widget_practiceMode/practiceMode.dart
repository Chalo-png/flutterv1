import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test2/rutas/generaMelodia.dart';
import 'package:test2/widgets/widget_musicSheet/MusicSheetWidget.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';
import 'package:test2/widgets/widget_musicSheet/src/music_objects/note/note.dart';

class MusicSheetDisplayScreenPracticeMode extends StatefulWidget {
  final List<Note> notes;

  MusicSheetDisplayScreenPracticeMode({Key? key, required this.notes}) : super(key: key);

  @override
  _MusicSheetDisplayScreenPracticeModeState createState() =>
      _MusicSheetDisplayScreenPracticeModeState();
}

class _MusicSheetDisplayScreenPracticeModeState
    extends State<MusicSheetDisplayScreenPracticeMode> {
  double _currentOffset = 0.0;
  int _buttonPressCount = 0;
  double adjust = 30.025;

  @override
  void initState() {
    super.initState();

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

  void _advanceSheet() {
    setState(() {

      //SI SE PRESIONA LA NOTA CORRECTA Y DURANTE EL TIEMPO CORRECTO AVANZAR
      //CÓDIGO AQUI
      //
      //
      //
      //
      //---------------------------------------------------------------------

      if (_buttonPressCount < widget.notes.length - 1) {
        _currentOffset -= _calculateTotalWidth(_buttonPressCount);

        widget.notes[_buttonPressCount + 1] = Note(
          pitch: widget.notes[_buttonPressCount + 1].pitch,
          noteDuration: widget.notes[_buttonPressCount + 1].noteDuration,
          color: Colors.blue,
        );

        print(_currentOffset);

        _buttonPressCount++;
      }
    });
  }

  double _calculateTotalWidth(int count) {
    double width = 0.0;
    BuiltNote buildNote = widget.notes[count].buildNote(ClefType.treble);
    BuiltNote buildNoteNext = widget.notes[count + 1].buildNote(ClefType.treble);

    width += (buildNote.objectWidth / 2 + buildNoteNext.objectWidth / 2) * adjust;

    // Imprimir el ancho actual acumulado
    print('Nota: ${widget.notes[count].pitch.name.toString()}');
    print('Ancho actual: ${((buildNote.objectWidth * adjust)).toString()}');

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
                  left: 139 + (widget.notes[0].buildNote(ClefType.treble).objectWidth/2)*adjust, // Ajustar según necesidad
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
            child: ElevatedButton(
              onPressed: _advanceSheet,
              child: Text('Avanzar partitura'),
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

//final List<Note> notes = ModalRoute.of(context)!.settings.arguments as List<Note>;
//for (Note nota in notas) {
//BuiltNote buildNote = nota.buildNote(ClefType.treble);
//print("WIDTH -1 -------->>>>>: ${nota.noteDuration.time.toString()}");
//print("WIDTH 0 -------->>>>>: ${nota.pitch.position.toString()}");
//print("WIDTH 1 -------->>>>>: ${buildNote.noteHead.noteHeadCenterX.toString()}");
//print("WIDTH 2 -------->>>>>: ${buildNote.noteHead.accidentalWidth.toString()}");
//print("WIDTH 3 -------->>>>>: ${buildNote.accidentalSpacing.toString()}");
//print("LowerHeight 4 -------->>>>>: ${buildNote.lowerHeight.toString()}");
//print("ObjectWidth -------->>>>>: ${buildNote.objectWidth.toString()}");
//print("box -------->>>>>: ${buildNote.bboxWithNoMargin.toString()}");
//}