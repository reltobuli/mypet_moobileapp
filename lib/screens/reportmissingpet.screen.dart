import 'package:flutter/material.dart';
import 'package:mypetapp/screens/boarding.screen.dart';

class ReportMissingPetPage extends StatelessWidget {
  const ReportMissingPetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(BoardingPage());
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
       
        centerTitle: true, // Center the title in the AppBar
        actions: const [ // Adding an empty action widget to balance the leading widget
          SizedBox(width: 48), // Adjust the width to balance the back button
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Adjust padding based on screen width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'REPORT MISSING PET',
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 133, 125),
                        fontSize: 30, // Increased font size
                        fontWeight: FontWeight.bold, // Added font weight
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add_a_photo, color: Color.fromARGB(255, 3, 133, 125)),
                      SizedBox(width: 8),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 133, 125),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // Add spacing below the photo row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'Name'),
                      ),
                      const SizedBox(width: 10), // Add spacing between the boxes
                      Expanded(
                        child: _buildTextField(label: 'Type'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Add spacing between the rows
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'Gender'),
                      ),
                      const SizedBox(width: 10), // Add spacing between the boxes
                      Expanded(
                        child: _buildTextField(label: 'Age'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Add spacing between the rows
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'Color'),
                      ),
                      const SizedBox(width: 10), // Add spacing between the boxes
                      Expanded(
                        child: _buildTextField(label: 'PetID'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Add spacing between the rows
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(label: 'Address'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // Add spacing between the rows
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle add pet button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 133, 125), // Change the button color here
                        padding: const EdgeInsets.only(left: 30, right: 30,top: 10, bottom: 10) ,
                        // Adjust padding
                        minimumSize: const Size(20, 20), // Adjust the size
                      ),
                      child: const Text('REPORT', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Your phone number will be displayed if a match is found ')
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 133, 125)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
