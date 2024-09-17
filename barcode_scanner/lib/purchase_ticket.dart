import 'package:flutter/material.dart';

class PurchaseTicketScreen extends StatefulWidget {
  const PurchaseTicketScreen({super.key});

  @override
  State<PurchaseTicketScreen> createState() => _PurchaseTicketScreenState();
}

class _PurchaseTicketScreenState extends State<PurchaseTicketScreen> {


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Text("Name"),
        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("A type"),
            Text("Morning"),
          ],
        ),
        SizedBox(height: 10,),
        Text("6:30 PM"),
        SizedBox(height: 10,),

        ElevatedButton(onPressed: (){
          setState(() {
            const purchaseCode = "123456789";
          });
        }, child: Text("Purchase Ticket"))
       
      ],),
    );
  }
}