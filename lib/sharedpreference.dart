import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUserLoggedIn(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('loggedIn', value);
}

Future<bool> isUserLoggedIn(bool bool) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('loggedIn') ?? false;
}