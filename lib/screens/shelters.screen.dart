import 'package:flutter/material.dart';
import 'package:mypetapp/providers/api_service.dart';

class ShelterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shelters'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchShelters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No shelters available'));
          } else {
            final shelters = snapshot.data!;
            return ListView.builder(
              itemCount: shelters.length,
              itemBuilder: (context, index) {
                final shelter = shelters[index];
                return ListTile(
                  title: Text(shelter['name']),
                  subtitle: Text(shelter['address']),
                );
              },
            );
          }
        },
      ),
    );
  }
}