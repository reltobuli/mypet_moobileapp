import 'package:flutter/material.dart';

class GiveUpPetPage extends StatelessWidget {
 // final ApiService apiService = ApiService();
  final int petId;

  GiveUpPetPage({required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Give Up Pet'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
          //    await apiService.giveUpPet(petId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pet is now available for adoption.')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to give up pet.')),
              );
            }
          },
          child: Text('Give Up Pet'),
        ),
      ),
    );
  }
}

