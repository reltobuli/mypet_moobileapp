import 'package:flutter/material.dart';
import 'package:mypetapp/screens/signup.screen.dart';
import 'package:mypetapp/screens/login.screen.dart';
import '../models/missingpet.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Pawprint',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'impact',
                color: Color.fromARGB(255, 233, 134, 171),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 248, 237, 241),
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
                      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 248, 237, 241),
                        border: Border.all(
                          color: const Color.fromARGB(255, 55, 101, 56),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(
                            child: Text(
                              'Adopt and save their lives!',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'impact',
                                color: Color.fromARGB(255, 55, 101, 56),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromARGB(255, 147, 177, 148),
                            ),
                            child: const Text(
                              'GET STARTED',
                              style: TextStyle(
                                color: Color.fromARGB(255, 248, 237, 241),
                                fontFamily: 'impact',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            child: const Text('Press here ', style: 
                            TextStyle(color: Color.fromARGB(255, 233, 134, 171) ),),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 35,
                      child: Image.asset(
                        '/Users/raghad/Desktop/mypetapp/assets/dogre.png',
                        height: 100,
                        width: 136,
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 25,
                      child: Image.asset(
                        '/Users/raghad/Desktop/mypetapp/assets/cat.png',
                        height: 70,
                        width: 100,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 147, 177, 148),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30),
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
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'impact',
                              color: Color.fromARGB(255, 244, 255, 254),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.qr_code, color: Color.fromARGB(255, 241, 231, 231), size: 30.0),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MissingPetsPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color.fromARGB(255, 251, 251, 251),
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


