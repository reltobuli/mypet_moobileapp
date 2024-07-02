import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InstructionsPage extends StatefulWidget {
  @override
  _InstructionsPageState createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  List<dynamic> instructions = [];

  @override
  void initState() {
    super.initState();
    fetchInstructions();
  }

  Future<void> fetchInstructions() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8005/api/instructions'));

    if (response.statusCode == 200) {
      setState(() {
        instructions = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load instructions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
      ),
      body: ListView.builder(
        itemCount: instructions.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(instructions[index]['title']),
              subtitle: Text(instructions[index]['details']),
            ),
          );
        },
      ),
    );
  }
}
