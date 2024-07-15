import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypetapp/screens/login.screen.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  final storage = const FlutterSecureStorage();
  String? _token;

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }
Future<void> _logout(BuildContext context) async {
    await storage.delete(key: 'token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
  Future<void> _fetchToken() async {
    try {
      final token = await storage.read(key: 'token');
      print('Token retrieved: $token'); // Debug print

      setState(() {
        _token = token;
      });

      if (_token != null && _token!.isNotEmpty) {
        fetchUserData(); // Fetch user data if token is available
      } else {
        print('Token is null or empty');
        // Handle case where token is null or empty
      }
    } catch (e) {
      print('Error fetching token: $e');
      // Handle error fetching token
    }
  }

  Future<void> fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/profile'); // Replace with your actual API endpoint
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token', // Use the stored token here
        },
      );

      print('Fetch user data request: ${response.request}');
      print('Fetch user data response status: ${response.statusCode}');
      print('Fetch user data response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['user'];
        print('User data fetched successfully: $data'); // Debug print

        setState(() {
          fullnameController.text = data['fullname'] ?? '';
          phoneNumberController.text = data['phone_number'] ?? '';
          dateOfBirthController.text = data['date_of_birth'] ?? '';
          genderController.text = data['gender'] ?? '';
          emailController.text = data['email'] ?? '';
          cityController.text = data['city'] ?? '';
        });
      } else {
        // Handle error
        print('Error fetching user data: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught during fetchUserData: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/profile/update'); // Replace with your actual API endpoint
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token', // Use the stored token here
        },
        body: jsonEncode({
          'fullname': fullnameController.text,
          'phone_number': phoneNumberController.text,
          'date_of_birth': dateOfBirthController.text,
          'gender': genderController.text,
          'email': emailController.text,
          'city': cityController.text,
          'password': passwordController.text.isEmpty ? null : passwordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Profile updated successfully: $data');
        // Optionally navigate to another screen or show success message
      } else {
        // Error updating profile
        print('Error updating profile: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        title: const Text('Profile',
        style: TextStyle(
          color: Color.fromARGB(255, 9, 123, 13),
         
        ),),
        backgroundColor: Color.fromARGB(255, 248, 237, 241),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                    _buildTextField(
                      controller: fullnameController,
                      labelText: 'Full Name',
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: phoneNumberController,
                      labelText: 'Phone Number',
                      icon: Icons.phone,
                    ),
                    _buildTextField(
                      controller: genderController,
                      labelText: 'Gender',
                      icon: Icons.wc,
                    ),
                    _buildTextField(
                      controller: dateOfBirthController,
                      labelText: 'Date of Birth',
                      icon: Icons.calendar_today,
                    ),
                    _buildTextField(
                      controller: emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                    ),
                    _buildTextField(
                      controller: cityController,
                      labelText: 'City',
                      icon: Icons.location_city,
                    ),
                    _buildTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        child: Text('Update Profile',
                        style: TextStyle(
                          color: Color.fromARGB(255, 9, 123, 13), 
                        ),),
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 18),
                        
                      ),
                    ),
                    const SizedBox(height: 20),
                
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
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
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
     
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        obscureText: obscureText,
      ),
    );
  }
}

