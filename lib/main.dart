import 'package:flutter/material.dart';
import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:test2/rutas/generaMelodia.dart';
import 'package:test2/rutas/practica.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/practica': (context) => PracticaScreen(),
        '/generaMelodia': (context) => GeneraMelodiaScreen(),

      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Piano App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Practica',
              color: Colors.yellow,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PracticaScreen()),
                );
              },
            ),
            CustomButton(
              text: 'Genera melodia',
              color: Colors.red[200]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneraMelodiaScreen()),
                );
              },
            ),
            CustomButton(
              text: 'Lecciones',
              color: Colors.green[200]!,
              onTap: () {
                // Navigate to Lecciones Screen
              },
            ),
            CustomButton(
              text: 'Minijuegos',
              color: Colors.blue[200]!,
              onTap: () {
                // Navigate to Minijuegos Screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  CustomButton({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
