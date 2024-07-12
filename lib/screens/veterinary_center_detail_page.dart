import 'package:flutter/material.dart';
import '../models/veterinary_center.dart';

class VeterinaryCenterDetailPage extends StatelessWidget {
  final VeterinaryCenter center;

  const VeterinaryCenterDetailPage({Key? key, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(center.name),
        backgroundColor: Color.fromARGB(255, 233, 134, 171),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              center.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Address: ${center.address}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${center.phoneNumber}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'City: ${center.city}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
             const SizedBox(height: 8),
                                Text(
                                  'rating: ${center.rating}',
                                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                ),
          ],
        ),
      ),
    );
  }
}


