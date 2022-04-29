import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeFromSF({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future<void>  addStringToSF({required String key, required String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<void>  addIntToSF({required String key, required int value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

Future<void>  addDoubleToSF({required String key, required double value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(key, value);
}

Future<void>  addBoolToSF({required String key, required bool value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<String> getStringValuesSF({required String key, String defaultValue = ''}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs != null ? prefs.getString(key) ?? defaultValue : defaultValue;
  return stringValue;
}

Future<bool> getBoolValuesSF({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  bool boolValue = prefs != null ? prefs.getBool(key) ?? false : false;
  return boolValue;
}

Future<int> getIntValuesSF({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int intValue = prefs != null ? prefs.getInt(key) ?? 0 : 0;
  return intValue;
}

Future<double> getDoubleValuesSF({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return double
  double doubleValue = prefs != null ? prefs.getDouble(key) ?? 0.0 : 0.0;
  return doubleValue;
}

