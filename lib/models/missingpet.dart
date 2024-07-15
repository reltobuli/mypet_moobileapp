import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypetapp/screens/reportmissingpet_screen.dart';

class MissingPet {
  final String? picture;
  final String name;
  final String type;
  final String gender;
  final int age;
  final String color;
  final String address;
  final String petId;
  final String? qrcode;
  final String? phone_number; // Keep this as String?

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
    required this.phone_number,
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
      phone_number: json['phone_number'] != null ? json['phone_number'].toString() : null,
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
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/missing-pets'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body)['missingPets'];
        return body.map((dynamic item) => MissingPet.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load missing pets');
      }
    } catch (e) {
      throw Exception('Failed to load missing pets: $e');
    }
  }

  void reportFound(MissingPet pet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Owner'),
          content: Text('The contact number of the owner is: \nPhone: ${pet.phone_number}'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Missing Pets',
          style: TextStyle(color: Color.fromARGB(255, 9, 123, 13)),
        ),
        backgroundColor: Color.fromARGB(255, 248, 237, 241),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportMissingPetPage()), // Update as needed
              );
            },
          ),
        ],
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
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: pet.picture != null
                              ? NetworkImage('http://127.0.0.1:8000/storage/missing-pet-images/${pet.picture}')
                              : AssetImage('assets/default_pet_image.png') as ImageProvider,
                        ),
                        title: Text(
                          pet.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 3, 124, 61),
                          ),
                        ),
                        subtitle: Text(
                          'Type: ${pet.type}\nGender: ${pet.gender}\nAge: ${pet.age}\nColor: ${pet.color}\nAddress: ${pet.address},',
                          style: TextStyle(color: Color.fromARGB(255, 3, 124, 61)),
                        ),
                        trailing: pet.qrcode != null
                            ? Icon(Icons.qr_code, color: Color.fromARGB(255, 1, 12, 8))
                            : null,
                        isThreeLine: true,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          reportFound(pet);
                        },
                        child: Text('Report Found'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 6, 99, 37),
                          backgroundColor: Color.fromARGB(255, 248, 237, 241),
                        ),
                      ),
                      SizedBox(height: 10), // Add spacing between cards
                    ],
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









