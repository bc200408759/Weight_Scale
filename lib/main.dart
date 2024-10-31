import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home.dart'; // Import HomeTab
import 'screens/bmi.dart';   // Import BmiTab
import 'screens/history.dart'; // Import HistoryTab
import 'screens/user_form.dart'; // Import UserForm
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
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: _checkUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return snapshot.data! ? HomeScreen() : UserForm();
                }
              },
            ),
        '/home': (context) => HomeScreen(),
        '/userForm': (context) => UserForm(),
      },
    );
  }

  Future<bool> _checkUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('name');
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
 String? _name;
  double? _currentWeight;
  double? _height;
  int? _age;
  String? _gender;
  double? _targetWeight;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name');
      _currentWeight = prefs.getDouble('currentWeight');
      _height = prefs.getDouble('height');
      _age = prefs.getInt('age');
      _gender = prefs.getString('gender');
      _targetWeight = prefs.getDouble('targetWeight');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Scale'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${_name ?? "User"}'),
            Text('Current Weight: ${_currentWeight ?? 0} Kg'),
            Text('Height: ${_height ?? 0} cm'),
            Text('Age: ${_age ?? 0} years'),
            Text('Gender: ${_gender ?? "Not specified"}'),
            Text('Target Weight: ${_targetWeight ?? 0} Kg'),
          ],
        ),
      ),
    );
  }



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Weight Scale'),
  //       leading: Builder(
  //         builder: (context) => IconButton(
  //           icon: Icon(Icons.menu), // Menu icon to open the drawer
  //           onPressed: () {
  //             print("object");
  //             Scaffold.of(context).openDrawer(); // Open the drawer
  //           },
  //         ),
  //       ),
  //     ),
      

  //     body: _screens[_selectedIndex], // Display selected screen
  //     bottomNavigationBar: BottomNavigationBar(
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home),
  //           label: 'Home',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.health_and_safety),
  //           label: 'BMI',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.history),
  //           label: 'History',
  //         ),
  //       ],
  //       currentIndex: _selectedIndex, // Highlight selected tab
  //       onTap: _onItemTapped, // Handle tab change
  //     ),
  //     drawer: Drawer(
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         children: <Widget>[
  //           Container(
  //             height: 400, // Fixed height of 400 pixels
  //             child: DrawerHeader(
  //               decoration: BoxDecoration(
  //                 color: Colors.green,
  //               ),
  //               margin: EdgeInsets.zero,
  //               padding: EdgeInsets.zero,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 40),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // First Row: Avatar
  //                     Center(
  //                       child: CircleAvatar(
  //                         radius: 60,
  //                         backgroundColor: Colors.white,
  //                         child: Icon(
  //                           Icons.person,
  //                           size: 60,
  //                           color: Colors.blue,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 15),

  //                     // Second Row: Gender and Age
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               'Gender',
  //                               style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  //                             ),
  //                             SizedBox(height: 5),
  //                             Text(
  //                               "Male", // Placeholder for gender
  //                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               'Age',
  //                               style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  //                             ),
  //                             SizedBox(height: 5),
  //                             Text(
  //                               "22", // Placeholder for age
  //                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: 15),

  //                     // Third Row: Weight and Height
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               'Weight',
  //                               style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  //                             ),
  //                             SizedBox(height: 5),
  //                             Text(
  //                               "90.5 Kg", // Placeholder for weight
  //                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               'Height',
  //                               style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  //                             ),
  //                             SizedBox(height: 5),
  //                             Text(
  //                               "5ft 11In", // Placeholder for height
  //                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.home),
  //             title: Text('Home'),
  //             onTap: () {
  //               Navigator.pop(context); // Close the drawer
  //               _onItemTapped(0); // Navigate to Home
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.health_and_safety),
  //             title: Text('BMI'),
  //             onTap: () {
  //               Navigator.pop(context); // Close the drawer
  //               _onItemTapped(1); // Navigate to BMI
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.history),
  //             title: Text('History'),
  //             onTap: () {
  //               Navigator.pop(context); // Close the drawer
  //               _onItemTapped(2); // Navigate to History
  //             },
  //           ),
  //           Divider(),
  //           ListTile(
  //             leading: Icon(Icons.share),
  //             title: Text('Share App'),
  //             onTap: () {
  //               // Implement share functionality
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.rate_review),
  //             title: Text('Rate App'),
  //             onTap: () {
  //               // Implement rate functionality
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

