import 'package:flutter/material.dart';
import '../../models/leccionM.dart';
import 'package:test2/models/user.dart';
import 'package:test2/chatbot/chatbot_emociones.dart';

class EmocionesFinalWidget extends StatefulWidget {
  final int leccionId;
  final Function onSaveComplete; // Callback para cuando se complete el guardado

  const EmocionesFinalWidget({
    Key? key,
    required this.leccionId,
    required this.onSaveComplete,
  }) : super(key: key);

  @override
  EmocionesFinalWidgetState createState() => EmocionesFinalWidgetState();
}

class EmocionesFinalWidgetState extends State<EmocionesFinalWidget> {
  String sentimiento = "default";

  Future<void> _handleSave() async {
    List<LeccionM> currLeccion = setupLeccion(widget.leccionId, true, sentimiento);
    String email = "user@example.com";
    String password = "securePassword";
    String userType = "Alumno";
    int edad = 5;
    User currUser = setupLeccionforsave(currLeccion, 2, email, password, userType, edad);
    storeUser(currUser);
    widget.onSaveComplete();
  }

  List<LeccionM> setupLeccion(int leccionId, bool completed, String sentimiento) {
    LeccionM leccion = LeccionM(
      leccionId: leccionId,
      completed: completed,
      sentimiento: sentimiento,
    );
    return [leccion];
  }

  User setupLeccionforsave(
      List<LeccionM> lecciones, int userId, String email, String password, String userType, int edad) {
    return User(
      id: userId,
      email: email,
      password: password,
      userType: userType,
      edad: edad,
      lecciones: lecciones,
    );
  }

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
              onPressed: sentimiento == "default" ? null : null,
              child: const Text('Volver al menú principal'),
            ),
          ],
        ),
      ),
    );
  }
}
