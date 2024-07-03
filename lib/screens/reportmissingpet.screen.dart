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
  File? _imageFile; // Variable to hold the selected image file

  Future<void> reportMissingPet() async {
    final url = Uri.parse('http://127.0.0.1:8006/api/Petowner/report/report-missing-pet'); // Replace with your actual API endpoint

    // Create multipart request for uploading image
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'name': nameController.text,
      'type': typeController.text,
      'gender': genderController.text,
      'age': ageController.text,
      'color': colorController.text,
      'pet_id': petIdController.text,
      'address': addressController.text,
    });

    // Add image file to the request if available
    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('picture', _imageFile!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Pet reported successfully');
      // Handle success actions
    } else {
      print('Error reporting pet: ${response.reasonPhrase}');
      // Handle error cases
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
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
                        ? Text('Select Image')
                        : Text('Image Selected'),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(label: 'Name', controller: nameController),
                  SizedBox(height: 10),
                  _buildTextField(label: 'Type', controller: typeController),
                  SizedBox(height: 10),
                  _buildTextField(label: 'Gender', controller: genderController),
                  SizedBox(height: 10),
                  _buildTextField(label: 'Age', controller: ageController),
                  SizedBox(height: 10),
                  _buildTextField(label: 'Color', controller: colorController),
                  SizedBox(height: 10),
                  _buildTextField(label: 'PetID', controller: petIdController),
                  SizedBox(height: 10),
                  _buildTextField(label: 'Address', controller: addressController),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: reportMissingPet,
                    child: Text('REPORT', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  Text('Your phone number will be displayed if a match is found'),
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
        labelStyle: TextStyle(color: Color.fromARGB(255, 3, 133, 125)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}





