import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mypetapp/screens/notifaction.screen.dart';
import 'profile_screen.dart';
import 'petprofile.screen.dart';
import 'package:mypetapp/screens/requests.screen.dart'; 
import 'shelters.screen.dart';
import 'veterinarycenter.screen.dart';
import 'instructions.screen.dart';
import '../models/missingpet.dart';
import 'login.screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final storage = const FlutterSecureStorage();

  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    NotificationsPage(),
    PetProfilePage(),
    EditProfilePage(),
    CategoriesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await storage.delete(key: 'token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 237, 241),
      body: _pages[_selectedIndex],
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
            icon: Icon(Icons.pets),
            label: 'My Pet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Categories',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 147, 177, 148),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MissingPet> _missingPets = [];
  List<dynamic> _adoptablePets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMissingPets();
    fetchAdoptablePets();
  }

  Future<void> fetchMissingPets() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/missing-pets'));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body)['missingPets'];
        List<MissingPet> pets = body.map((dynamic item) => MissingPet.fromJson(item)).toList();
        setState(() {
          _missingPets = pets;
        });
      } else {
        throw Exception('Failed to load missing pets: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching missing pets: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchAdoptablePets() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/pets/adoptable'));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        setState(() {
          _adoptablePets = parsed['pets'];
        });
      } else {
        print('Failed to load adoptable pets: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching adoptable pets: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

 

    @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Color.fromARGB(255, 248, 237, 241),
      child: Column(
        children: [
          SizedBox(height: 70),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      _buildSectionTitle(context, 'Missing Pets', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MissingPetsPage()),
                        );
                      }),
                      SizedBox(height: 20),
                      _buildPetList(_missingPets.take(3).toList(), screenWidth),
                      SizedBox(height: 70),
                      _buildSectionTitle(context, 'Adoptable Pets', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdoptionPage()),
                        );
                      }),
                      SizedBox(height: 20),
                      _buildPetList(_adoptablePets.take(3).toList(), screenWidth),
                      SizedBox(height: 20),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
  }

  Widget _buildSectionTitle(BuildContext context, String title, Function() onSeeMore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 92, 3), fontFamily: 'impact'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward, color: Color.fromARGB(255, 17, 90, 6)),
          onPressed: onSeeMore,
        ),
      ],
    );
  }

  Widget _buildPetList(List pets, double screenWidth) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return pets is List<MissingPet>
              ? MissingPetCard(pet: pets[index], screenWidth: screenWidth)
              : AdoptablePetCard(pet: pets[index], screenWidth: screenWidth);
        },
      ),
    );
  }


class MissingPetCard extends StatelessWidget {
  final MissingPet pet;
  final double screenWidth;

  MissingPetCard({required this.pet, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: screenWidth * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context, pet.picture, 'missing-pet-images'),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Text(pet.name, style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 64, 0))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: Text('Type: ${pet.type}\nAge: ${pet.age}', style: 
              TextStyle(
                color:Color.fromARGB(255, 17, 90, 6),
              ),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String? picture, String folder) {
    return picture != null
        ? ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              'http://127.0.0.1:8000/storage/$folder/$picture',
              fit: BoxFit.cover,
              height: 120,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: Icon(Icons.error, color: const Color.fromARGB(255, 232, 232, 232)),
                );
              },
            ),
          )
        : Container(
            height: 100,
            color: Color.fromARGB(255, 17, 90, 6),
            child: Icon(Icons.pets, size: 50, color: Colors.white),
          );
  }
}

class AdoptablePetCard extends StatelessWidget {
  final dynamic pet;
  final double screenWidth;

  AdoptablePetCard({required this.pet, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: screenWidth * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context, pet['picture'], 'pictures'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(pet['name'], style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 64, 0)) ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('${pet['type']}, ${pet['age']} years old',
              style: TextStyle(
                color: Color.fromARGB(255, 17, 90, 6),
              ),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String? picture, String folder) {
    return picture != null
        ? ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              'http://127.0.0.1:8000/storage/$folder/$picture',
              fit: BoxFit.cover,
              height: 140,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          )
        : Container(
            height: 120,
            color: Color.fromARGB(255, 17, 90, 6),
            child: Icon(Icons.pets, size: 50, color: Colors.white),
          );
  }
}


class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: Color.fromARGB(255, 248, 237, 241),

      appBar: AppBar(
        title: Text('Categories', style: 
        TextStyle(color:Color.fromARGB(255, 9, 123, 13),
       ),
        ),
        backgroundColor: Color.fromARGB(255, 248, 233, 238),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryCard(
              context,
              Icons.home,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShelterListPage()),
              ),
            ),
            _buildCategoryCard(
              context,
              Icons.local_hospital,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VeterinaryCenterListPage()),
              ),
            ),
            _buildCategoryCard(
              context,
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

  Widget _buildCategoryCard(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(icon, size: 50, color: Color.fromARGB(255, 147, 177, 148)),
        ),
      ),
    );
  }
}


  Widget _buildCategoryCard(BuildContext context, String title, IconData iconData, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Color.fromARGB(255, 249, 222, 232),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 50,
                color: Color.fromARGB(255, 1, 55, 3),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
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










