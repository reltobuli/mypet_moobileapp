import 'package:flutter/material.dart';
import 'package:mypetapp/providers/adoptionapis_service.dart'; // Make sure this path is correct

class RequestAdoptionPage extends StatelessWidget {
//  final ApiService apiService = ApiService();
  final int petId;

  RequestAdoptionPage({required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Adoption'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
          //    await apiService.requestAdoption(petId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Adoption request sent.')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to request adoption.')),
              );
            }
          },
          child: Text('Request Adoption'),
        ),
      ),
    );
  }
}
