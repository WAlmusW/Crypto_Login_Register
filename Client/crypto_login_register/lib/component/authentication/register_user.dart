import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:crypto_login_register/component/cryptography/server_public_key.dart';

class RegisterService {
  static Future<void> registerUser(String username, String password) async {
    try {
      // Replace the URL with your Python server endpoint
      final serverUrl = "http://192.168.100.58:5000/register";

      // Get the device ID using Flutter_UDID
      String deviceId = await FlutterUdid.consistentUdid;

      // Send a request to the Python server to register the user
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'username': username,
          'password': password,
          'device_udid': deviceId
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String serverPublicKey = data['server_public_key'];
        await saveServerPublicKey(serverPublicKey);
        print('User registered successfully');
      } else {
        print('Failed to register user');
      }
    } catch (error) {
      // Handle any exceptions that occur during the process
      print('Error: $error');
    }
  }
}
