import 'package:flutter/material.dart';
import 'package:mypetapp/screens/addpet.screen.dart';
import 'package:mypetapp/screens/reportmissingpet_screen.dart';
import 'package:mypetapp/screens/profile_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              '/Users/raghad/Desktop/mypetapp/assets/catpaws.png',
              height: 60,
            ),
          ],
        ),
        
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 100, right: 20),
              margin: EdgeInsets.all(20),
              color: Color.fromARGB(255, 255, 253, 253),
              child: Text('Help us find them',
              style: TextStyle(
                fontSize: 40
              ),),
              
              ),
            
            Text('Find pets to adopt'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportMissingPetPage()));
              },
              child: Text('Click here'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => (AddpetPage())));
              },
              child: Text('Add pet'),
            ),
           
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => (EditProfilePage())));
              },
              child: Text(' Profile'),
            ),
          ],
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
}
