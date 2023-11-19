import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveServerPublicKey(String publicKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('serverPublicKey', publicKey);
}

Future<String?> getServerPublicKey() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('serverPublicKey');
}
