import 'package:flutter/material.dart';
import 'package:test2/chatbot/opciones.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:test2/chatbot/emociones.dart';

/// A stateful widget that represents a chatbot.
class Chatbot extends StatefulWidget {
  final int tipo;
  final Function(String) onSentimientoSelected;

  /// Creates a new instance of the [Chatbot] widget.
  ///
  /// The [tipo] parameter specifies the type of the chatbot.
  /// The [onSentimientoSelected] parameter is a callback function that is called when a sentiment is selected.
  Chatbot({
    required this.tipo,
    required this.onSentimientoSelected,
  });

  @override
  _Chatbot createState() => _Chatbot();
}

/// The private state class for the [Chatbot] widget.
class _Chatbot extends State<Chatbot> {
  bool isVisibleMenu = false;
  bool isVisibleChat = false;
  bool isVisibleChatPregunta = false;
  late int _currentIndex;
  int _IndexTalk = 0;
  TextEditingController _textController = TextEditingController();

  final FlutterTts _flutterTts = FlutterTts();

  Map? _currentVoice;

  /// Initializes the text-to-speech engine.
  void initTTS() {
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        try {
          _flutterTts.setSpeechRate(2.0);
        } catch (e) {
          print(e);
        }
        print(voices);
        voices = voices.where((voice) => voice["name"].contains("es")).toList();
        setState(() {
          _currentVoice = voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  /// Sets the voice for the text-to-speech engine.
  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  List<String> Guia = [
    '¿Como te sientes?',
  ];

  String textoCompleto =
      "Este es un texto de ejemplo para probar que el audio se detiene detiene detiene detiene detiene detiene detiene detiene detiene detiene detiene detiene detiene detiene detiene";
  final int delayMilliseconds = 60; // Milisegundos entre cada caracter
  String textoMostrado = "";

  int currentIndex = 0;
  Timer? timer;

  /// Displays the given [texto] character by character with a delay.
  Future<void> MostrarTexto(String texto) async {
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.speak(texto);

    Completer<void> completer = Completer<void>();
    int localIndex = 0;

    timer = Timer.periodic(Duration(milliseconds: delayMilliseconds), (timer) {
      if (localIndex < texto.length) {
        setState(() {
          textoMostrado = texto.substring(0, localIndex + 1);
          print(textoMostrado);
          if (texto.substring(localIndex, localIndex + 1) == " ") {
            _IndexTalk = 0;
          } else {
            _IndexTalk = 1;
          }
          localIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _IndexTalk = 0;
        });
        completer.complete();
      }
    });

    return completer.future;
  }

  /// Sets the [textoCompleto] to the given [value].
  void ChatTexto(String value) {
    setState(() {
      textoCompleto = value;
    });
    // MostrarTexto();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var text in Guia) {
        await MostrarTexto(text);
        await Future.delayed(Duration(seconds: 10));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 100.0
                      : 100.0,
              vertical:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 0.0
                      : 0.0,
            ),
            child: EmocionesCard(
                TipoActividad: "leccion ?",
                onSentimientoSelected: widget.onSentimientoSelected),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              bottom: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.0
                  : 10.0,
            ),
            child: GestureDetector(
              onTap: isVisibleChat ? null : null,
              child: Container(
                child: IndexedStack(
                  index: _IndexTalk,
                  children: [
                    Image.asset(
                      'assets/chatbot_camaleon_color_final.png',
                    ),
                    Image.asset(
                      'assets/chatbot_camaleon_color_habla_final.png',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
