
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:math";

class GeneraMelodiaScreen extends StatefulWidget {
  @override
  _GeneraMelodiaScreenState createState() => _GeneraMelodiaScreenState();
}
var notes = ["C", "D", "E", "F", "G", "A", "B"];
var duration = [1,2,4];

class _GeneraMelodiaScreenState extends State<GeneraMelodiaScreen> {
  String selectedDifficulty = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genera Melodia'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecciona dificultad',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DifficultyButton(
              text: 'Fácil',
              color: Colors.green,
              isSelected: selectedDifficulty == 'Fácil',
              onTap: () {
                setState(() {
                  selectedDifficulty = 'Fácil';
                });
              },
            ),
            DifficultyButton(
              text: 'Medio',
              color: Colors.orange,
              isSelected: selectedDifficulty == 'Medio',
              onTap: () {
                setState(() {
                  selectedDifficulty = 'Medio';
                });
              },
            ),
            DifficultyButton(
              text: 'Difícil',
              color: Colors.red,
              isSelected: selectedDifficulty == 'Difícil',
              onTap: () {
                setState(() {
                  selectedDifficulty = 'Difícil';
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle confirmation action
                int diff = selectedDifficulty=="Fácil"? 0 : selectedDifficulty=="Medio" ? 1 : 2;
                print(diff);
                int octaveAmount = 4;
                int octaveDuration = 4;
                var data = <Map>[];
                for (var i = 0; i < octaveAmount; i++) {
                  int localOctave = octaveDuration;
                  while (localOctave!=0){
                    final r = Random();
                    int localDuration = duration[r.nextInt(duration.length)];
                    while(localOctave-localDuration<0){
                      localDuration = duration[r.nextInt(duration.length)];
                    }
                    var localNote = {
                      'note': notes[r.nextInt(notes.length)]+"4",
                      'duration': localDuration,
                    };
                    data.add(localNote);
                    localOctave-=localDuration;
                  }
                }
                print(data);
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  DifficultyButton({required this.text, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : Colors.grey),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}