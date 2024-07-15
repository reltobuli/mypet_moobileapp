import 'package:flutter/material.dart';
import 'package:mypetapp/providers/api_service.dart';

class ShelterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        title: const Text(
          'Shelters',
          style: TextStyle(
   
            fontSize: 30,
            color: Color.fromARGB(255, 248, 237, 241),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 147, 177, 148),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchShelters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No shelters available'));
          } else {
            final shelters = snapshot.data!;
            return ListView.builder(
              itemCount: shelters.length,
              itemBuilder: (context, index) {
                final shelter = shelters[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 40, right: 40),
                  child: GestureDetector(
                    onTap: () {
                      // Add navigation to shelter detail page if needed
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
                          '/Users/raghad/Desktop/mypetapp/assets/cat.png', // Replace with actual image path
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
                                    shelter['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 9, 123, 13),
                                    
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Address: ${shelter['address']}', // Assuming shelter data has phone number
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Phone: ${shelter['phone_number']}', // Assuming shelter data has phone number
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'City: ${shelter['city']}', // Assuming shelter data has city
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 6, 0, 0),
                                    ),
                                  ),
                                   const SizedBox(height: 8),
                                  Text(
                                    'Capacity: ${shelter['capacity']}', // Assuming shelter data has city
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 6, 0, 0),
                                    ),
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
