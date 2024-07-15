import 'package:flutter/material.dart';
import 'package:mypetapp/providers/api_service.dart';
import '../models/veterinary_center.dart';
import 'veterinary_center_detail_page.dart';

class VeterinaryCenterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        title: const Text('Veterinary Centers',
        style: TextStyle( fontSize: 30,
        color: Color.fromARGB(255, 248, 237, 241),
        ),),
        backgroundColor: const Color.fromARGB(255, 147, 177, 148),
      ),
      body: FutureBuilder<List<VeterinaryCenter>>(
        future: fetchVeterinaryCenters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No veterinary centers available'));
          } else {
            final centers = snapshot.data!;
            return ListView.builder(
              itemCount: centers.length,
              itemBuilder: (context, index) {
                final center = centers[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 40 , right: 40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VeterinaryCenterDetailPage(center: center),
                        ),
                      );
                    },
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Image.asset(
                              '/Users/raghad/Desktop/mypetapp/assets/cat.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    center.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 9, 123, 13),
                                  
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    center.address,
                                    style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Phone: ${center.phoneNumber}',
                                    style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'City: ${center.city}',
                                    style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 0, 0)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


