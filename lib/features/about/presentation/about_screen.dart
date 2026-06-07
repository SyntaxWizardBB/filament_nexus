import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wer sind wir?')),
      body: Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Wir sind zwei Studenten im Studiungang "Informatiker HF" mit Schwerpunkt auf Softwareentwicklung. Diese App ist im Rahmen einer Transferarbeit im Fach "Mobile Apps" entstanden und wurde aus den Wireframes aus dem vorangegangenen Semester entwickelt.',
          ),
        ),
      ),
    );
  }
}
