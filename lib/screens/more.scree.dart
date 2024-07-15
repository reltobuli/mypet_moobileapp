import 'package:flutter/material.dart';
import 'veterinarycenter.screen.dart';
import 'instructions.screen.dart';
import 'shelters.screen.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     
      backgroundColor:Color.fromARGB(255, 248, 237, 241),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryCard(
              context,
              'Shelters',
              Icons.home,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShelterListPage()),
              ),
            ),
            _buildCategoryCard(
              context,
              'Vet Centers',
              Icons.local_hospital,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VeterinaryCenterListPage()),
              ),
            ),
            _buildCategoryCard(
              context,
              'Instructions',
              Icons.help,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InstructionListPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData iconData, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8, // Shadow effect for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        color: Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 50,
                color: const Color.fromARGB(255, 1, 55, 3),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 55, 3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
