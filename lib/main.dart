import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_preferences.dart'; // Import your UserPreferences class
import 'screens/home.dart'; // Import HomeTab
import 'screens/bmi.dart';   // Import BmiTab
import 'screens/history.dart'; // Import HistoryTab
import 'screens/user_form.dart'; // Import UserForm
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init(); // Initialize SharedPreferences
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

  // User data variables
  double? _currentWeight;
  double? _height;
  int? _age;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userPrefs = UserPreferences();
    setState(() {
      _currentWeight = userPrefs.currentWeight;
      _height = userPrefs.height;
      _age = userPrefs.age;
      _gender = userPrefs.gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5DD75B),
        title: Text(
          'Weight Scale',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/home.svg',
              color: _selectedIndex == 0 ? Color(0xFF5DD75B) : Color(0xFF959595),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/bmi.svg',
              color: _selectedIndex == 1 ? Color(0xFF5DD75B) : Color(0xFF959595),
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/history.svg',
              color: _selectedIndex == 2 ? Color(0xFF5DD75B) : Color(0xFF959595),
            ),
            label: ' ',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 370,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF48BA46),
                      Color.fromARGB(255, 87, 225, 85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(137 * 3.1415926535897932 / 180),
                  ),
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Gender',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${_gender ?? "Not specified"}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Age',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${_age ?? "Not specified"}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Weight',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${_currentWeight ?? "Not specified"}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Height',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${_height ?? "Not specified"}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: SvgPicture.asset('assets/home.svg'),
              title: Text(
                'Home',
                style: TextStyle(
                  color: Color(0xFF524F4F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/star.svg'),
              title: Text(
                'Bmi',
                style: TextStyle(
                  color: Color(0xFF524F4F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text(
                'History',
                style: TextStyle(
                  color: Color(0xFF524F4F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
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

