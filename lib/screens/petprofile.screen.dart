import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypetapp/screens/addpet.screen.dart';
import 'package:mypetapp/screens/editpetprofile.screen.dart';

final storage = const FlutterSecureStorage();

class PetProfilePage extends StatefulWidget {
  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  List<dynamic> pets = [];
  bool isLoading = true;
  String error = '';
  String? token;

  @override
  void initState() {
    super.initState();
    fetchTokenAndPets();
  }

  Future<void> fetchTokenAndPets() async {
    try {
      token = await storage.read(key: 'token');
      await fetchPets();
    } catch (e) {
      setState(() {
        error = 'Failed to fetch token: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchPets() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/pets/user';

    if (token == null) {
      setState(() {
        error = 'Token is null. Authentication required.';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          pets = responseData['pets'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Error fetching pets: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Exception caught during fetchPets: $e';
        isLoading = false;
      });
    }
  }

  void navigateToEditPetPage(int petId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetProfilePage(petId: petId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        title: const Text(
          'My Pets',
          style: TextStyle(
            color:  Color.fromARGB(255, 9, 123, 13), 
          
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : error.isNotEmpty
                ? Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  )
                : pets.isEmpty
                    ? const Text(
                        'No pets found.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 147, 177, 148),
                        ),
                      )
                    : ListView.builder(
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          var pet = pets[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: pet['picture'] != null
                                    ? NetworkImage('http://127.0.0.1:8000/storage/pictures/${pet['picture']}')
                                    : const AssetImage('assets/default_pet_image.png') as ImageProvider,
                              ),
                              title: Text(
                                pet['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 9, 123, 13),
                                ),
                              ),
                              subtitle: Text('${pet['type']} - ${pet['gender']}'),
                              trailing: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 147, 177, 148),
                              ),
                              onTap: () {
                                navigateToEditPetPage(pet['id']);
                              },
                            ),
                          );
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPetPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 247, 219, 228),
      ),
    );
  }
}









