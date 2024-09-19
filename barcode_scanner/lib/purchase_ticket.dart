import 'dart:async';
import 'dart:convert';

import 'package:barcode_scanner/login_page.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class PurchaseTicketScreen extends StatefulWidget {
  const PurchaseTicketScreen({super.key});

  @override
  State<PurchaseTicketScreen> createState() => _PurchaseTicketScreenState();
}

class _PurchaseTicketScreenState extends State<PurchaseTicketScreen> {
  bool codeGenerated = false;
  String purchaseCode = "";
  Timer? timer;
//   String encryptPurchaseCode(String purchaseCode, String secretKey) {
//   final key = encrypt.Key.fromUtf8(secretKey); // Must be 32 bytes long
//   final iv = encrypt.IV.fromLength(16); // Initialization vector
//   final encrypter = encrypt.Encrypter(encrypt.AES(key));

//   final encrypted = encrypter.encrypt(purchaseCode, iv: iv);
//   return encrypted.base64;
// }

// String decryptPurchaseCode(String encryptedCode, String secretKey) {
//   final key = encrypt.Key.fromUtf8(secretKey);
//   final iv = encrypt.IV.fromLength(16);
//   final encrypter = encrypt.Encrypter(encrypt.AES(key));

//   final decrypted = encrypter.decrypt64(encryptedCode, iv: iv);
//   return decrypted;
// }

  String generateCustomCode({int timeWindowSeconds = 2}) {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    int flooredTime = currentTime ~/ timeWindowSeconds;

    double baseCode = flooredTime + (9 * 8 / 7);

    int finalCode = baseCode.toInt();

    String input = '$finalCode';
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    String code = digest.toString().substring(0, 6);

    return code;
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        purchaseCode = generateCustomCode();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Mr. User"),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("A type"),
              Text("Morning"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("6:30 PM"),
          const SizedBox(
            height: 10,
          ),
          codeGenerated
              ? SizedBox(
                  height: 90,
                  width: 220,
                  child: BarcodeWidget(
                    data: purchaseCode,
                    barcode: Barcode.code128(),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      purchaseCode = generateCustomCode();
                      codeGenerated = true;
                      print(purchaseCode);
                    });
                  },
                  child: const Text("Purchase Ticket"),
                ),
        ],
      ),
    );
  }
}
