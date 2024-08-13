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