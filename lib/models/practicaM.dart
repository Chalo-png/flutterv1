/// Represents a PracticaM object.
///
/// It stores information about a practice session, such as the song ID, the number of correct answers, the success rate, the song speed, how the user felt during the practice, and the time it took to complete the practice.
class PracticaM {
  int songId;
  int cantAciertos;
  double tasaAciertos;
  double songSpeed;
  String sentimiento;
  int secondsToComplete;

  /// Constructs a PracticaM object.
  PracticaM({
    required this.songId,
    required this.cantAciertos,
    required this.tasaAciertos,
    required this.songSpeed,
    required this.sentimiento,
    required this.secondsToComplete,
  });

  /// Converts a PracticaM object into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'song_id': songId,
      'cant_aciertos': cantAciertos,
      'tasa_aciertos': tasaAciertos,
      'song_speed': songSpeed,
      'sentimiento': sentimiento,
      'seconds_to_complete': secondsToComplete,
    };
  }

  /// Creates a PracticaM object from a JSON object.
  factory PracticaM.fromJson(Map<String, dynamic> json) {
    return PracticaM(
      songId: json['song_id'],
      cantAciertos: json['cant_aciertos'],
      tasaAciertos: json['tasa_aciertos'],
      songSpeed: json['song_speed'],
      sentimiento: json['sentimiento'],
      secondsToComplete: json['seconds_to_complete'],
    );
  }
}
