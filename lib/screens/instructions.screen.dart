// instruction_list_page.dart

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'instruction.dart';

class InstructionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
      ),
      body: FutureBuilder<List<Instruction>>(
        future: fetchInstructions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No instructions available'));
          } else {
            final instructions = snapshot.data!;
            return ListView.builder(
              itemCount: instructions.length,
              itemBuilder: (context, index) {
                final instruction = instructions[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(instruction.title),
                    subtitle: Text(instruction.details),
                    // Add other UI elements as needed
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}