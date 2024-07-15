import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypetapp/screens/qrcode.dart';

final storage = const FlutterSecureStorage();

class ImageUploadService {
  Future<http.Response> uploadImage({
    required File imageFile,
    required String name,
    required String type,
    required String gender,
    required String age,
    required String color,
    required String address,
    required String token,
    required String userID,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/add-pet');

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });
    request.fields.addAll({
      'user_id': userID,
      'name': name,
      'type': type,
      'gender': gender,
      'age': age,
      'color': color,
      'address': address,
    });

    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to add pet: ${response.reasonPhrase}');
    }
  }
}

class AddPetPage extends StatefulWidget {
  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  final ImageUploadService _imageUploadService = ImageUploadService();

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> addPet() async {
    if (_imageFile == null) {
      _showError('Please select an image.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? token = await storage.read(key: 'token');

      if (token == null) {
        _showError('Token not found');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      var response = await _imageUploadService.uploadImage(
        imageFile: _imageFile!,
        name: nameController.text,
        type: typeController.text,
        gender: genderController.text,
        age: ageController.text,
        color: colorController.text,
        address: addressController.text,
        userID: userIdController.text,
        token: token,
      );

      if (response.statusCode == 201) {
        _showSuccess('Pet added successfully');
      } else {
        var responseBody = jsonDecode(response.body);
        _showError('Error: ${response.reasonPhrase}, Response Body: $responseBody');
      }
    } catch (e) {
      _showError('Error during image upload: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Pet',
          style: TextStyle(color: Color.fromARGB(255, 69, 129, 95)),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 222, 232),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _selectImage,
                child: _imageFile == null
                    ? const Text(
                        'Upload Image',
                        style: TextStyle(color: Color.fromARGB(255, 248, 237, 241), fontSize: 17),
                        
                      )
                    : const Text('Image Selected',),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 147, 177, 148),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(label: 'User ID', controller: userIdController),
              const SizedBox(height: 10),
              _buildTextField(label: 'Name', controller: nameController),
              const SizedBox(height: 10),
              _buildTextField(label: 'Type', controller: typeController),
              const SizedBox(height: 10),
              _buildTextField(label: 'Gender', controller: genderController),
              const SizedBox(height: 10),
              _buildTextField(label: 'Age', controller: ageController),
              const SizedBox(height: 10),
              _buildTextField(label: 'Color', controller: colorController),
              const SizedBox(height: 10),
              _buildTextField(label: 'Address', controller: addressController),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodePage()));

                      },
                      child: const Text(
                        'QR Code',
                        style: TextStyle(color: Color.fromARGB(255, 69, 129, 95)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 249, 222, 232),
                      ),
                    ),
              ElevatedButton(
                onPressed: addPet,
                child: const Text(
                  'Add Pet',
                  style: TextStyle(color: Color.fromARGB(255, 69, 129, 95)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 249, 222, 232),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 69, 129, 95)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}






