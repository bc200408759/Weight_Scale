import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WeightHistory {
  // Singleton instance
  static final WeightHistory _instance = WeightHistory._internal();
  factory WeightHistory() => _instance;

  WeightHistory._internal();

  static const String _historyKey = 'weightHistory';

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Load the weight history from SharedPreferences
  List<Map<String, dynamic>> getHistory() {
    final data = _prefs?.getString(_historyKey);
    if (data != null) {
      return List<Map<String, dynamic>>.from(json.decode(data));
    }
    return [];
  }

  // Add a new weight entry for the current date
  Future<void> addWeightEntry(double weight) async {
    final history = getHistory();

    // Calculate the change from the previous entry if it exists
    double? lastWeight = history.isNotEmpty ? history.last['weight'] as double : null;
    double change = lastWeight != null ? weight - lastWeight : 0;

    // Create a new entry with current date
    final newEntry = {
      'date': DateTime.now().toIso8601String(),
      'weight': weight,
      'change': change,
    };

    // Add the new entry and save the updated history
    history.add(newEntry);
    await _prefs?.setString(_historyKey, json.encode(history));
  }
  
 // Method to print all weight history entries
  void printWeightHistory() {
    final history = getHistory();
    for (var entry in history) {
      print('Date: ${entry['date']}, Weight: ${entry['weight']} Kg, Change: ${entry['change']} Kg');
    }
  }

  // Clear the history (for debugging/testing purposes)
  Future<void> clearHistory() async {
    await _prefs?.remove(_historyKey);
  }
}
