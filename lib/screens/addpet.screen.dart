import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mypetapp/screens/boarding.screen.dart';

class AddpetPage extends StatelessWidget {
  AddpetPage({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
 

  Future<void> _addPet(BuildContext context) async {
    final Uri uri = Uri.parse('http://127.0.0.1:8006/api/Petowner/add-pet');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 5|J0JzOhrRtQdoe5aFKmZIE7Xx35ZRpni60mnowvzF3a164269',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'type': typeController.text.trim(),
          'gender':genderController.text.trim(),
          'age': int.parse(ageController.text.trim()),
          'color':colorController.text.trim(),
          'address':addressController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BoardingPage()));
        print('Pet added successfully');
      } else {
        print('Failed to add pet: ${response.body}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Failed'),
            content: Text('Invalid input: ${response.body}'),
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
      print('Error during addpet: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while adding the pet. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(BoardingPage());
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48),
        ],
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
                      'ADD PET',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 133, 125),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        '/Users/raghad/Desktop/mypetapp/assets/puppy-removebg-preview.png',
                        height: 70,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 190),
                      Image.asset(
                        '/Users/raghad/Desktop/mypetapp/assets/catt-removebg-preview.png',
                        height: 60,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_a_photo, color: Color.fromARGB(255, 3, 133, 125)),
                      SizedBox(width: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 133, 125),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'Name', controller: nameController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                    child: _buildTextField(label: 'Type', controller: typeController), 
                     ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'Gender', controller: genderController),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(label: 'Age', controller: ageController),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'address', controller: addressController),
                      ),
                  
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _addPet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 3, 133, 125),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            minimumSize: const Size(10, 10),
                          ),
                          child: const Text('Add', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static Widget _buildTextField({required String label, required TextEditingController controller}) {
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




