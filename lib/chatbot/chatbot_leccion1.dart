import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Chatbot_Leccion1 extends StatefulWidget {
  int tipo;

  Chatbot_Leccion1({
    required this.tipo,
    Key? key,
  }) : super(key: key);

  @override
  ChatbotTutorialState createState() => ChatbotTutorialState();
}

class ChatbotTutorialState extends State<Chatbot_Leccion1> {
  bool isVisibleChat = false;
  int _indexTalk = 0;
  final FlutterTts _flutterTts = FlutterTts();
  late List<Map<dynamic, dynamic>> voices;

  @override
  void initState() {
    super.initState();
    initTTS();
    mostrarGuia(widget.tipo);
  }

  void mostrarGuia(int tipo) async {
    if (tipo >= 0 && tipo < Guia.length) {
      await _speak(Guia[tipo]);
    } else {
      print("Tipo fuera de rango");
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);

    int localIndex = 0;
    const delayMilliseconds = 70;

    Timer.periodic(Duration(milliseconds: delayMilliseconds), (timer) {
      if (localIndex < text.length) {
        setState(() {
          textoMostrado = text.substring(0, localIndex + 1);
          _indexTalk = text.substring(localIndex, localIndex + 1) == " " ? 0 : 1;
        });
        localIndex++;
      } else {
        timer.cancel();
        setState(() {
          _indexTalk = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void initTTS() async {
    voices = await _flutterTts.getVoices;
    voices = voices.where((voice) => voice["name"].toString().contains("es")).toList();
    if (voices.isNotEmpty) {
      _flutterTts.setVoice({"name": voices.first["name"], "locale": voices.first["locale"]});
    }
  }

  List<String> Guia = [
    '¡Hola! Bienvenido/a a la lección teórica. Aquí verás 6 pictogramas que representan diferentes conceptos. Vamos a explorarlos juntos.',
    'Después de explorar los pictogramas, vamos a hacer una actividad. Deberás clasificar imágenes como Sonoras o Silenciosas. Arrastra cada imagen a la zona correcta.',
    'Deberás clasificar imágenes como Sonoras o Silenciosas. Arrastra cada imagen a la zona correcta.',
  ];

  String textoMostrado = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: GestureDetector(
          onTap: isVisibleChat ? null : null,
          child: Container(
            child: IndexedStack(
              index: _indexTalk,
              children: [
                Image.asset('assets/chatbot_camaleon_color_final.png'),
                Image.asset('assets/chatbot_camaleon_color_habla_final.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
