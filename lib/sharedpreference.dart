import 'package:shared_preferences/shared_preferences.dart';

void setUserLoggedIn(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('loggedIn', value);
}

Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return Future.value(prefs.getBool('loggedIn') ?? false);
}
