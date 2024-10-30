import 'package:flutter/material.dart';

import 'screens/home.dart'; // Import HomeTab
import 'screens/bmi.dart';   // Import BmiTab
import 'screens/history.dart'; // Import HistoryTab

import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package

void main() {
  runApp(WeightScaleApp());
}

class WeightScaleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Scale',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Start with the HomeScreen
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // To keep track of the selected tab

  // List of screens
  final List<Widget> _screens = [
    HomeTab(),
    BmiTab(),
    HistoryTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Scale'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu), // Menu icon to open the drawer
            onPressed: () {
              print("object");
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
        ),
      ),
      

      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'BMI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight selected tab
        onTap: _onItemTapped, // Handle tab change
      ),
      drawer: Drawer( // Drawer for side menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name', // Placeholder for user name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'user@example.com', // Placeholder for user email
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _onItemTapped(0); // Navigate to Home
              },
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('BMI'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _onItemTapped(1); // Navigate to BMI
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _onItemTapped(2); // Navigate to History
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
              onTap: () {
                // Implement share functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Rate App'),
              onTap: () {
                // Implement rate functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}

