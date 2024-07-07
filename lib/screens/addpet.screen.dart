import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

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
    final url = Uri.parse('http://127.0.0.1:8001/api/Petowner/add-pet');

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
        title: Text('Success'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _selectImage,
                child: _imageFile == null ? Text('Upload Image') : Text('Image Selected'),
              ),
              SizedBox(height: 20),
              _buildTextField(label: 'User ID', controller: userIdController),
              _buildTextField(label: 'Name', controller: nameController),
              _buildTextField(label: 'Type', controller: typeController),
              _buildTextField(label: 'Gender', controller: genderController),
              _buildTextField(label: 'Age', controller: ageController),
              _buildTextField(label: 'Color', controller: colorController),
              _buildTextField(label: 'Address', controller: addressController),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: addPet,
                      child: Text('Add Pet'),
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
        labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 133, 125)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}




