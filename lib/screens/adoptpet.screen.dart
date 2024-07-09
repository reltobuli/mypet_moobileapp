// lib/pages/adopt_pet_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdoptPetPage extends StatefulWidget {
  @override
  _AdoptPetPageState createState() => _AdoptPetPageState();
}

class _AdoptPetPageState extends State<AdoptPetPage> {
  List pets = [];

  @override
  void initState() {
    super.initState();
    fetchAdoptablePets();
  }

  Future<void> fetchAdoptablePets() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/pets/adoptable'),
      headers: {
        'Authorization': 'Bearer your-token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        pets = json.decode(response.body);
      });
    } else {
      // Error handling
    }
  }

  Future<void> requestAdoption(int petId) async {
    final response = await http.post(
      Uri.parse('https://your-laravel-app.com/api/pets/$petId/request-adoption'),
      headers: {
        'Authorization': 'Bearer your-token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Success
    } else {
      // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt Pet'),
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pets[index]['name']),
            subtitle: Text(pets[index]['breed']),
            trailing: ElevatedButton(
              onPressed: () => requestAdoption(pets[index]['id']),
              child: Text('Adopt'),
            ),
          );
        },
      ),
    );
  }
}
