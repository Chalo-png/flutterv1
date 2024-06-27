import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'consts.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  RegExp regex = RegExp(r"\*[^*]+");
  String test =
      "* Los nombres de las notas: Do, Re, Mi, Fa, Sol, La, Si.\n* La diferencia entre acordes mayores y menores.\n* Cómo cambiar entre diferentes acordes en una canción.";
  String userName = "Alonso";
  String age = "7";
  String? greetingText;

  //Iniciar la instancia de OpenAI
  final _openAI = OpenAI.instance.build(
      token: OPENAI_API_KEY,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 5),
      ),
      enableLog: true);
  //Usuario del chat (el usuario de la App)
  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );
  //Usuario del chat GPT
  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Chat',
    lastName: 'GPT',
  );

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  void initState() {
    /*_messages.add(
      ChatMessage(
        text: 'Hey!',
        user: _user,
        createdAt: DateTime.now(),
      ),
    );*/
    super.initState();
    greetingText =
        'Eres el asistente una aplicación llamada Piano Colors, que se enfoca en la enseñanza de piano a niños con síndrome de Down. Recuerda ajustar tu respuesta de modo que ellos lo entiendan, son niños con capacidades diferentes y  tus respuestas deben ser siempre afirmaciones. El usuario actual se llama $userName, de $age años de edad. Recuerda ajustar tu respuestar tomando en cuenta la edad del usuario y el hecho de que tiene Sindrome de Down. El usuario acaba de ingresar a la aplicacion, recibelo con un saludo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 64, 255),
        title: const Text(
          'Chatbot de Piano Colors',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: _user,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(
            0,
            166,
            126,
            1,
          ),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
        typingUsers: _typingUsers,
      ),
    );
  }

  //Mandar mensaje a ChatGPT y obtener respuesta
  Future<void> getChatResponse(ChatMessage m) async {
    if (mounted) {
      setState(() {
        _messages.insert(0, m);
        _typingUsers.add(_gptChatUser);
      });
    }
    List<Map<String, dynamic>> messagesHistory =
        _messages.reversed.toList().map((m) {
      if (m.user == _user) {
        return Messages(role: Role.user, content: m.text).toJson();
      } else {
        return Messages(role: Role.assistant, content: m.text).toJson();
      }
    }).toList();
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
                text: element.message!.content),
          );
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }

  Future<void> sendUserGreeting() async {
    if (mounted) {
      setState(() {
        _typingUsers.add(_gptChatUser);
      });
    }
    List<Map<String, dynamic>> messagesHistory = [
      Messages(role: Role.user, content: greetingText).toJson()
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
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }

  List<String> getMatches(String text, RegExp regex) {
    List<String> matchesStr = [];
    Iterable<RegExpMatch> matches = regex.allMatches(text);
    for (final m in matches) {
      print(m[0]);
      matchesStr.add(m[0]!);
    }
    return matchesStr;
  }
}
