import 'package:flutter/material.dart';
import 'package:mypetapp/screens/login.screen.dart';
import 'package:mypetapp/screens/signup.screen.dart';
import 'package:mypetapp/screens/reportmissingpet_screen.dart';

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
            const Text(
              'MYPET',
              style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 233, 134, 171)),
            ),
            Image.asset(
              '/Users/raghad/Desktop/mypetapp/assets/catpaws.png',
              height: 40,
              fit: BoxFit.fill,
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
       
      ),
      
      body: Stack(
        children: [
         
          Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      
                      margin: const EdgeInsets.all(40),
                      padding: const EdgeInsets.all(100),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 230, 236),
                        border: Border.all(
                          color:  Color.fromARGB(255, 3, 133, 125), 
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
                      top: 4,
                      left: 41,
                      child: Image.asset(
                        '/Users/raghad/Desktop/mypetapp/assets/dogre.png',
                        height: 100,
                        width: 136,
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
                const SizedBox(height: 0), // Space between the two containers
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(50),
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
              
              ],
               
            ),
          ),
        ],
      ),
      
    );
  }
}

