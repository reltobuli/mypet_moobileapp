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
    _getToken().then((_) {
      fetchAdoptablePets();
    });
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
  }

  Future<void> fetchAdoptablePets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/pets/adoptable');
      print('Fetching adoptable pets from: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<dynamic> pets = parsed['pets'];

        setState(() {
          _adoptablePets = pets;
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> sendAdoptionRequest(String petId) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/Petowner/pets/$petId/request-adoption'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'message': 'Your adoption message here',
        }),
      );

      if (response.statusCode == 201) {
        print('Adoption request sent successfully');
      } else {
        print('Failed to send adoption request: ${response.body}');
      }
    } catch (e) {
      print('Exception during adoption request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adoptable Pets',
          style: TextStyle(
            color: Color.fromARGB(255, 3, 124, 61),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 248, 237, 241),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top:60,left:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pets Available for Adoption',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Impact',
                      color: Color.fromARGB(255, 4, 110, 55),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 340, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _adoptablePets.length,
                      itemBuilder: (context, index) {
                        var pet = _adoptablePets[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pet['picture'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Image.network(
                                          'http://127.0.0.1:8000/storage/pictures/${pet['picture']}',
                                          height: 190,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.pets, size: 150);
                                          },
                                        ),
                                      )
                                    : Icon(Icons.pets, size: 150),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pet['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 3, 124, 61),
                                        ),
                                      ),
                                      Text('${pet['type']}, ${pet['age']} years old'),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Confirm Adoption'),
                                              content: Text('Do you want to adopt ${pet['name']}?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    sendAdoptionRequest(pet['id'].toString());
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Confirm'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          'Adopt',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 4, 90, 17),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}




