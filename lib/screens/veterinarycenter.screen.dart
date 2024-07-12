import 'package:flutter/material.dart';
import 'package:mypetapp/providers/api_service.dart';
import '../models/veterinary_center.dart';
import 'veterinary_center_detail_page.dart';

class VeterinaryCenterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinary Centers'),
        backgroundColor: Color.fromARGB(255, 233, 134, 171),
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
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
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    center.address,
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Phone: ${center.phoneNumber}',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'City: ${center.city}',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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


