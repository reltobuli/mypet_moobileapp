import 'package:flutter/material.dart';
import '../models/instruction.dart';

class InstructionDetailPage extends StatelessWidget {
  final Instruction instruction;

  const InstructionDetailPage({Key? key, required this.instruction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          instruction.title,
          style: const TextStyle(
            fontFamily: 'trojanpro',
            fontSize: 20,
            color: Color.fromARGB(255, 3, 124, 61),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 40, right: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                instruction.title,
                style: const TextStyle(
                  fontFamily: 'trojanpro',
                  fontSize: 30,
                  color: Color.fromARGB(255, 3, 124, 61),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,  // Adjust the width as needed
                height: 200,  // Adjust the height as needed
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      instruction.details,
                      style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 237, 241),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Additional Information: Please follow the instructions carefully for the best results.',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              const SizedBox(height: 60),
              // Scrollable Image Gallery
            ],
          ),
        ),
      ),
    );
  }
}

