import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'opciones.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'consts.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:test2/models/user.dart';
import 'chat_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Chatbot extends StatefulWidget {
  @override
  _Chatbot createState() => _Chatbot();
}

/// The state class for the Chatbot widget.
class _Chatbot extends State<Chatbot> {
  bool isVisibleMenu = false;
  bool isChatPageVisible = false;
  bool isFirstTime = true;
  String userName = "Alonso";
  int _IndexTalk = 0;
  int userId = 0;
  int? age;
  String _buttonName1 = "Explicación";
  String _buttonName2 = "Reformular";
  String _buttonName3 = "Relacionado";
  String _buttonName4 = "Preguntar";
  String? contextText;
  final FlutterTts _flutterTts = FlutterTts();

  Map? _currentVoice;

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

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );
  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );
  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Chat',
    lastName: 'GPT',
  );

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];
  List<String> _lastMessages = <String>[];

  @override
  void initState() {
    super.initState();
    getEdad(userId);
    contextText =
        'Eres el asistente una aplicación llamada Piano Colors, que se enfoca en la enseñanza de piano a niños con síndrome de Down. Actualmente tiene 4 modos: 1.Practicar una cancion con un piano real, con reconocimiento de notas, 2. Generar una cancion segun un nivel de dificultad, 3. Lecciones de conceptos musicales, tales como sonidos y silencios, 4. Minijuegos para reforzar conceptos musicales, como memorice. Recuerda ajustar tu respuesta de modo que ellos lo entiendan, son niños con capacidades diferentes y tus respuestas deben ser siempre afirmaciones. El usuario actual se llama $userName, de $age años de edad. Recuerda ajustar tu respuestar tomando en cuenta la edad del usuario y el hecho de que tiene Sindrome de Down. RECUERDA AJUSTAR TU RESPUESTA SEGUN LA EDAD DEL USUARIO Y NO REPITAS TUS RESPUESTAS. Menciona la edad del usuario en tu respuesta';
    print(contextText);
    _fetchEdad();
  }

  Future<void> _fetchEdad() async {
    int? edad = await getUserEdadById(0);
    if (edad != null) {
      // Do something with the fetched leccion
      // For example, you might want to update the state
      setState(() {
        age = edad; // Update according to the fetched leccion
      });
    } else {
      setState(() {
        age = 0;
      });
    }
  }

  bool isVisibleChat = false;
  int _currentIndex = 0;

  final String textoCompleto =
      "Este es un texto de ejemplo que se mostrará de a poco.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  final int delayMilliseconds = 100; // Milisegundos entre cada caracter
  String textoMostrado = "";

  int currentIndex = 0;
  Timer? timer;
  bool shouldContinue = true;
  Completer<void> completer = Completer<void>();

  int indice = 0;

  List<String> Guia = [
    'Bienvenido a Piano Color!\n Con nosotros podrás aprender conceptos de música y tocar divertidas canciones',
    'El modo práctica permite escoger una canción, para que puedas ensayar',
    'El modo Generar una Melodia permite generar fragmentos musicales para que tengas más para practicar',
    'El modo Leccion tiene distintas enseñanzas y ejercicios asociados',
    'El modo Minijuego tiene distintos juegos para que puedas divertirte',
    'Espero que disfrutes y aprendas con Piano Colors'
  ];
  void presiono_guia() {
    MostrarTexto(Guia[1]);
  }

  /// Shows the text character by character with a delay.
  void MostrarTexto(String text) async {
    String greetingResponse;
    _flutterTts.setSpeechRate(0.5);

    int localIndex = 0;
    if (isFirstTime) {
      greetingResponse = await sendUserGreeting();
      isFirstTime = false;
    } else {
      greetingResponse = await askQuestion(text);
    }
    _lastMessages.add(greetingResponse);
    _flutterTts.speak(greetingResponse);
    timer = Timer.periodic(Duration(milliseconds: delayMilliseconds),
        (timer) async {
      if (shouldContinue && localIndex < greetingResponse.length) {
        setState(() {
          textoMostrado = greetingResponse.substring(0, localIndex + 1);
          print(textoMostrado);
          if (greetingResponse.substring(localIndex, localIndex + 1) == " ") {
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
      if (shouldContinue && localIndex == greetingResponse.length) {
        indice = indice + 1;
      }
    });
  }

  /// Sends a greeting message to the user and returns the response.
  Future<String> sendUserGreeting() async {
    String res = "";
    setState(() {
      _typingUsers.add(_gptChatUser);
    });
    String greetingPrompt =
        ' El usuario acaba de ingresar a la aplicacion, recibelo con un saludo';
    List<Map<String, dynamic>> messagesHistory = [
      Messages(role: Role.user, content: contextText! + greetingPrompt).toJson()
    ];
    final request = ChatCompleteText(
      messages: messagesHistory,
      maxToken: 200,
      model: GptTurboChatModel(),
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        res = element.message!.content;
      }
    }
    _lastMessages.add(res);
    List<String> relatedTopics = await getRelatedTopics();
    _buttonName1 = removeLeadingAsterisksAndSpaces(relatedTopics[0]);
    _buttonName2 = removeLeadingAsterisksAndSpaces(relatedTopics[1]);
    _buttonName3 = removeLeadingAsterisksAndSpaces(relatedTopics[2]);
    _buttonName4 = removeLeadingAsterisksAndSpaces(relatedTopics[3]);
    return res;
  }

  String removeLeadingAsterisksAndSpaces(String input) {
    return input.replaceAll(RegExp(r'^[\*\s]+'), '');
  }

  /// Handles the button press event for the Chatbot button.
  void presiono_chatbot() {
    print("Miauuuu");
    setState(() {
      isVisibleMenu = !isVisibleMenu;
    });
  }

  /// Handles the button press event for the Info button.
  void presiono_info() async {
    print("Informacion Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      _currentIndex = 1;
    });
    MostrarTexto(_buttonName1);
    List<String> relatedTopics = await getRelatedTopics();
    _buttonName1 = removeLeadingAsterisksAndSpaces(relatedTopics[0]);
    _buttonName2 = removeLeadingAsterisksAndSpaces(relatedTopics[1]);
    _buttonName3 = removeLeadingAsterisksAndSpaces(relatedTopics[2]);
    _buttonName4 = removeLeadingAsterisksAndSpaces(relatedTopics[3]);
    getRelatedIcons(relatedTopics);
  }

  /// Handles the button press event for the Reformular button.
  void presiono_reformular() async {
    print("Reformular Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      _currentIndex = 1;
    });
    MostrarTexto(_buttonName2);
    List<String> relatedTopics = await getRelatedTopics();
    _buttonName1 = removeLeadingAsterisksAndSpaces(relatedTopics[0]);
    _buttonName2 = removeLeadingAsterisksAndSpaces(relatedTopics[1]);
    _buttonName3 = removeLeadingAsterisksAndSpaces(relatedTopics[2]);
    _buttonName4 = removeLeadingAsterisksAndSpaces(relatedTopics[3]);
    getRelatedIcons(relatedTopics);
  }

  /// Handles the button press event for the Relacionado button.
  void presiono_relacionado() async {
    print("Relacionado Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      _currentIndex = 1;
    });
    MostrarTexto(_buttonName3);
    List<String> relatedTopics = await getRelatedTopics();
    _buttonName1 = removeLeadingAsterisksAndSpaces(relatedTopics[0]);
    _buttonName2 = removeLeadingAsterisksAndSpaces(relatedTopics[1]);
    _buttonName3 = removeLeadingAsterisksAndSpaces(relatedTopics[2]);
    _buttonName4 = removeLeadingAsterisksAndSpaces(relatedTopics[3]);
    getRelatedIcons(relatedTopics);
  }

  /// Handles the button press event for the Preguntar button.
  void presiono_preguntar() async {
    print("Preguntar Miau");
    setState(() {
      isVisibleMenu = false;
      isVisibleChat = true;
      isChatPageVisible = true;
      setState(() {
        _currentIndex = 1;
      });
    });
    MostrarTexto(_buttonName4);
    List<String> relatedTopics = await getRelatedTopics();
    _buttonName1 = removeLeadingAsterisksAndSpaces(relatedTopics[0]);
    _buttonName2 = removeLeadingAsterisksAndSpaces(relatedTopics[1]);
    _buttonName3 = removeLeadingAsterisksAndSpaces(relatedTopics[2]);
    _buttonName4 = removeLeadingAsterisksAndSpaces(relatedTopics[3]);
    getRelatedIcons(relatedTopics);
  }

  /// Handles the button press event for the Pizza button.
  void presiono_pizza() {
    setState(() {
      isVisibleChat = false;
      isVisibleMenu = true;
      _currentIndex = 0;
      textoMostrado = "";
      currentIndex = 0;
    });
  }

  /// Retrieves a list of related topics based on the previous response.
  Future<List<String>> getRelatedTopics() async {
    String previousGptResponse = _lastMessages.last;
    String getRelatedTopicsText =
        'Sugiere 4 temas relacionados a tu respuesta anterior. Tu respuesta no debe tener mas de cinco palabras. La respuesta anterior fue la siguiente:' +
            previousGptResponse +
            ' \n Tu respuesta debe seguir el siguiente formato: * Respuesta 1 * Respuesta 2 * Respuesta 3 * Respuesta 4';
    List<String> relatedTopics = [];
    List<Map<String, dynamic>> messagesHistory = [
      Messages(role: Role.user, content: getRelatedTopicsText).toJson()
    ];
    final request = ChatCompleteText(
      messages: messagesHistory,
      maxToken: 200,
      model: GptTurboChatModel(),
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: element.message!.content,
            ),
          );
        });
        print(element.message!.content);
        relatedTopics =
            getMatches(element.message!.content, RegExp(r"\*[^*]+"));
      }
    }
    print(relatedTopics);
    return relatedTopics;
  }

  /// Retrieves all matches of a regular expression in a given text.
  List<String> getMatches(String text, RegExp regex) {
    List<String> matchesStr = [];
    Iterable<RegExpMatch> matches = regex.allMatches(text);
    for (final m in matches) {
      print(m[0]);
      matchesStr.add(m[0]!);
    }
    return matchesStr;
  }

  Future<int?> getEdad(int userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(userId.toString());

    // Get the user document
    final snapshot = await userDoc.get();
    int? edad;
    if (snapshot.exists) {
      edad = snapshot.get('edad');
    }
    if (edad != null) {
      // Do something with the fetched leccion
      // For example, you might want to update the state
      setState(() {
        age = edad; // Update according to the fetched leccion
      });
    } else {
      setState(() {
        age = 0;
      });
    }
    print(edad);
    return edad;
  }

  Future<String> askQuestion(String m) async {
    String res = "";
    setState(() {
      _typingUsers.add(_gptChatUser);
    });
    String questionPrompt = "\n Respuesta anterior de ChatGPT:" +
        _lastMessages.last +
        "\n No comiences tu respuesta saludando al usuario, ya lo hiciste cuando ingreso a la aplicacion. Pregunta: Como " +
        m;
    List<Map<String, dynamic>> messagesHistory = [
      Messages(role: Role.user, content: contextText! + questionPrompt).toJson()
    ];
    final request = ChatCompleteText(
      messages: messagesHistory,
      maxToken: 200,
      model: GptTurboChatModel(),
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        res = element.message!.content;
      }
    }
    _lastMessages.add(res);
    List<String> relatedTopics = await getRelatedTopics();
    _buttonName1 = removeLeadingAsterisksAndSpaces(relatedTopics[0]);
    _buttonName2 = removeLeadingAsterisksAndSpaces(relatedTopics[1]);
    _buttonName3 = removeLeadingAsterisksAndSpaces(relatedTopics[2]);
    _buttonName4 = removeLeadingAsterisksAndSpaces(relatedTopics[3]);
    getRelatedIcons(relatedTopics);
    return res;
  }

  IconData iconExplicacion = Icons.info;
  IconData iconReformular = Icons.autorenew;
  IconData iconTemasRelacionados = Icons.add;
  IconData iconPreguntar = Icons.help;
  IconData iconChatbot = Icons.chat;

  Future<void> getRelatedIcons(List<String> topics) async {
    String text = topics[0] + topics[1] + topics[2] + topics[3];
    String getRelatedIconsText =
        'Eres un recomendador de iconos para flutter. Estos debe ser capaces de guardarse en la variable tipo IconData. Solo debes responder con el texto de por ejemplo: Icons.music_note, Icons.home,etc. Solo debes sugerir iconos presentes en material design. El formato de entrada es * Respuesta1 * Respuesta2 * Respuesta3 *  Respuesta4 y el formato de salida es Salida1 * Salida2 * Salida3 * Salida4. \nEntrada : ' +
            text;
    List<String> relatedIcons = [];
    List<Map<String, dynamic>> messagesHistory = [
      Messages(role: Role.user, content: getRelatedIconsText).toJson()
    ];
    final request = ChatCompleteText(
      messages: messagesHistory,
      maxToken: 200,
      model: GptTurboChatModel(),
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: element.message!.content,
            ),
          );
        });
        print(element.message!.content);
        relatedIcons = getMatches(element.message!.content, RegExp(r"\*[^*]+"));
      }
    }
    print(relatedIcons);
    if (relatedIcons.isNotEmpty) {
      iconExplicacion = MdiIcons.fromString(relatedIcons[0].split('.').last)!;
      iconReformular = MdiIcons.fromString(relatedIcons[1].split('.').last)!;
      iconTemasRelacionados =
          MdiIcons.fromString(relatedIcons[2].split('.').last)!;

      iconPreguntar = MdiIcons.fromString(relatedIcons[3].split('.').last)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.0
                   : 140.0,
              top: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.0
                  : 260.0,
              right: 0.0,
              bottom: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.0
                  : 0.0,
            ),
            child: IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          AnimatedCard(
                            isVisible: isVisibleMenu,
                            text: _buttonName1,
                            icon: iconExplicacion,
                            onTap: presiono_info,
                          ),
                          AnimatedCard(
                            isVisible: isVisibleMenu,
                            text: _buttonName2,
                            icon: iconReformular,
                            onTap: presiono_reformular,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          AnimatedCard(
                            isVisible: isVisibleMenu,
                            text: _buttonName3,
                            icon: iconTemasRelacionados,
                            onTap: presiono_relacionado,
                          ),
                          AnimatedCard(
                            isVisible: isVisibleMenu,
                            text: _buttonName4,
                            icon: iconPreguntar,
                            onTap: presiono_preguntar,
                            // presiono_preguntar();
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          AnimatedCard(
                            isVisible: isVisibleMenu,
                            text: "Preguntar por texto",
                            icon: iconChatbot,
                            onTap: () {
                              // presiono_preguntar();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 0.0
                            : 20.0,
                      top: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 0.0
                          : 20.0,
                      right: 20.0,
                      bottom: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 0.0
                          : 20.0,
                    ),
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
                            physics: BouncingScrollPhysics(),
                            child: Text(
                              textoMostrado,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
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
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              bottom: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.0
                  : 10.0,
            ),
            child: GestureDetector(
              onTap: isVisibleChat ? null : presiono_chatbot,
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
