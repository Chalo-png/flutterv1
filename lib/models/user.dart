import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/models/practicaM.dart';

import 'leccionM.dart';

class User {
  final int id;
  final String email;
  final String password;
  final String userType;
  final List<PracticaM>? practicas;
  final List<LeccionM>? lecciones;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.userType,
    this.practicas,
    this.lecciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'userType': userType,
      'practicas': practicas?.map((p) => p.toJson()).toList(),
      'lecciones': lecciones?.map((l) => l.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      userType: json['userType'],
      practicas: (json['practicas'] as List<dynamic>?)
          ?.map((p) => PracticaM.fromJson(p))
          .toList(),
      lecciones: (json['lecciones'] as List<dynamic>?)
          ?.map((l) => LeccionM.fromJson(l))
          .toList(),
    );
  }
}

Future<void> storeUser(User user) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userDoc = firestore.collection('users').doc(user.id.toString());

  // Get the existing user data
  final snapshot = await userDoc.get();

  if (snapshot.exists) {
    // If user exists, update the practicas and lecciones
    List<dynamic> existingPracticas = snapshot.data()?['practicas'] ?? [];
    List<dynamic> existingLecciones = snapshot.data()?['lecciones'] ?? [];

    // Ensure practicas and lecciones are not null
    if (user.practicas != null) {
      existingPracticas.addAll(user.practicas!.map((p) => p.toJson()));
    }

    if (user.lecciones != null) {
      existingLecciones.addAll(user.lecciones!.map((l) => l.toJson()));
    }

    // Update the user document
    await userDoc.update({
      'practicas': existingPracticas,
      'lecciones': existingLecciones,
    });
  } else {
    // If user does not exist, create a new document
    await userDoc.set(user.toJson());
  }
}
