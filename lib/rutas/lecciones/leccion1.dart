import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:test2/chatbot/chatbot_leccion1.dart';
import 'package:test2/rutas/paginasIntermediasLecciones/comotesientes.dart';
import 'package:test2/rutas/paginasIntermediasLecciones/felicidadesPractica.dart';
import 'package:test2/rutas/paginasIntermediasLecciones/felicidadesTeorico.dart';


/// Screen for Lesson 1.
class Leccion1Screen extends StatelessWidget {
  const Leccion1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lección 1 - Sonido y Silencio'),
      ),
      body:
          const ModoTeorico(), // Show the theoretical mode at the beginning of the lesson
    );
  }
}

/// Stateful widget for the theoretical mode.
class ModoTeorico extends StatefulWidget {
  const ModoTeorico({super.key});

  @override
  ModoTeoricoState createState() => ModoTeoricoState();
}

/// State class for the theoretical mode.
class ModoTeoricoState extends State<ModoTeorico> {
  // List of pictograms with their respective data (title, sound, and animation)
  List<Pictograma> pictogramas = [
    Pictograma('vaca', 'vaca.mp3', 'vaca.png', 'vaca.gif'),
    Pictograma('dormir', '', 'dormir.png', 'dormir.gif'),
    Pictograma('auto', 'auto.mp3', 'auto.png', 'auto.gif'),
    Pictograma('silencio', '', 'silencio.png', 'silencio.gif'),
    Pictograma('cantar', 'cantar.mp3', 'cantar.png', 'cantar.gif'),
    Pictograma('meditar', '', 'meditar.png', 'meditar.gif'),
  ];
  // List to track if each pictogram has been touched
  List<bool> tocado = [];
  // Instance of AudioPlayer to play sounds
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    tocado = List<bool>.filled(pictogramas.length, false);
    // Preload sounds when the screen starts
    for (var pictograma in pictogramas) {
      if (pictograma.sonido.isNotEmpty) {
        precargarSonido(pictograma.sonido);
      }
    }
  }

  /// Method to preload a sound.
  void precargarSonido(String assetPath) {
    audioPlayer.setSourceAsset(assetPath);
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Release AudioPlayer resources when closing the screen
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
              maxCrossAxisExtent:
                  200, // Adjust this value according to your needs
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: pictogramas.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    tocado[index] = true; // Mark the card as touched
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
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0), // Space on the left
            alignment: Alignment.center,
            child: Chatbot_Leccion1(
                tipo: 0), // Instance of the Chatbot_Tutorial class
          ),
        ),
      ],
    );
  }

  /// Method to play the sound corresponding to the pictogram.
  void reproducirSonido(int index) async {
    if (pictogramas[index].sonido.isNotEmpty) {
      await audioPlayer.play(AssetSource(pictogramas[index].sonido));
    }
  }

  /// Method to show the animation corresponding to the pictogram.
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
      // Check if the widget is still mounted before navigating
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FelicidadesWidget(
              mensaje: '¡Felicitaciones por completar el modo teórico de la Lección 1!',
              onContinue: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClasificacionScreen()),
                );
              },
            ),
          ),
        );
      }
    });
  }

      });
    }
  }
}

/// A screen widget for classifying images as with sound or without sound.
class ClasificacionScreen extends StatefulWidget {
  const ClasificacionScreen({super.key});

  @override
  ClasificacionScreenState createState() => ClasificacionScreenState();
}

/// The state class for the ClasificacionScreen widget.
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

  /// Builds a pictograma widget for the given [imagenClasificacion].
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

  /// Plays the sound specified by the given [assetPath].
  Future<void> reproducirSonido(String assetPath) async {
    if (audioPlayer.state != PlayerState.playing) {
      await audioPlayer.play(AssetSource(assetPath));
    } else {
      await audioPlayer2.play(AssetSource(assetPath));
    }
  }

  /// Checks if the termination condition is met and navigates to the FelicidadesFinalScreen.
  void checkTermination(BuildContext context) {
    Future.delayed(const Duration(seconds: 1));
    if (imagenes.isEmpty) {
      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FelicidadesFinalWidget(mensaje: '¡Felicidades, terminaste la lección 1!',
                subMensaje: '¡Te has ganado una estrellita!', 
                onContinue: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmocionesFinalWidget(
                          leccionId: 1, // Aquí pasas el ID de la lección actual
                          onSaveComplete: () {
                            //Se devuelve al menu principal
                          },
                        ),
                      ),
                    );
                  },
                )
              ),
      );
    }
  }
}

/// Represents an image classification.
class ImagenClasificacion {
  /// The title of the image classification.
  final String titulo;

  /// The image URL of the image classification.
  final String imagen;

  /// Indicates whether the image classification has sound.
  final bool esSonora;

  /// Creates a new instance of the [ImagenClasificacion] class.
  ImagenClasificacion(this.titulo, this.imagen, this.esSonora);
}

/// Represents a pictogram.
class Pictograma {
  /// The title of the pictogram.
  final String titulo;

  /// The sound URL of the pictogram.
  final String sonido;

  /// The image URL of the pictogram.
  final String imagen;

  /// The animation URL of the pictogram.
  final String animacion;

  /// Creates a new instance of the [Pictograma] class.
  Pictograma(this.titulo, this.sonido, this.imagen, this.animacion);
}
