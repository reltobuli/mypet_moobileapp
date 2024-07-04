import 'package:flutter/material.dart';
import 'package:mypetapp/screens/addpet.screen.dart';
import 'package:mypetapp/screens/reportmissingpet.screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '/Users/raghad/Desktop/mypetapp/assets/pawssss.png',
              height: 57,
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
      body: Center(
        child: Column(
          children: [

           
            Container(
              padding: EdgeInsets.only(top:100, right:200),
              margin: EdgeInsets.all(20),
              color: Color.fromARGB(255, 255, 253, 253),
              child: Image.asset('/Users/raghad/Desktop/mypetapp/assets/dogre.png',
               height: 100, 
               fit: BoxFit.fill,
              )
            ),
          Text('find pets to adopt'),
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ReportMissingPetPage()));},
           child: Text('click here')),
       
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => AddpetPage()));},
           child: Text('add pet'))
          
          ],
            )
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