import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class EditProfilePage extends StatefulWidget {
  final int petId;

  EditProfilePage({required this.petId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _isLoading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _fetchTokenAndPetData();
  }

  Future<void> _fetchTokenAndPetData() async {
    final storage = const FlutterSecureStorage();
    _token = await storage.read(key: 'token');
    if (_token != null) {
      fetchPetData();
    } else {
      // Handle token not found error
      print("Token not found");
    }
  }

 Future<void> fetchPetData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/pets/${widget.petId}');
      print('Fetching pet data from: $url');  // Debug print
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          nameController.text = data['name'] ?? '';
          typeController.text = data['type'] ?? '';
          genderController.text = data['gender'] ?? '';
          ageController.text = data['age'].toString() ?? '';
          colorController.text = data['color'] ?? '';
          addressController.text = data['address'] ?? '';
        });
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exception
      print("Exception: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> giveUpPet(int petId) async {
  setState(() {
    _isLoading = true;
  });

  try {
    final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/pets/$petId/give-up');
    print('Giving up pet at: $url');  // Debug print

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      // Adoption status updated successfully
      // Optionally update UI or display success message
    } else {
      // Handle error
      print("Error: ${response.statusCode}");
    }
  } catch (e) {
    // Handle exception
    print("Exception: $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> updatePetProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/pets/profile/update/${widget.petId}');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text,
          'type': typeController.text,
          'gender': genderController.text,
          'age': int.parse(ageController.text),
          'color': colorController.text,
          'address': addressController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success
        print("Pet profile updated successfully");
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exception
      print("Exception: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: typeController,
                          decoration: const InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: genderController,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: ageController,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: colorController,
                          decoration: const InputDecoration(
                            labelText: 'Color',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                        giveUpPet(widget.petId);
                      },
                     child: Text('Give Up'),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: updatePetProfile,
                        child: const Text('Update Profile'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );

    
  }
}



