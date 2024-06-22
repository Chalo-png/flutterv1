
import 'package:flutter/material.dart';
import 'package:test2/rutas/generaMelodia.dart';
import 'package:test2/rutas/lecciones.dart';
import 'package:test2/rutas/practica.dart';
import 'package:test2/widgets/widget_practiceMode/practiceMode.dart';
import 'package:test2/rutas/vistaPrevia.dart';
import 'package:test2/rutas/cancionesPrecargadas.dart';
import 'package:test2/rutas/n_lecciones/leccion1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/cancionesPrecargadas': (context) => CancionesPrecargadas(),
        '/practica': (context) => PracticaScreen(),
        '/generaMelodia': (context) => GeneraMelodiaScreen(),
        '/vistaPrevia': (context) => MusicSheetDisplayScreen(),
        '/': (context) => const HomeScreen(),
        '/lecciones': (context) => const LeccionesScreen(),
        '/leccion1': (context) => const Leccion1Screen(),
      },
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              color: Colors.red[200]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LeccionesScreen()),
                );
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

  const CustomButton({super.key,required this.text, required this.color, required this.onTap});
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
