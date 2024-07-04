import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8006/api/Petowner/profile'); // Replace with your actual API endpoint and IP address
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 5|J0JzOhrRtQdoe5aFKmZIE7Xx35ZRpni60mnowvzF3a164269', // Replace with your actual token
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['user'];
        setState(() {
          fullnameController.text = data['fullname'] ?? '';
          phoneNumberController.text = data['phone_number'] ?? '';
          dateOfBirthController.text = data['date_of_birth'] ?? '';
          genderController.text = data['gender'] ?? '';
          emailController.text = data['email'] ?? '';
          cityController.text = data['city'] ?? '';
        });
        print('User data fetched successfully: $data');
      } else {
        // Handle error
        print('Error fetching user data: ${response.statusCode} ${response.reasonPhrase}');
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

  Future<void> updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8006/api/Petowner/profile/update'); // Replace with your actual API endpoint and IP address
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 5|J0JzOhrRtQdoe5aFKmZIE7Xx35ZRpni60mnowvzF3a164269', // Replace with your actual token
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
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: fullnameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextField(
                      controller: genderController,
                      decoration: InputDecoration(labelText: 'Gender'),
                    ),
                    TextField(
                      controller: dateOfBirthController,
                      decoration: InputDecoration(labelText: 'Date of Birth'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: cityController,
                      decoration: InputDecoration(labelText: 'City'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}





