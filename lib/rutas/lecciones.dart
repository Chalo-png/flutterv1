import 'package:flutter/material.dart';
import '../models/leccionM.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A screen that displays a list of lessons.
class LeccionesScreen extends StatefulWidget {
  const LeccionesScreen({Key? key}) : super(key: key);

  @override
  LeccionesScreenState createState() => LeccionesScreenState();
}

/// The state of the [LeccionesScreen].
class LeccionesScreenState extends State<LeccionesScreen> {
  bool leccion1Completada = false;
  bool leccion2Completada = false;
  bool leccion3Completada = false;
  int userId = 2;
  int leccionId = 1;

  @override
  void initState() {
    super.initState();
    _fetchLeccion();
  }

  /// Fetches the lesson data for the given user and lesson ID.
  Future<void> _fetchLeccion() async {
    LeccionM? leccion = await getLeccionByUserIdAndLeccionId(userId, leccionId);
    if (leccion != null) {
      // Do something with the fetched leccion
      // For example, you might want to update the state
      setState(() {
        leccion1Completada =
            leccion.completed; // Update according to the fetched leccion
      });
    } else {
      setState(() {
        leccion1Completada = false;
      });
    }
  }

  /// Retrieves the lesson data for the given user and lesson ID from Firestore.
  Future<LeccionM?> getLeccionByUserIdAndLeccionId(
      int userId, int leccionId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(userId.toString());

    // Get the user document
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      List<dynamic> lecciones = snapshot.data()?['lecciones'] ?? [];

      // Ensure each element in lecciones is a Map before accessing 'leccion_id'
      for (var leccionJson in lecciones) {
        if (leccionJson is Map<String, dynamic>) {
          if (leccionJson['leccion_id'] == leccionId) {
            return LeccionM.fromJson(leccionJson);
          }
        }
      }
    }
    return null;
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
              description:
                  'Descubre el mundo de los sonidos y aprende a valorar el silencio.',
              icon: leccion1Completada ? Icons.star : Icons.star_border,
              onTap: () {
                Navigator.pushNamed(context, '/leccion1');
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              color: Colors.orange,
              title: 'Lección 2 - Pentagrama',
              description: 'Explora el pentagrama y aprende a leer música.',
              icon: Icons.star_border,
              onTap: () {
                Navigator.pushNamed(context, '/lecciones/leccion2',
                    arguments: leccion1Completada);
              },
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              color: Colors.yellow,
              title: 'Lección 3 - Llave de Sol',
              description:
                  'Conoce la llave de sol y su importancia en la música.',
              icon: Icons.star_border,
              onTap: () {
                Navigator.pushNamed(context, '/lecciones/leccion3');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom button widget.
class CustomButton extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
