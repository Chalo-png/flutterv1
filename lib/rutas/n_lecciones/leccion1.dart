import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:test2/chatbot/chatbot_leccion1.dart';
import '../../chatbot/emociones.dart';
import '../../models/leccionM.dart';
import 'package:test2/models/user.dart';
import 'package:test2/chatbot/chatbot_emociones.dart';
import "package:test2/chatbot/chatbot_tutorial.dart";
class Leccion1Screen extends StatelessWidget {
  const Leccion1Screen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lección 1 - Sonido y Silencio'),
      ),
      body:
          const ModoTeorico(), // Mostrar el modo teórico al inicio de la lección
    );
  }
}

class ModoTeorico extends StatefulWidget {
  const ModoTeorico({super.key});
  @override
  ModoTeoricoState createState() => ModoTeoricoState();
}

class ModoTeoricoState extends State<ModoTeorico> {
  // Lista de pictogramas con sus respectivos datos (título, sonido y animación)
  List<Pictograma> pictogramas = [
    Pictograma('vaca', 'vaca.mp3', 'vaca.png', 'vaca.gif'),
    Pictograma('dormir', '', 'dormir.png', 'dormir.gif'),
    Pictograma('auto', 'auto.mp3', 'auto.png', 'auto.gif'),
    Pictograma('silencio', '', 'silencio.png', 'silencio.gif'),
    Pictograma('cantar', 'cantar.mp3', 'cantar.png', 'cantar.gif'),
    Pictograma('meditar', '', 'meditar.png', 'meditar.gif'),
  ];
  // Lista para rastrear si cada pictograma ha sido tocado
  List<bool> tocado = [];
  // Instancia de AudioPlayer para reproducir sonidos
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    tocado = List<bool>.filled(pictogramas.length, false);
    // Precarga los sonidos al iniciar la pantalla
    for (var pictograma in pictogramas) {
      if (pictograma.sonido.isNotEmpty) {
        precargarSonido(pictograma.sonido);
      }
    }
  }

  // Método para precargar un sonido
  void precargarSonido(String assetPath) {
    audioPlayer.setSourceAsset(assetPath);
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Libera los recursos del AudioPlayer al cerrar la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // Ajusta este valor según tus necesidades
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: pictogramas.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  tocado[index] = true; // Marcar la tarjeta como tocada
                });
                reproducirSonido(index);
                mostrarAnimacion(context, index);
              },
              child: Card(
                color: tocado[index] ? Colors.green : Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/${pictogramas[index].imagen}',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      pictogramas[index].titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0), // Espacio a la izquierda
          alignment: Alignment.center,
          child: Chatbot_Leccion1(tipo: 0), // Instancia de la clase Chatbot_Tutorial
        ),
      ),
      ],
    );      
  }

  // Método para reproducir el sonido correspondiente al pictograma
  void reproducirSonido(int index) async {
    if (pictogramas[index].sonido.isNotEmpty) {
      await audioPlayer.play(AssetSource(pictogramas[index].sonido));
    }
  }

  // Método para mostrar la animación correspondiente al pictograma
  void mostrarAnimacion(BuildContext context, int index) {
    if (pictogramas[index].animacion.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 100.0,
            width: 100.0,
            child: Image.asset('assets/${pictogramas[index].animacion}'),
          ),
        ),
      ).then((value) {
        if (tocado.every((element) => element)) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FelicidadesScreen()),
            );
          });
        }
      });
    }
  }
}

class FelicidadesScreen extends StatefulWidget {
  const FelicidadesScreen({super.key});
  @override
  FelicidadesScreenState createState() => FelicidadesScreenState();
}

class FelicidadesScreenState extends State<FelicidadesScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    reproducirSonido();
  }

  void reproducirSonido() async {
    await audioPlayer.play(AssetSource('acertar.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Felicitaciones'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Felicitaciones por completar el modo teórico!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClasificacionScreen()),
                );
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ClasificacionScreen extends StatefulWidget {
  const ClasificacionScreen({super.key});
  @override
  ClasificacionScreenState createState() => ClasificacionScreenState();
}

class ClasificacionScreenState extends State<ClasificacionScreen> {
  Chatbot_Leccion1 mibot = Chatbot_Leccion1(tipo: 1);
  Chatbot_Leccion1 mibot2 = Chatbot_Leccion1(tipo: 2);
  int equivocarse = 0;
  int tipoChatbot = 1;
  List<ImagenClasificacion> imagenes = [
    ImagenClasificacion('vaca', 'vaca.png', true),
    ImagenClasificacion('dormir', 'dormir.png', false),
    ImagenClasificacion('auto', 'auto.png', true),
    ImagenClasificacion('silencio', 'silencio.png', false),
    ImagenClasificacion('cantar', 'cantar.png', true),
    ImagenClasificacion('meditar', 'meditar.png', false),
  ];
  List<ImagenClasificacion> sonoras = [];
  List<ImagenClasificacion> silenciosas = [];
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();

@override
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return Scaffold(
    appBar: AppBar(
      title: const Text('Clasificar Imágenes - Sonoras o Silenciosas'),
    ),
    body: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: DragTarget<ImagenClasificacion>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: screenHeight / 2,
                      color: Colors.blue.shade100,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Sonoras',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ...sonoras.map((e) => buildPictograma(e)),
                        ],
                      ),
                    );
                  },
                  onAcceptWithDetails: (DragTargetDetails<dynamic> details) {
                    final data = details.data;
                    setState(() {
                      if (data.esSonora) {
                        sonoras.add(data);
                        reproducirSonido('acertar.mp3').then((_) {
                          setState(() {
                            imagenes.remove(data);
                            checkTermination(context);
                          });
                        });
                      } else {
                        reproducirSonido('equivocarse.mp3');
                        equivocarse++;
                        if (equivocarse == 3) {
                          // Reiniciar el contador y cambiar el tipo del chatbot
                          equivocarse = 0;
                          setState(() {
                            mibot = Chatbot_Leccion1(tipo: 2);
                          });
                        }
                      }
                      checkTermination(context);
                    });
                  },
                ),
              ),
              Expanded(
                child: DragTarget<ImagenClasificacion>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: screenHeight / 2,
                      color: Colors.red.shade100,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Silenciosas',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ...silenciosas.map((e) => buildPictograma(e)),
                        ],
                      ),
                    );
                  },
                  onAcceptWithDetails: (DragTargetDetails<dynamic> details) {
                    final data = details.data;
                    setState(() {
                      if (!data.esSonora) {
                        silenciosas.add(data);
                        reproducirSonido('acertar.mp3').then((_) {
                          setState(() {
                            imagenes.remove(data);
                            checkTermination(context);
                          });
                        });
                      } else {
                        reproducirSonido('equivocarse.mp3');
                        equivocarse++;
                        if (equivocarse == 3) {
                          // Reiniciar el contador y cambiar el tipo del chatbot
                          equivocarse = 0;
                          setState(() {
                            mibot = Chatbot_Leccion1(tipo: 2);
                          });
                          
                        }
                      }
                      checkTermination(context);
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1, // Ajusta el tamaño del espacio para el chatbot
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0),
                  alignment: Alignment.center,
                  child: mibot,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(right: 16.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: imagenes.length,
            itemBuilder: (context, index) {
              return Draggable<ImagenClasificacion>(
                data: imagenes[index],
                feedback: Material(
                  child: Opacity(
                    opacity: 0.7,
                    child: buildPictograma(imagenes[index]),
                  ),
                ),
                childWhenDragging: Container(),
                child: Card(
                  elevation: 4.0,
                  color: Colors.white,
                  child: buildPictograma(imagenes[index]),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

  Widget buildPictograma(ImagenClasificacion imagenClasificacion) {
    return Container(
      color: Colors.white, // Fondo blanco
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/${imagenClasificacion.imagen}',
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 4.0),
          Text(
            imagenClasificacion.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 8.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Función para cambiar el tipo del chatbot
  
  Future reproducirSonido(String assetPath) async {
    if (audioPlayer.state != PlayerState.playing) {
      await audioPlayer.play(AssetSource(assetPath));
    } else {
      await audioPlayer2.play(AssetSource(assetPath));
    }
  }

  void checkTermination(BuildContext context) {
    Future.delayed(const Duration(seconds: 1));
    if (imagenes.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FelicidadesFinalScreen()),
      );
    }
  }
}

class FelicidadesFinalScreen extends StatefulWidget {
  const FelicidadesFinalScreen({super.key});
  @override
  FelicidadesFinalScreenState createState() => FelicidadesFinalScreenState();
}

class FelicidadesFinalScreenState extends State<FelicidadesFinalScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();

  void reproducirSonido(String assetPath) async {
    if (audioPlayer.state != PlayerState.playing) {
      await audioPlayer.play(AssetSource(assetPath));
    } else {
      await audioPlayer2.play(AssetSource(assetPath));
    }
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.play(AssetSource('aplausos.mp3'));
    audioPlayer2.play(AssetSource('trompeta.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Liberar recursos del AudioPlayer
    super.dispose();
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
            const Icon(
              Icons.star,
              size: 100,
              color: Colors.yellow,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Felicidades, terminaste la lección 1',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '¡Te has ganado una estrellita!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatbotEmocionesFinalScreen()),
                );
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatbotEmocionesFinalScreen extends StatefulWidget {
  const ChatbotEmocionesFinalScreen({super.key});
  @override
  ChatbotEmocionesFinalScreenState createState() =>
      ChatbotEmocionesFinalScreenState();
}

class ChatbotEmocionesFinalScreenState
    extends State<ChatbotEmocionesFinalScreen> {
  String sentimiento = "default";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }
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
  List<LeccionM> setupLeccion(int leccionId, bool completed, String sentimiento) {
    LeccionM leccion = LeccionM(
        leccionId: leccionId,
        completed: completed,
        sentimiento: sentimiento);

    List<LeccionM> leccionList = [];
    leccionList.add(leccion);
    return leccionList;
  }
  User setupLeccionforsave(List<LeccionM> lecciones, int userId, String email,
      String password, String userType, int edad) {
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
              onPressed: sentimiento == "default" ? null : () {
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

class ImagenClasificacion {
  final String titulo;
  final String imagen;
  final bool esSonora;

  ImagenClasificacion(this.titulo, this.imagen, this.esSonora);
}

class Pictograma {
  final String titulo;
  final String sonido;
  final String imagen;
  final String animacion;

  Pictograma(this.titulo, this.sonido, this.imagen, this.animacion);
}

