import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Leccion1Screen extends StatelessWidget {
  const Leccion1Screen({super.key});
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lección 1 - Sonido y Silencio'),
      ),
      body: const ModoTeorico(), // Mostrar el modo teórico al inicio de la lección
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
    audioPlayer.dispose(); // Libera los recursos del AudioPlayer al cerrar la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
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
                Image.asset('assets/${pictogramas[index].imagen}',height: 100,width: 100,),
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
                MaterialPageRoute(builder: (context) => const FelicidadesScreen()),
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
                  MaterialPageRoute(builder: (context) => const ClasificacionScreen()),
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
          Row(
            children: [
              Expanded(
                child: DragTarget<ImagenClasificacion>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: screenHeight/2,
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
                              textAlign: TextAlign.center, // Opcional, para centrar el texto dentro del Container
                            ),
                          ),
                          ...sonoras.map((e) => buildPictograma(e)),
                        ],
                      ));
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
                      height: screenHeight/2,
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
                              textAlign: TextAlign.center, // Opcional, para centrar el texto dentro del Container
                            ),
                          ),
                          ...silenciosas.map((e) => buildPictograma(e)),
                        ],
                      ));
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
                      }
                      checkTermination(context);
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
        Image.asset('assets/${imagenClasificacion.imagen}', height: 100, width: 100,),
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


  Future reproducirSonido(String assetPath) async {
    if(audioPlayer.state!= PlayerState.playing){
      await audioPlayer.play(AssetSource(assetPath));
    }else{
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
    if(audioPlayer.state!= PlayerState.playing){
      await audioPlayer.play(AssetSource(assetPath));
    }else{
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
    final dynamic Function()? marcarLeccion1Completada = ModalRoute.of(context)!.settings.arguments as dynamic Function()?;
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
                marcarLeccion1Completada?.call();
                Navigator.pushNamed(
                context,
                "/",
                arguments: true,
              );
              },
              child: const Text('Volver a lecciones'),
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
