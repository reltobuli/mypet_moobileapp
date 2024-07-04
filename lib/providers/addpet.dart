import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypetapp/screens/boarding.screen.dart';



class PetProvider with ChangeNotifier {
  Future<void> _addPet(BuildContext context) async {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController();

    final Uri uri = Uri.parse('http://127.0.0.1:8005/api/Petowner/add-pet');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 5|J0JzOhrRtQdoe5aFKmZIE7Xx35ZRpni60mnowvzF3a164269',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'age': int.parse(ageController.text.trim()),
          'type': typeController.text.trim(),
          'owner_id': int.parse(ownerIdController.text.trim()),
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
}