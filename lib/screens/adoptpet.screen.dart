import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class AdoptionPage extends StatefulWidget {
  @override
  _AdoptionPageState createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  bool _isLoading = false;
  List<dynamic> _adoptablePets = [];

  String? _token;

  @override
  void initState() {
    super.initState();
    fetchAdoptablePets();
  }

  Future<void> fetchAdoptablePets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/Petowner/pets/adoptable');
      print('Fetching adoptable pets from: $url');  // Debug print

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final parsed = jsonDecode(response.body);
        List<dynamic> pets = parsed['pets'];

        setState(() {
          _adoptablePets = pets;
        });
      } else {
        // Handle error
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exception
      print("Exception: $e");
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
        title: Text('Adoptable Pets'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _adoptablePets.length,
              itemBuilder: (context, index) {
                var pet = _adoptablePets[index];
                return ListTile(
                  title: Text(pet['name']),
                  subtitle: Text('${pet['type']}, ${pet['age']} years old'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailsPage(pet: pet),
                        ),
                      );
                    },
                    child: Text('Adopt'),
                  ),
                );
              },
            ),
    );
  }
}

class PetDetailsPage extends StatelessWidget {
  final dynamic pet;

  const PetDetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${pet['name']} Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: ${pet['name']}'),
            Text('Type: ${pet['type']}'),
            Text('Age: ${pet['age']} years old'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}