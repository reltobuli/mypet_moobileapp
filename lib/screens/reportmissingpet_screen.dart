import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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
  }) async {
    final url = Uri.parse('http://127.0.0.1:8005/api/Petowner/report-missing-pet'); // Replace with your actual API endpoint

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type':'multipart/form-data',
    });
    request.fields.addAll({
     
      'name': name,
      'type': type,
      'gender': gender,
      'age': age,
      'color': color,
      'address': address,
      'qrcode': qrCode,
    });

    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'), // Adjust content type based on your image type
    ));

    final streamedResponse = await request.send();
    print(
      'Response status: ${streamedResponse.statusCode}\n'
      'Response body: ${await streamedResponse.stream.bytesToString()}',
    );
    return await http.Response.fromStream(streamedResponse);
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
  final TextEditingController qrCodeController = TextEditingController();

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
      var response = await _imageUploadService.uploadImage(
        imageFile: _imageFile!,
        name: nameController.text,
        type: typeController.text,
        gender: genderController.text,
        age: ageController.text,
        color: colorController.text,
        address: addressController.text,
        qrCode: qrCodeController.text,
        token: 'YOUR_BEARER_TOKEN_HERE',
      );

      if (response.statusCode == 200) {
        _showSuccess('Pet reported successfully');
      } else {
        var responseBody = jsonDecode(response.body);
        _showError('Error: ${response.reasonPhrase}, Response Body: $responseBody');
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
        title: Text('Report Missing Pet'),
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
              _buildTextField(label: 'Name', controller: nameController),
              _buildTextField(label: 'Type', controller: typeController),
              _buildTextField(label: 'Gender', controller: genderController),
              _buildTextField(label: 'Age', controller: ageController),
              _buildTextField(label: 'Color', controller: colorController),
              _buildTextField(label: 'Address', controller: addressController),
              _buildTextField(label: 'QR Code', controller: qrCodeController),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: reportMissingPet,
                      child: Text('Report Missing Pet'),
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
  

  




