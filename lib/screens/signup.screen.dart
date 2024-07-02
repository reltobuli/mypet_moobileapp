import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypetapp/screens/boarding.screen.dart';
import 'package:mypetapp/screens/login.screen.dart';
import 'package:mypetapp/screens/home.screen.dart';


class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    final Uri uri = Uri.parse('http://127.0.0.1:8005/api/PetOwner/register');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': firstnameController.text.trim(),
          'date_of_birth': dateOfBirthController.text.trim(),
          'phone_number': phoneController.text.trim(),
          'city': cityController.text.trim(),
          'location': locationController.text.trim(),
          'job': jobController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'password_confirmation': confirmPasswordController.text.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
        print('Registration successful');
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String errorMessage = responseData['message'] ?? 'Unknown error';
        print('Registration failed: $errorMessage');

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Failed'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error during registration: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred during registration. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        actions: [
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
                      'CREATE AN ACCOUNT',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 133, 125),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Full name',
                          controller: firstnameController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          label: 'Date of birth',
                          controller: dateOfBirthController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Phone number',
                          controller: phoneController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          label: 'city',
                          controller: cityController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'location',
                          controller: locationController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          label: 'Job',
                          controller: jobController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Email',
                          controller: emailController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          label: 'Password',
                          controller: passwordController,
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          label: 'Confirm Password',
                          controller: confirmPasswordController,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => register(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 3, 133, 125),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 133, 125),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color.fromARGB(255, 3, 133, 125),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, TextEditingController? controller, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
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





