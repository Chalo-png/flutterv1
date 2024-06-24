import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/models/practicaM.dart';

import 'leccionM.dart';

class User {
  int id;
  String email;
  String password;
  String userType;
  PracticaM? practica;  // Optional field
  LeccionM? leccion;    // Optional field

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.userType,
    this.practica,
    this.leccion,
  });

  // Convert a User object into a JSON object
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'email': email,
      'password': password,
      'user_type': userType,
    };

    // Add practica if it is not null
    if (practica != null) {
      data['practica'] = practica!.toJson();
    }

    // Add leccion if it is not null
    if (leccion != null) {
      data['leccion'] = leccion!.toJson();
    }

    return data;
  }

  // Create a User object from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      userType: json['user_type'],
      practica: json['practica'] != null
          ? PracticaM.fromJson(json['practica'])
          : null,
      leccion: json['leccion'] != null
          ? LeccionM.fromJson(json['leccion'])
          : null,
    );
  }
}

void storeUser(User user) async {
  // Get a reference to the Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Convert the User object to JSON
  Map<String, dynamic> userJson = user.toJson();

  // Store the JSON object in Firestore
  await firestore.collection('users').doc(user.id.toString()).set(userJson);
}

void main() {
  // Create a PracticaM object
  PracticaM practica = PracticaM(
    id: 1,
    songId: 123,
    cantAciertos: 50,
    tasaAciertos: 0.9,
    songSpeed: 1.0,
    sentimiento: "happy",
    secondsToComplete: 300,
  );

  // Create a LeccionM object
  LeccionM leccion = LeccionM(
    leccionId: 1,
    completed: true,
    sentimiento: "satisfied",
  );

  // Create a User object with optional PracticaM and LeccionM objects
  User user = User(
    id: 1,
    email: "user@example.com",
    password: "securePassword",
    userType: "admin",
    practica: practica,  // Optional practica object
    leccion: leccion,    // Optional leccion object
  );

  // Store the User object in Firestore
  storeUser(user);
}