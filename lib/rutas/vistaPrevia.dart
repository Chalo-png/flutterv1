import 'package:flutter/material.dart';
import 'package:test2/widgets/widget_musicSheet/MusicSheetWidget.dart';
import 'package:test2/widgets/widget_musicSheet/simple_sheet_music.dart';

class MusicSheetDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Note> notes = ModalRoute.of(context)!.settings.arguments as List<Note>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Previa'),
      ),
      body: Center(
        child: MusicSheetWidget(notes: notes),
      ),
    );
  }
}