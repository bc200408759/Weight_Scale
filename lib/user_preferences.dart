import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Singleton pattern for accessing the class instance
  static final UserPreferences _instance = UserPreferences._internal();
  factory UserPreferences() => _instance;

  UserPreferences._internal();

  // Keys for storing preferences
  static const String _nameKey = 'name';
  static const String _currentWeightKey = 'currentWeight';
  static const String _heightKey = 'height';
  static const String _ageKey = 'age';
  static const String _genderKey = 'gender';
  static const String _targetWeightKey = 'targetWeight';
  static const String _startWeightKey = 'startWeight';

  SharedPreferences? _prefs;

  // Initialize SharedPreferences instance
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getters
  String? get name => _prefs?.getString(_nameKey);
  double? get currentWeight => _prefs?.getDouble(_currentWeightKey);
  double? get height => _prefs?.getDouble(_heightKey);
  int? get age => _prefs?.getInt(_ageKey);
  String? get gender => _prefs?.getString(_genderKey);
  double? get targetWeight => _prefs?.getDouble(_targetWeightKey);
  double? get startWeight => _prefs?.getDouble(_startWeightKey);

  // Setters
  Future<void> setName(String value) async => await _prefs?.setString(_nameKey, value);
  Future<void> setCurrentWeight(double value) async => await _prefs?.setDouble(_currentWeightKey, value);
  Future<void> setHeight(double value) async => await _prefs?.setDouble(_heightKey, value);
  Future<void> setAge(int value) async => await _prefs?.setInt(_ageKey, value);
  Future<void> setGender(String value) async => await _prefs?.setString(_genderKey, value);
  Future<void> setTargetWeight(double value) async => await _prefs?.setDouble(_targetWeightKey, value);
  Future<void> setStartWeight(double value) async => await _prefs?.setDouble(_startWeightKey, value);

  // Clear all preferences
  Future<void> clearPreferences() async => await _prefs?.clear();
}
