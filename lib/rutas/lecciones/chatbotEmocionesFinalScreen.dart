import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../chatbot/chatbot_emociones.dart';
import '../../models/leccionM.dart';
import '../../models/user.dart';

/// Screen for the final step of the Emotions Chatbot.
class ChatbotEmocionesFinalScreen extends StatefulWidget {
  const ChatbotEmocionesFinalScreen({super.key});

  @override
  ChatbotEmocionesFinalScreenState createState() =>
      ChatbotEmocionesFinalScreenState();
}

/// State class for the ChatbotEmocionesFinalScreen.
class ChatbotEmocionesFinalScreenState
    extends State<ChatbotEmocionesFinalScreen> {
  String sentimiento = "default";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // TODO: Add any necessary initialization logic here
    });
  }

  /// Handles the save operation.
  Future<void> _handleSave() async {
    List<LeccionM> currLeccion = setupLeccion(1, true, sentimiento);
    String email = "user@example.com";
    String password = "securePassword";
    String userType = "Alumno";
    int edad = 5;
    User currUser =
    setupLeccionforsave(currLeccion, 2, email, password, userType, edad);
    storeUser(currUser);
  }

  /// Sets up a LeccionM object.
  List<LeccionM> setupLeccion(int leccionId, bool completed, String sentimiento) {
    LeccionM leccion = LeccionM(
      leccionId: leccionId,
      completed: completed,
      sentimiento: sentimiento,
    );

    List<LeccionM> leccionList = [];
    leccionList.add(leccion);
    return leccionList;
  }

  /// Sets up a User object for saving.
  User setupLeccionforsave(
      List<LeccionM> lecciones,
      int userId,
      String email,
      String password,
      String userType,
      int edad,
      ) {
    User user = User(
      id: userId,
      email: email,
      password: password,
      userType: userType,
      edad: edad,
      lecciones: lecciones,
    );

    return user;
  }

  /// Updates the [sentimiento] and handles the save operation.
  void updateSentimiento(String newSentimiento) {
    setState(() {
      sentimiento = newSentimiento;
      _handleSave();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Felicidades!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chatbot(
              tipo: 1,
              onSentimientoSelected: updateSentimiento,
            ),
            ElevatedButton(
              onPressed: sentimiento == "default"
                  ? null
                  : () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/'),
                );
              },
              child: const Text('Volver al menu principal'),
            ),
          ],
        ),
      ),
    );
  }
}


