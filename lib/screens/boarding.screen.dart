import 'package:flutter/material.dart';
import 'package:mypetapp/screens/login.screen.dart';
import 'package:mypetapp/screens/signup.screen.dart';
import 'package:mypetapp/screens/reportmissingpet.screen.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '/Users/raghad/Desktop/mypetapp/assets/pawss.png',
              height: 62,
              fit: BoxFit.fill,
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
      body: Stack(
        children: [
          const Positioned(
            top: 20,
            left: 170,
            child: Text(
              'MyPet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 243, 158, 189),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(40),
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 230, 236),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255), 
                          width: 2, 
                        ),
                        borderRadius: BorderRadius.circular(30), 
                      ),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'Adopt and save their lives!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 3, 133, 125),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Add space between the text and the button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromARGB(255, 3, 133, 125), // Button background color
                            ),
                            child: const Text(
                              'GET STARTED',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 38,
                      child: Image.asset(
                        '/Users/raghad/Desktop/mypetapp/assets/dogre.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 22,
                      child: Image.asset(
                        '/Users/raghad/Desktop/mypetapp/assets/cat.png',
                        height: 70,
                        width: 100,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Space between the two containers
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 3, 133, 125),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255), // Border color
                      width: 2, // Border width
                    ),
                    borderRadius: BorderRadius.circular(30), // Border radius
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Report missing pet',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 244, 255, 254),
                            ),
                          ),
                          SizedBox(width: 10), // Add space between the text and the QR code
                          Icon(Icons.qr_code, color: Color.fromARGB(255, 241, 231, 231), size: 30.0),
                        ],
                      ),
                      const SizedBox(height: 20), // Add space between the text and the button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReportMissingPetPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color.fromARGB(255, 251, 251, 251), // Button background color
                        ),
                        child: const Text(
                          'no QR code? PRESS HERE',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    
                    ],
                  ),
                ),
                 const SizedBox(height: 20), 
                 ElevatedButton  (onPressed:() {  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));},  style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 255, 255, 255),
                          backgroundColor: const Color.fromARGB(255, 3, 133, 125), // Button background color
                        ), child: 
                      Text('login'))
              ],
               
            ),
          ),
        ],
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

