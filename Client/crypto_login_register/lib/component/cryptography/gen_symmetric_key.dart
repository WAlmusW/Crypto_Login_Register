import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_udid/flutter_udid.dart';

import 'package:crypto_login_register/component/cryptography/server_public_key.dart';
import 'package:crypto_login_register/component/cryptography/encrypt.dart';

String generateSessionKey(String deviceId) {
  String combinedInfo = deviceId; //+ DateTime.now().toIso8601String();
  List<int> bytes = utf8.encode(combinedInfo);
  Digest hash = sha256.convert(bytes);

  return hash.toString();
}

Future<String> performKeyExchange() async {
  String device_udid = await FlutterUdid.consistentUdid;

  String clientSessionKey = generateSessionKey(device_udid);
  String? serverPublicKey = await getServerPublicKey();

  String encryptedSessionKey = "";
  if (serverPublicKey != null) {
    encryptedSessionKey =
        await EncryptionUtils.encryptData(clientSessionKey, serverPublicKey);
  }

  final serverUrl = "http://192.168.100.58:5000/exchange_key";
  final response = await http.post(
    Uri.parse(serverUrl),
    body: {'encrypted_session_key': encryptedSessionKey},
  );

  if (response.statusCode == 200) {
    return 'Key exchange successful';
  } else {
    return 'Key exchange failed';
  }
}
