import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ReportMissingPetPage extends StatefulWidget {
  const ReportMissingPetPage({Key? key}) : super(key: key);

  @override
  _ReportMissingPetPageState createState() => _ReportMissingPetPageState();
}

class _ReportMissingPetPageState extends State<ReportMissingPetPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController petIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController tagIdController = TextEditingController();
  final TextEditingController qrCodeController = TextEditingController();

  File? _imageFile; // Variable to hold the selected image file
  bool _isLoading = false; // To show loading indicator

  Future<void> reportMissingPet() async {
    print('Starting reportMissingPet');
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://127.0.0.1:8006/api/Petowner/report/report-missing-pet'); // Replace with your actual API endpoint

    // Create multipart request for uploading image
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer 5|J0JzOhrRtQdoe5aFKmZIE7Xx35ZRpni60mnowvzF3a164269',
    });
    request.fields.addAll({
      'name': nameController.text,
      'type': typeController.text,
      'gender': genderController.text,
      'age': ageController.text,
      'color': colorController.text,
      'pet_id': petIdController.text,
      'address': addressController.text,
      'tag_id': tagIdController.text,
      'qrcode': qrCodeController.text,
    });

    // Add image file to the request if available
    if (_imageFile != null) {
      print('Adding image to the request');
      request.files.add(await http.MultipartFile.fromPath('picture', _imageFile!.path));
    }

    try {
      var response = await request.send();
      print('Request sent. Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Pet reported successfully');
        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Pet reported successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        var responseBody = await response.stream.bytesToString();
        print('Error reporting pet: ${response.reasonPhrase}, Response Body: $responseBody');
        // Show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Error reporting pet: ${response.reasonPhrase}, Response Body: $responseBody'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error during request: $e');
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error during request: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        print('Image selected: ${_imageFile!.path}');
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Missing Pet'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'REPORT MISSING PET',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 133, 125),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: _imageFile == null
                        ? const Text('Select Image')
                        : const Text('Image Selected'),
                  ),
                  const SizedBox(height: 20),
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
                  _buildTextField(label: 'Pet ID', controller: petIdController),
                  const SizedBox(height: 10),
                  _buildTextField(label: 'Address', controller: addressController),
                  const SizedBox(height: 10),
                  _buildTextField(label: 'Tag ID', controller: tagIdController),
                  const SizedBox(height: 10),
                  _buildTextField(label: 'QR Code', controller: qrCodeController),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: reportMissingPet,
                          child: const
                               
                       Text('REPORT', style: TextStyle(color: Colors.white)),
                        ),
                ],
              ),
            ),
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




