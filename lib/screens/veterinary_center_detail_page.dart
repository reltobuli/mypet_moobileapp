import 'package:flutter/material.dart';
import '../models/veterinary_center.dart';

class VeterinaryCenterDetailPage extends StatelessWidget {
  final VeterinaryCenter center;

  const VeterinaryCenterDetailPage({Key? key, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(center.name, 
        style:const TextStyle(
           fontFamily: 'trojanpro',
           fontSize: 20,
                  color: Color.fromARGB(255, 3, 124, 61),
                ),
        ) ,
        backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 40, right: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                center.name,
                style: const TextStyle(
                  fontFamily: 'trojanpro',
                  fontSize: 24,
                  color: Color.fromARGB(255, 3, 124, 61),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Address: ${center.address}',
                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone: ${center.phoneNumber}',
                    style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    'Rating: ${center.rating}',
                    style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 237, 241),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Additional Information: This center provides a wide range of veterinary services.',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              const SizedBox(height: 60),
              // Scrollable Image Gallery
              const Text(
                'Images:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200, // Adjust height as needed
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [ 
                    Image.asset(
                      '/Users/raghad/Desktop/mypetapp/assets/vet.jpg', // Replace with your image URLs
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      '/Users/raghad/Desktop/mypetapp/assets/vetcenter.jpg', // Replace with your image URLs
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      '/Users/raghad/Desktop/mypetapp/assets/hall.jpg', // Replace with your image URLs
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    // Add more images as needed
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



