import 'package:flutter/material.dart';
import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class PracticaScreen extends StatefulWidget {
  const PracticaScreen({super.key}); // Using super parameters

  @override
  PracticaScreenState createState() => PracticaScreenState(); // Made public by removing underscore
}

class PracticaScreenState extends State<PracticaScreen> {
  final isRecording = ValueNotifier<bool>(false);
  FlutterPianoAudioDetection fpad = FlutterPianoAudioDetection();
  String _microphonePermissionStatus = 'Unknown';
  Stream<List<dynamic>>? result;
  List<String> notes = [];
  String printText = "";

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
    fpad.prepare();
  }

  Future<void> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      await _requestMicrophonePermission();
    } else {
      setState(() {
        _microphonePermissionStatus = 'Microphone permission is granted';
      });
    }
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        _microphonePermissionStatus = 'Microphone permission is granted';
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _microphonePermissionStatus = 'Microphone permission is permanently denied';
      });
      openAppSettings();
    } else {
      setState(() {
        _microphonePermissionStatus = 'Microphone permission is denied';
      });
    }
  }

  void start() {
    if (_microphonePermissionStatus == 'Microphone permission is granted') {
      fpad.start();
      getResult();
    } else {
      _checkMicrophonePermission();
    }
  }

  void stop() {
    fpad.stop();
  }

  void getResult() {
    result = fpad.startAudioRecognition();
    result!.listen((event) {
      printText = "";
      setState(() {
        notes = fpad.getNotes(event);
      });
      notes.map((e) => {printText += e});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practica'),
      ),
      body: Center(
        child: Text(
          notes.toString(),
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
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
      )
    );
  }
}
