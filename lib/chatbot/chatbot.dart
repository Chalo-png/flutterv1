import 'package:flutter/material.dart';
import 'package:test2/chatbot/opciones.dart';
import 'dart:async';

class Chatbot extends StatefulWidget {
  @override
  _Chatbot createState() => _Chatbot();
}

class _Chatbot extends State<Chatbot> {
  bool isVisibleMenu = false;
  bool isVisibleChat = false;
  int _currentIndex = 0;

  final String textoCompleto =
      "Este es un texto de ejemplo que se mostrará de a poco.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  final int delayMilliseconds = 100; // Milisegundos entre cada caracter
  String textoMostrado = "";

  int currentIndex = 0;
  Timer? timer;

  void MostrarTexto() {
    timer = Timer.periodic(Duration(milliseconds: delayMilliseconds), (timer) {
      if (currentIndex < textoCompleto.length) {
        setState(() {
          textoMostrado = textoCompleto.substring(0, currentIndex + 1);
          print(textoMostrado);
          currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void presiono_chatbot() {
    print("Miauuuu");
    setState(() {
      isVisibleMenu = !isVisibleMenu;
    });
  }

  void presiono_info() {
    print("Informacion Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      _currentIndex = 1;
    });
    MostrarTexto();
  }

  void presiono_reformular() {
    print("Reformular Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      _currentIndex = 1;
    });
    MostrarTexto();
  }

  void presiono_relacionado() {
    print("Relacionado Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      _currentIndex = 1;
    });
    MostrarTexto();
  }

  void presiono_preguntar() {
    print("Preguntar Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      setState(() {
        _currentIndex = 1;
      });
    });
    MostrarTexto();
  }

  void presiono_pizza() {
    print("Pizza Miau");
    setState(() {
      isVisibleChat = false;
      isVisibleMenu = true;
      _currentIndex = 0;
      textoMostrado = "";
      currentIndex = 0;
    });
  }

  final IconData iconExplicacion = Icons.info;
  final IconData iconReformular = Icons.autorenew;
  final IconData iconTemasRelacionados = Icons.add;
  final IconData iconPreguntar = Icons.help;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 0.0
                            : 70.0,
                        top: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 300.0
                            : 70.0,
                        right: 0.0,
                        bottom: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 0.0
                            : 10.0),
                    child: IndexedStack(
                      index: _currentIndex,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Row(children: <Widget>[
                                AnimatedCard(
                                  isVisible: isVisibleMenu,
                                  text: 'Explicación',
                                  icon: iconExplicacion,
                                  onTap: presiono_info,
                                ),
                                AnimatedCard(
                                  isVisible: isVisibleMenu,
                                  text: 'Reformular',
                                  icon: iconReformular,
                                  onTap: presiono_reformular,
                                ),
                              ]),
                              Row(children: <Widget>[
                                AnimatedCard(
                                  isVisible: isVisibleMenu,
                                  text: 'Relacionado',
                                  icon: iconTemasRelacionados,
                                  onTap: presiono_relacionado,
                                ),
                                AnimatedCard(
                                  isVisible: isVisibleMenu,
                                  text: 'Preguntar',
                                  icon: iconPreguntar,
                                  onTap: presiono_preguntar,
                                ),
                              ]),
                            ],
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 0.0
                                    : 0.0,
                                top: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 0.0
                                    : 0.0,
                                right: 0.0,
                                bottom: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 300.0
                                    : 10.0),
                            child: GestureDetector(
                              onTap: isVisibleChat ? presiono_pizza : null,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: isVisibleChat ? 1.0 : 0.0,
                                child: Container(
                                  width: 350,
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
                                  child: Center(
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 10.0),
                                      physics:
                                          BouncingScrollPhysics(), // Opcional: Física de desplazamiento
                                      child: Text(
                                        textoMostrado,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 0.0,
                          top: 0.0,
                          right: 0.0,
                          bottom: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 0.0
                              : 10.0),
                      child: GestureDetector(
                        onTap: isVisibleChat ? null : presiono_chatbot,
                        child: Image.asset(
                          'assets/chatbot_gato.png',
                          // fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
