import 'package:flutter/material.dart';

class LeccionesScreen extends StatefulWidget {
  const LeccionesScreen({super.key});

  @override
  LeccionesScreenState createState() => LeccionesScreenState();
}

class LeccionesScreenState extends State<LeccionesScreen> {
  late bool leccion1Completada;  bool leccion2Completada = false;
  bool leccion3Completada = false;
  @override
  void initState() {
    super.initState();
    // Initialize any non-context dependent variables here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access context-dependent variables here
    leccion1Completada = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecciones'),
      ),
      backgroundColor: Colors.blue, // Fondo azul
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              color: Colors.red,
              title: 'Lección 1 - Sonido y Silencio',
              description: 'Descubre el mundo de los sonidos y aprende a valorar el silencio.',
              icon: leccion1Completada ? Icons.star : Icons.star_border,
              onTap: (){
                Navigator.pushNamed(context, '/leccion1');
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              color: Colors.orange,
              title: 'Lección 2 - Pentagrama',
              description: 'Explora el pentagrama y aprende a leer música.',
              icon: Icons.star_border,
              onTap: (){
                Navigator.pushNamed(context, '/lecciones/leccion2', arguments: leccion1Completada);
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              color: Colors.yellow,
              title: 'Lección 3 - Llave de Sol',
              description: 'Conoce la llave de sol y su importancia en la música.',
              icon: Icons.star_border,
              onTap: (){
                Navigator.pushNamed(context, '/lecciones/leccion3');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Esta es la función que se ejecutará al presionar el botón
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
          trailing: Icon(
            icon,
            color: Colors.white,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}

