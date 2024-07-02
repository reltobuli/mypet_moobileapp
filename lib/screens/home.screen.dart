import 'package:flutter/material.dart';
import 'package:mypetapp/screens/addpet.screen.dart';
import 'package:mypetapp/screens/instruction_service.dart';
import 'package:mypetapp/screens/reportmissingpet.screen.dart';
import 'package:mypetapp/screens/instruction_service.screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pet App'),
        backgroundColor: Color.fromARGB(255, 3, 133, 125),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('data'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InstructionsPage()),
                );
              },
              child: Text('View Instructions'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddpetPage()),
                );
              },
              child: Text('Add Pet'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportMissingPetPage()),
                );
              },
              child: Text('Report missing Pet'),
            ),
          ],
        ),
      ),
    );
  }
}