import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:asn1lib/asn1lib.dart';

class EncryptionUtils {
  static Future<String> fetchServerPublicKey() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/get_public_key'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load server public key');
    }
  }

  static RSAPublicKey parsePEMPublicKey(String publicKeyPEM) {
    final pemString = publicKeyPEM
        .replaceAll('-----BEGIN PUBLIC KEY-----', '')
        .replaceAll('-----END PUBLIC KEY-----', '')
        .replaceAll('\n', '');

    final bytes = Uint8List.fromList(base64.decode(pemString));
    final asn1Parser = ASN1Parser(bytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    final modulus = topLevelSeq.elements[0] as ASN1Integer;
    final exponent = topLevelSeq.elements[1] as ASN1Integer;

    return RSAPublicKey(
      modulus.valueAsBigInteger,
      exponent.valueAsBigInteger,
    );
  }

  static Future<String> encryptData(String data, String serverPublicKey) async {
    final publicKey = parsePEMPublicKey(serverPublicKey);

    final encryptor = OAEPEncoding(RSAEngine())
      ..init(
        true,
        PublicKeyParameter<RSAPublicKey>(publicKey),
      );

    final Uint8List utf8Data = Uint8List.fromList(utf8.encode(data));
    final Uint8List encrypted = encryptor.process(Uint8List.fromList(utf8Data));

    return base64Encode(encrypted);
  }
}
