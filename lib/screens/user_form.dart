import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setDouble('currentWeight', double.parse(_weightController.text));
    await prefs.setDouble('height', double.parse(_heightController.text));
    await prefs.setInt('age', int.parse(_ageController.text));
    await prefs.setString('gender', _genderController.text);
    await prefs.setDouble('targetWeight', double.parse(_targetWeightController.text));

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
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _weightController, decoration: InputDecoration(labelText: 'Current Weight (Kg)'), keyboardType: TextInputType.number),
            TextField(controller: _heightController, decoration: InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number),
            TextField(controller: _ageController, decoration: InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
            TextField(controller: _genderController, decoration: InputDecoration(labelText: 'Gender')),
            TextField(controller: _targetWeightController, decoration: InputDecoration(labelText: 'Target Weight (Kg)'), keyboardType: TextInputType.number),
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
