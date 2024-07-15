import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypetapp/screens/boarding.screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen ({super.key});
  @override
  State<SplashScreen> createState()=> _SplashScreenState();
} 
class _SplashScreenState extends State<SplashScreen>
 with SingleTickerProviderStateMixin {
    @override
    void initState() {
      super.initState();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      Future.delayed(const Duration(seconds: 3),(){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: 
        (_)=> const BoardingPage(),
         ),
         );
      });
    }
    @override
    void dispose(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
      super.dispose();
    }
    @override
    Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 237, 241),
        body:Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Colors.white],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets,
              size:50,
              color:Color.fromARGB(255, 243, 158, 189),
              ),
               Icon(Icons.pets,
              size:50,
              color:Color.fromARGB(255, 243, 158, 189),
              ),
               Icon(Icons.pets,
              size:50,
              color:Color.fromARGB(255, 243, 158, 189),
              ),
              SizedBox(height: 20),       
            ]
          )
        ),
      );

    }
 }