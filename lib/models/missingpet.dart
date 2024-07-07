import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MissingPet {
  final String picture;
  final String name;
  final String type;
  final String gender;
  final String age;
  final String color;
  final String address;
  final String petId;
  final String qrcode;

  MissingPet({
    required this.picture,
    required this.name,
    required this.type,
    required this.gender,
    required this.age,
    required this.color,
    required this.address,
    required this.petId,
    required this.qrcode,
  });

  factory MissingPet.fromJson(Map<String, dynamic> json) {
    return MissingPet(
      picture: json['picture'],
      name: json['name'],
      type: json['type'],
      gender: json['gender'],
      age: json['age'],
      color: json['color'],
      address: json['address'],
      petId: json['pet_id'],
      qrcode: json['qrcode'],
    );
  }
}

class MissingPetsPage extends StatefulWidget {
  @override
  _MissingPetsPageState createState() => _MissingPetsPageState();
}

class _MissingPetsPageState extends State<MissingPetsPage> {
  late Future<List<MissingPet>> missingPets;

  @override
  void initState() {
    super.initState();
    missingPets = fetchMissingPets();
  }

  Future<List<MissingPet>> fetchMissingPets() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8001/api/missing-pets'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['missingPets'];
      List<MissingPet> pets = body.map((dynamic item) => MissingPet.fromJson(item)).toList();
      return pets;
    } else {
      throw Exception('Failed to load missing pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Pets'),
      ),
      body: FutureBuilder<List<MissingPet>>(
        future: missingPets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No missing pets found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                MissingPet pet = snapshot.data![index];
                return ListTile(
                  leading: Image.network('http://127.0.0.1:8001/storage/${pet.picture}'),
                  title: Text(pet.name),
                  subtitle: Text('Type: ${pet.type}\nGender: ${pet.gender}\nAge: ${pet.age}\nColor: ${pet.color}\nAddress: ${pet.address}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

