import 'package:cloud_firestore/cloud_firestore.dart';

class LeccionM {
  int leccionId;
  bool completed;
  String sentimiento;

  LeccionM({
    required this.leccionId,
    required this.completed,
    required this.sentimiento,
  });

  // Convert a LeccionM object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'leccion_id': leccionId,
      'completed': completed,
      'sentimiento': sentimiento,
    };
  }

  // Create a LeccionM object from a JSON object
  factory LeccionM.fromJson(Map<String, dynamic> json) {
    return LeccionM(
      leccionId: json['leccion_id'],
      completed: json['completed'],
      sentimiento: json['sentimiento'],
    );
  }

  
}
