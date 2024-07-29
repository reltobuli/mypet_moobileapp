import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    required String qrCode,
    required String token,
    required String petId,
    required String phone_number,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/report-missing-pet');

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });
    request.fields.addAll({
      'name': name,
      'type': type,
      'gender': gender,
      'age': age,
      'color': color,
      'address': address,
      'qrcode': qrCode,
      'pet_id': petId,
      'phone_number': phone_number,  // Add phone_number field to the API request.
    });

    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to report missing pet: ${response.reasonPhrase}');
    }
  }
}

class ReportMissingPetPage extends StatefulWidget {
  @override
  _ReportMissingPetPageState createState() => _ReportMissingPetPageState();
}

class _ReportMissingPetPageState extends State<ReportMissingPetPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController petIdController = TextEditingController();
  final TextEditingController qrCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  final ImageUploadService _imageUploadService = ImageUploadService();

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> reportMissingPet() async {
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
        qrCode: qrCodeController.text,
        petId: petIdController.text,
        phone_number: phoneNumberController.text,
        token: token,
      );

      if (response.statusCode == 200) {
        _showSuccess('Pet reported successfully');
      } else {
        _showError('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showError('Error: $e');
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
          'Report Missing Pet',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 124, 61),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255,  4, 133, 8), width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.teal[50],
                  ),
                  child: _imageFile == null
                      ? const Center(child: Text('Tap to Upload Image', style: TextStyle(color: Colors.teal)))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(label: 'Name', controller: nameController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'Type', controller: typeController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'Gender', controller: genderController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'Age', controller: ageController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'Color', controller: colorController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'Address', controller: addressController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'Pet ID', controller: petIdController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'QR Code', controller: qrCodeController),
              const SizedBox(height: 20), 
              _buildTextField(label: 'Phone Number', controller: phoneNumberController),
              const SizedBox(height: 20), 
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: reportMissingPet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 248, 237, 245), // Background color
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        'Report Missing Pet',
                        style: TextStyle(
                          color: Color.fromARGB(255, 7, 79, 41),
                        ),
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
        labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 124, 61)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 3, 124, 61)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 3, 124, 61)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}




  




