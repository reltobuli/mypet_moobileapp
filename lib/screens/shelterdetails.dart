import 'package:flutter/material.dart';

class ShelterDetailPage extends StatelessWidget {
  final Map<String, dynamic> shelter;

  const ShelterDetailPage({Key? key, required this.shelter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          shelter['name'],
          style: const TextStyle(
            fontFamily: 'trojanpro',
            fontSize: 20,
            color: Color.fromARGB(255, 3, 124, 61),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 40, right: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shelter['name'],
                style: const TextStyle(
                  fontFamily: 'trojanpro',
                  fontSize: 24,
                  color: Color.fromARGB(255, 3, 124, 61),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Address: ${shelter['address']}',
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 8),
              Text(
                'Phone: ${shelter['phone_number']}',
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 8),
              Text(
                'City: ${shelter['city']}',
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 8),
              Text(
                'Capacity: ${shelter['capacity']}',
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 237, 241),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Additional Information: This shelter provides a wide range of services for pets.',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'Images:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.asset(
                      '/Users/raghad/Desktop/mypetapp/assets/shelter1.jpg',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      '/Users/raghad/Desktop/mypetapp/assets/shelter2.jpg',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      '/Users/raghad/Desktop/mypetapp/assets/shelter3.jpg',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

