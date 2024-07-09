import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mypetapp/screens/home.screen.dart';
import 'package:mypetapp/screens/signup.screen.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

Future<void> _login(BuildContext context, String email, String password) async {
  final Uri uri = Uri.parse('http://127.0.0.1:8000/api/Petowner/login');

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Successful login
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final userId = responseData['user']['id']; // Retrieve user ID

      // Save token and user ID to secure storage
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'userId', value: userId.toString());

      // Navigate to home screen or profile page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      print('Login successful');
    } else {
      // Handle login failure
      print('Login failed: ${response.body}');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text('Invalid username or password: ${response.body}'),
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
    print('Error during login: $e');
    // Handle error, e.g., show error message to user
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Color.fromARGB(255, 3, 133, 125),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildTextField(label: 'email', controller: emailController),
              const SizedBox(height: 20),
              _buildTextField(label: 'Password', controller: passwordController, obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _login(context, emailController.text, passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 246, 255, 254),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 133, 125)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 3, 133, 125)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}






