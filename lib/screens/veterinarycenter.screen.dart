import 'package:flutter/material.dart';
import 'package:mypetapp/providers/api_service.dart';
import '../models/veterinary_center.dart';


// Import the VeterinaryCenter model
class VeterinaryCenterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinary Centers'),
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
                return ListTile(
                  title: Text(center.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(center.address),
                      Text('Phone: ${center.phoneNumber}'),
                      Text('City: ${center.city}'),
                    ],
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