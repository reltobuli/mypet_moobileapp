import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypetapp/screens/addpet.screen.dart';
import 'package:mypetapp/screens/editpetprofile.screen.dart';

final storage = FlutterSecureStorage();

class PetProfilePage extends StatefulWidget {
  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  List<dynamic> pets = []; // List to store pets fetched from API
  bool isLoading = true;
  String error = '';
  String? token; // Variable to store the token

  @override
  void initState() {
    super.initState();
    fetchTokenAndPets(); // Fetch token and pets when the page loads
  }

  Future<void> fetchTokenAndPets() async {
    try {
      // Fetch token from secure storage
      token = await storage.read(key: 'token');
      
      // Fetch pets using the retrieved token
      await fetchPets();
    } catch (e) {
      setState(() {
        error = 'Failed to fetch token: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchPets() async {
    final String apiUrl = 'http://127.0.0.1:8000/api/Petowner/pets';

    if (token == null) {
      setState(() {
        error = 'Token is null. Authentication required.';
        isLoading = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body as a map
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check if the 'pets' key exists in the response data
      if (responseData.containsKey('pets')) {
        setState(() {
          pets = responseData['pets']; // Store the list of pets
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'No pets found in response.';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        error = 'Error fetching pets: ${response.statusCode}';
        isLoading = false;
      });
    }
  }

  void navigateToEditPetPage(int petId) {
    // Navigate to edit pet page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(petId: petId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator while fetching
            : error.isNotEmpty
                ? Text(error) // Display error message if pets couldn't be loaded
                : pets.isEmpty
                    ? Text('No pets found.') // Display message if no pets are available
                    : ListView.builder(
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          var pet = pets[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: pet['picture'] != null
                                    ? NetworkImage('http://127.0.0.1:8000/storage/pictures/${pet['picture']}')
                                    : AssetImage('assets/default_pet_image.png') as ImageProvider,
                              ),
                              title: Text(pet['name']),
                              subtitle: Text('${pet['type']} - ${pet['gender']}'),
                              trailing: Icon(Icons.edit, color: const Color.fromARGB(255, 245, 201, 216)),
                              onTap: () {
                                // Navigate to edit page or view pet details
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
        child: Icon(Icons.add_circle),
        backgroundColor: const Color.fromARGB(255, 237, 196, 210),
      ),
    );
  }
}




