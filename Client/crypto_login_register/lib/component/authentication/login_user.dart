import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:crypto_login_register/component/cryptography/server_public_key.dart';

class LoginService {
  static Future<void> loginUser(
      String username, String password, Function(bool) callback) async {
    try {
      // Replace the URL with your Python server endpoint for login
      final serverUrl = "http://192.168.100.58:5000/login";

      // Send a request to the Python server to check login status
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response and get the login status
        final Map<String, dynamic> data = json.decode(response.body);
        bool isLoggedIn = data['is_logged_in'];
        String serverPublicKey = data['server_public_key'];
        await saveServerPublicKey(serverPublicKey);
        callback(isLoggedIn);
      } else {
        // Handle the case where the server request fails
        print('Failed to check login status');
      }
    } catch (error) {
      // Handle any exceptions that occur during the process
      print('Error: $error');
    }
  }
}
