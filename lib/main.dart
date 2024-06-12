import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(home: MicPage()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

class MicPage extends StatefulWidget {
  const MicPage({super.key});

  @override
  State<MicPage> createState() => _MicPageState();
}

class _MicPageState extends State<MicPage> {
  AudioRecorder myRecording = AudioRecorder();
  Timer? timer;
  
  double volume = 0.0;
  double minVolume = -45.0;
    
  startTimer() async{
    timer ??= 
      Timer.periodic(const Duration(milliseconds: 50), (timer) => updateVolume());
  }

  updateVolume() async {
    Amplitude ampl = await myRecording.getAmplitude();
    if(ampl.current > minVolume){
      setState(() {
        volume = (ampl.current - minVolume) / minVolume;
      });
  
    }
  }

  int volume0to(int maxVolumeToDisplay){
    return (volume * maxVolumeToDisplay).round().abs();
  }

  RecordConfig config = const RecordConfig(
  // Set your desired configuration options here
  // For example:
  encoder: AudioEncoder.wav,
);

  Future<bool> startRecording() async {
    if(await myRecording.hasPermission()){
      if(!await myRecording.isRecording()){
        Directory appDocDirectory = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDirectory.path}/record.wav';
        await myRecording.start(path: filePath, config);
        print("Recording started");
      }
      startTimer();
      return true;
    }else{
      return false;
    }
  }

  @override
    Widget build(BuildContext context) {
    final Future<bool> recordFutureBuilder =
        Future<bool>.delayed(const Duration(seconds: 3), (() async {
      return startRecording();
    }));

    return FutureBuilder(
        future: recordFutureBuilder,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return Scaffold(
            body: Center(
                child: snapshot.hasData
                    ? Text("VOLUME\n${volume0to(100)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 42, fontWeight: FontWeight.bold))
                    : const CircularProgressIndicator()),
          );
        });

}}