
class PracticaM {
  int id;
  int songId;
  int cantAciertos;
  double tasaAciertos;
  double songSpeed;
  String sentimiento;
  int secondsToComplete;

  PracticaM({
    required this.id,
    required this.songId,
    required this.cantAciertos,
    required this.tasaAciertos,
    required this.songSpeed,
    required this.sentimiento,
    required this.secondsToComplete,
  });

  // Convert a PracticaM object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'song_id': songId,
      'cant_aciertos': cantAciertos,
      'tasa_aciertos': tasaAciertos,
      'song_speed': songSpeed,
      'sentimiento': sentimiento,
      'seconds_to_complete': secondsToComplete,
    };
  }

  // Create a PracticaM object from a JSON object
  factory PracticaM.fromJson(Map<String, dynamic> json) {
    return PracticaM(
      id: json['id'],
      songId: json['song_id'],
      cantAciertos: json['cant_aciertos'],
      tasaAciertos: json['tasa_aciertos'],
      songSpeed: json['song_speed'],
      sentimiento: json['sentimiento'],
      secondsToComplete: json['seconds_to_complete'],
    );
  }
}