import 'package:flutter/material.dart';
import 'package:mypetapp/providers/api_service.dart'; // Make sure this path is correct
import 'package:mypetapp/screens/instructions_detail_page.dart';
import '../models/instruction.dart';

class InstructionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        title: const Text(
          'Instructions',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 248, 233, 238),
          ),
        ),
        backgroundColor: const  Color.fromARGB(255, 147, 177, 148),
      ),
      body: FutureBuilder<List<Instruction>>(
        future: fetchInstructions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No instructions available'));
          } else {
            final instructions = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.only(top:80,left:20,right:20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75, // Adjust to your liking
              ),
              itemCount: instructions.length,
             itemBuilder: (context, index) {
  final instruction = instructions[index];
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InstructionDetailPage(instruction: instruction),
        ),
      );
    },
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: Text(
                instruction.title,
                style: const TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 3, 98, 6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
               }
            );
          }      
          }
      )
    );
  }
}

