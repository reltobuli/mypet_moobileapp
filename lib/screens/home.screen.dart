import 'package:flutter/material.dart';
import 'package:mypetapp/screens/addpet.screen.dart';
import 'package:mypetapp/screens/reportmissingpet_screen.dart';
import 'package:mypetapp/screens/profile_screen.dart';
import 'package:mypetapp/screens/shelters.screen.dart';
import 'package:mypetapp/screens/veterinarycenter.screen.dart';
import 'package:mypetapp/screens/instructions.screen.dart';
import 'package:mypetapp/screens/qrcode.dart';

import '../models/missingpet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    Center(child: Text('Notifications Page')),
    EditProfilePage(),
    AddPetPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 235, 168, 190)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'My Pet',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 100, right: 20),
            margin: EdgeInsets.all(20),
            color: Color.fromARGB(255, 255, 253, 253),
            child: Text(
              'Help us find them',
              style: TextStyle(fontSize: 40),
            ),
          ),
          SizedBox(height: 30,),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShelterListPage()));
            },
            child: Text('Check shelters'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VeterinaryCenterListPage()));
            },
            child: Text('Check veterinary'),
          ),
           ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MissingPetsPage()));
            },
            child: Text('Check missig pets'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InstructionListPage()));
            },
            child: Text('Check instructions'),
          ),
           ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QRCodePage()));
            },
            child: Text('Generate QRcode'),
          ),
        ],
      ),
    );
  }
}