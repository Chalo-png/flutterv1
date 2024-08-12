import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a lesson model.
class LeccionM {
  /// The ID of the lesson.
  final int leccionId;

  /// Indicates whether the lesson is completed or not.
  final bool completed;

  /// The sentiment associated with the lesson.
  final String sentimiento;

  /// Creates a new instance of the [LeccionM] class.
  ///
  /// The [leccionId], [completed], and [sentimiento] parameters are required.
  LeccionM({
    required this.leccionId,
    required this.completed,
    required this.sentimiento,
  });

  /// Converts a [LeccionM] object into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'leccion_id': leccionId,
      'completed': completed,
      'sentimiento': sentimiento,
    };
  }

  /// Creates a [LeccionM] object from a JSON object.
  factory LeccionM.fromJson(Map<String, dynamic> json) {
    return LeccionM(
      leccionId: json['leccion_id'],
      completed: json['completed'],
      sentimiento: json['sentimiento'],
    );
  }
}
