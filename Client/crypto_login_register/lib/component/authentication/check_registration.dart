import 'package:flutter_udid/flutter_udid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationService {
  static Future<void> checkRegistrationStatus(Function(bool) callback) async {
    try {
      // Replace the URL with your Python server endpoint
      final serverUrl = "http://192.168.100.58:5000/check_registration";

      // Get the device ID using Flutter_UDID
      String deviceId = await FlutterUdid.consistentUdid;

      // Send a request to the Python server to check registration status
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {'device_udid': deviceId},
      );

      if (response.statusCode == 200) {
        // Parse the response and get the registration status
        final Map<String, dynamic> data = json.decode(response.body);
        bool isRegistered = data['is_registered'];

        // Callback to update the UI with the registration status
        callback(isRegistered);
      } else {
        // Handle the case where the server request fails
        print('Failed to check registration status');
      }
    } catch (error) {
      // Handle any exceptions that occur during the process
      print('Error: $error');
    }
  }
}
