import 'package:flutter/material.dart';
import 'package:test2/chatbot/opciones.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:test2/chatbot/emociones.dart';

/// A stateful widget that represents the Chatbot Tutorial screen.
class Chatbot_Tutorial extends StatefulWidget {
  final Function(int) cambiarIndex;

  /// Creates a new instance of [Chatbot_Tutorial].
  ///
  /// The [cambiarIndex] parameter is a callback function that takes an integer as a parameter.
  Chatbot_Tutorial({required this.cambiarIndex});

  @override
  _Chatbot_Tutorial createState() => _Chatbot_Tutorial();
}

/// The private state class for the [Chatbot_Tutorial] widget.
class _Chatbot_Tutorial extends State<Chatbot_Tutorial> {
  bool isVisibleMenu = false;
  bool isVisibleChat = false;
  bool isVisibleChatPregunta = false;
  int _IndexTalk = 0;
  IconData guia_icono = Icons.help;
  IconData guia_pausa = Icons.pause;

  String accion_pausa_continuar = "Pausa      ";

  final FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;
  Completer<void> completer = Completer<void>();
  int indice = 0;

  /// List of tutorial steps.
  List<String> Guia = [
    'Bienvenido a Piano Color!\n Con nosotros podrás aprender conceptos de música y tocar divertidas canciones de música y tocar divertidas canciones',
    'El modo práctica permite escoger una canción, para que puedas ensayar',
    'El modo Generar una Melodia permite generar fragmentos musicales para que tengas más para practicar',
    'El modo Leccion tiene distintas enseñanzas y ejercicios asociados',
    'El modo Minijuego tiene distintos juegos para que puedas divertirte',
    'Espero que disfrutes y aprendas con Piano Colors'
  ];

  final int delayMilliseconds = 60; // Milisegundos entre cada caracter
  String textoMostrado = "";
  int currentIndex = 0;
  bool shouldContinue = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await MostrarTexto(Guia.first);
    });
    initTTS();
  }

  /// Initializes the Text-to-Speech engine and sets the default voice.
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

  /// Sets the voice for the Text-to-Speech engine.
  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  /// Displays the text character by character with a delay.
  Future<void> MostrarTexto(String texto) async {
    _flutterTts.setSpeechRate(0.1);
    _flutterTts.speak(texto);

    int localIndex = 0;
    timer = Timer.periodic(Duration(milliseconds: delayMilliseconds), (timer) {
      if (shouldContinue && localIndex < texto.length) {
        setState(() {
          textoMostrado = texto.substring(0, localIndex + 1);
          print(textoMostrado);
          _IndexTalk = texto.substring(localIndex, localIndex + 1) == " " ? 0 : 1;
          localIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _IndexTalk = 0;
        });
        completer.complete();
      }
      if (shouldContinue && localIndex == texto.length) {
        indice = indice + 1;
        accion_pausa_continuar = "Siguiente";
        guia_pausa = Icons.arrow_right_alt_outlined;
      }
    });

    return completer.future;
  }

  /// Handles the event when the "Guia" button is pressed.
  void presiono_guia() {
    setState(() {
      shouldContinue = false;
      if (timer != null) {
        timer?.cancel();
      }
      shouldContinue = true;
    });
    MostrarTexto(Guia[1]);
    indice = 1;
    accion_pausa_continuar = "Pausa      ";
    guia_pausa = Icons.pause;
  }

  /// Handles the event when the "Pausa" button is pressed.
  void presiono_pausa() {
    if (indice >= Guia.length) {
      setState(() {
        widget.cambiarIndex(1);
        shouldContinue = false;
      });
    } else if (accion_pausa_continuar != 'Continuar' && accion_pausa_continuar != 'Siguiente') {
      setState(() {
        shouldContinue = false;
        if (timer != null) {
          timer?.cancel();
        }
        accion_pausa_continuar = 'Continuar';
        guia_pausa = Icons.play_arrow;
      });
    } else if (accion_pausa_continuar == 'Continuar') {
      shouldContinue = true;
      // Reiniciar el timer si no se ha completado
      MostrarTexto(Guia[indice]);
      setState(() {
        accion_pausa_continuar = 'Pausa      ';
        guia_pausa = Icons.pause;
      });
    } else if (accion_pausa_continuar == 'Siguiente') {
      MostrarTexto(Guia[indice]);
      accion_pausa_continuar = "Pausa      ";
      guia_pausa = Icons.pause;
    }
  }
 @override
Widget build(BuildContext context) {
  return Center(
    child: Row(
      children: <Widget>[
        // Container for the tutorial text and buttons
        Container(
          width: MediaQuery.of(context).size.width * 0.55, // 55% of the available width
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
  children: [
    // Text display with scrolling capability
    Container(
      height: MediaQuery.of(context).size.height * 0.29, // 25% del espacio disponible
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Text(
          textoMostrado,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.025,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    ),
    Spacer(),
    Container(
      height: MediaQuery.of(context).size.height * 0.1, // 10% del espacio disponible
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: AnimatedCard(
                isVisible: true,
                text: 'Guia',
                icon: guia_icono,
                onTap: () => presiono_guia(),
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: AnimatedCard(
                isVisible: true,
                text: accion_pausa_continuar,
                icon: guia_pausa,
                onTap: () => presiono_pausa(),
              ),
            ),
          ),
        ],
      ),
    ),
  ],
)

        ),
        // Container for the chatbot image
        Container(
          width: MediaQuery.of(context).size.width * 0.35, // 35% of the available width
          child: GestureDetector(
            onTap: isVisibleChat ? null : null,
            child: Container(
              child: IndexedStack(
                index: _IndexTalk,
                children: [
                  Container(
                    width: double.infinity, // Occupies the full available width
                    height: MediaQuery.of(context).size.height * 0.5, // 50% of the screen height
                    child: Image.asset(
                      'assets/chatbot_camaleon_color_final.png',
                      fit: BoxFit.contain, // Adjusts the size of the image to fit in the container
                    ),
                  ),
                  Container(
                    width: double.infinity, // Occupies the full available width
                    height: MediaQuery.of(context).size.height * 0.5, // 50% of the screen height
                    child: Image.asset(
                      'assets/chatbot_camaleon_color_final.png',
                      fit: BoxFit.contain, // Adjusts the size of the image to fit in the container
                    ),
                  ),
                  Container(
                    width: double.infinity, // Occupies the full available width
                    height: MediaQuery.of(context).size.height * 0.5, // 50% of the screen height
                    child: Image.asset(
                      'assets/chatbot_camaleon_color_habla_final.png',
                      fit: BoxFit.contain, // Adjusts the size of the image to fit in the container
                    ),
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
