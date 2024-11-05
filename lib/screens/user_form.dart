import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_preferences.dart'; // Import your UserProfile class file

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _startWeightController = TextEditingController();

  // Initialize UserPreferences instance
  final UserPreferences _userPreferences = UserPreferences();

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    await _userPreferences.init();
  }

  Future<void> _saveUserData() async {
    await _userPreferences.setName(_nameController.text);
    await _userPreferences.setCurrentWeight(double.parse(_weightController.text));
    await _userPreferences.setHeight(double.parse(_heightController.text));
    await _userPreferences.setAge(int.parse(_ageController.text));
    await _userPreferences.setGender(_genderController.text);
    await _userPreferences.setTargetWeight(double.parse(_targetWeightController.text));
    await _userPreferences.setStartWeight(double.parse(_startWeightController.text));

    Navigator.of(context).pushReplacementNamed('/home'); // Navigate to Home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Current Weight (Kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: _targetWeightController,
              decoration: InputDecoration(labelText: 'Target Weight (Kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _startWeightController,
              decoration: InputDecoration(labelText: 'Start Weight (Kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}