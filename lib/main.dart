import 'package:flutter/material.dart';
import 'package:test2/rutas/lecciones.dart';
import 'package:test2/rutas/practica.dart';
import 'package:test2/rutas/vistaPrevia.dart';
import 'package:test2/rutas/cancionesPrecargadas.dart';
import 'package:test2/rutas/lecciones/leccion1.dart';
import 'package:test2/rutas/generar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:test2/chatbot/chatbot_tutorial.dart';
import 'package:test2/chatbot/chatbot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        '/generaMelodia': (context) => GeneratorDisplayScreen(),
        '/vistaPrevia': (context) => MusicSheetDisplayScreen(),
        '/': (context) => HomeScreen(),
        '/lecciones': (context) => const LeccionesScreen(),
        '/leccion1': (context) => const Leccion1Screen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int valor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piano Colors'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              Expanded(
                flex: 7, // 70% del espacio
                child: Row(
                  children: [
                    Expanded(
                      child: IndexedStack(
                        index: valor,
                        children: [
                          Chatbot_Tutorial(
                            cambiarIndex: (nuevoValor) {
                              setState(() {
                                valor = nuevoValor;
                              });
                            },
                          ),
                          Chatbot(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3, // 30% del espacio
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Práctica',
                        color: Colors.yellow,
                        onTap: () {
                          Navigator.pushNamed(context, '/cancionesPrecargadas');
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'Generar',
                        color: Colors.red[200]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GeneratorDisplayScreen()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'Lecciones',
                        color: Colors.green[200]!,
                        onTap: () {
                          Navigator.pushNamed(context, '/lecciones');
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'Minijuegos',
                        color: Colors.blue[200]!,
                        onTap: () {
                          // Navegar a la pantalla de Minijuegos
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula el tamaño de la fuente en base al ancho disponible
          double fontSize = constraints.maxWidth * 0.1; // Ajusta este factor según sea necesario
          
          return Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}

