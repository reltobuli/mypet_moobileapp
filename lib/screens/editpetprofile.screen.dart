import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

final storage = const FlutterSecureStorage();

class EditPetProfilePage extends StatefulWidget {
  final int petId;

  EditPetProfilePage({required this.petId});

  @override
  _EditPetProfilePageState createState() => _EditPetProfilePageState();
}

class _EditPetProfilePageState extends State<EditPetProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _isLoading = false;
  String? _token;
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchTokenAndPetData();
  }

  Future<void> _fetchTokenAndPetData() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      fetchPetData();
    } else {
      print("Token not found");
    }
  }

  Future<void> fetchPetData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/pets/${widget.petId}');
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
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
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
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $_token'
      ..fields['name'] = nameController.text
      ..fields['type'] = typeController.text
      ..fields['gender'] = genderController.text
      ..fields['age'] = ageController.text
      ..fields['color'] = colorController.text
      ..fields['address'] = addressController.text;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("Pet profile updated successfully");
    } else {
      print("Error: ${response.statusCode}");
      print("Response body: $responseBody");  // Print the response body for debugging

      // Displaying validation errors
      final errorData = jsonDecode(responseBody);
      if (response.statusCode == 422 && errorData is Map) {
        errorData.forEach((field, errors) {
          if (errors is List) {
            for (var error in errors) {
              print('$field: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$field: $error')),
              );
            }
          }
        });
      }
    }
  } catch (e) {
    print("Exception: $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}



  Future<void> giveUpPet() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/pets/${widget.petId}/give-up');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']);
        Navigator.of(context).pop();  // Navigate back after giving up the pet
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        title: const Text(
          'Edit Pet Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 9, 123, 13),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 237, 241),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 241, 192, 210)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _image == null
                          ? Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 253, 253),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _image!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      controller: nameController,
                      labelText: 'Name',
                      icon: Icons.pets,
                    ),
                    _buildTextField(
                      controller: typeController,
                      labelText: 'Type',
                      icon: Icons.pets,
                    ),
                    _buildTextField(
                      controller: genderController,
                      labelText: 'Gender',
                      icon: Icons.wc,
                    ),
                    _buildTextField(
                      controller: ageController,
                      labelText: 'Age',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: colorController,
                      labelText: 'Color',
                      icon: Icons.color_lens,
                    ),
                    _buildTextField(
                      controller: addressController,
                      labelText: 'Address',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updatePetProfile,
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: const Color.fromARGB(255, 248, 237, 241), // Button color
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        child: Text('Update Profile',
                          style: TextStyle(color: Color.fromARGB(255, 9, 123, 13)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: giveUpPet,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        child: Text('Give Up',
                          style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: const Color.fromARGB(255, 248, 237, 241), // Button color
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 147, 177, 148)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 9, 123, 13)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 9, 123, 13)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 9, 123, 13)),
          ),
        ),
      ),
    );
  }
}








