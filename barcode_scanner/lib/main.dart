import 'package:barcode_scanner/login_page.dart';
import 'package:barcode_scanner/services/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightnessStatus = ref.watch(riverpodDarkMode) ? Brightness.dark : Brightness.light;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barcode Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: brightnessStatus),
        useMaterial3: true,
        // brightness: brightnessStatus
      ),
      home: MyPage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//   });

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String _scanBarcode = 'Unknown';

//   Future<void> scanBarcodeNormal() async {
//     String barcodeScanRes;
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
//       print(barcodeScanRes);
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }

//     if (!mounted) return;

//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(onPressed: () => scanBarcodeNormal(), child: const Text('Start barcode scan')),
//           Text('Scan result : $_scanBarcode\n', style: const TextStyle(fontSize: 20))
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';


import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:barcode/barcode.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:quickalert/quickalert.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String _data = '1234567890'; // Initial barcode data
  Timer? _timer;
  String dec = '';
  String baseID = "25"; // Original baseID
  String scannedBaseID = '';
  String hashedScannedValue = '';


  void initState() {
    super.initState();
    // Timer for dynamic updates
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _data = generateRandomData();
      });
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  // String generateRandomData() {
  //   var timestamp = DateTime.now().toString(); // Use current timestamp in milliseconds
  //   String baseID = "25"; // Define your baseID


  //   // Combine timestamp and baseID
  //   String alldata = timestamp + baseID;
  //   //print('Data to Encrypt (Timestamp + BaseID): $alldata');


  //   final key = en.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32-byte key
  //   final iv = en.IV.fromLength(16); // 16-byte IV for AES
  //   final encrypter = en.Encrypter(en.AES(key));


  //   // Encrypt the combined data (timestamp + baseID)
  //   final encrypted = encrypter.encrypt(alldata, iv: iv);
  //   // print('Encrypted Data: ${encrypted.base64}');


  //   // Combine IV and encrypted data (Base64 encode both)
  //   String combined = iv.base64 + encrypted.base64;


  //   return combined;
  // }


  String generateRandomData() {
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString(); // Use current timestamp in milliseconds
    String baseID = "25"; // Define your baseID


    // Combine timestamp and baseID
    String alldata = timestamp + baseID;


    final key = en.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32-byte key
    final iv = en.IV.fromLength(16); // 16-byte IV for AES
    final encrypter = en.Encrypter(en.AES(key));


    // Encrypt the combined data (timestamp + baseID)
    final encrypted = encrypter.encrypt(alldata, iv: iv);


    // Combine IV and encrypted data (Base64 encode both)
    String combined = iv.base64 + encrypted.base64;


    return combined;
  }


  Future<void> scanBarcode() async {
    var result = await BarcodeScanner.scan(); // Start barcode scanning
    var scannedValue = result.rawContent; // Get the scanned barcode data
    print('Scanned Barcode: $scannedValue');


    final key = en.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32-byte key


    try {
      // Extract the IV and the encrypted data from the scanned value
      String ivBase64 = scannedValue.substring(0, 24); // First 24 characters (16 bytes in Base64)
      String encryptedBase64 = scannedValue.substring(24); // Rest is the encrypted data


      final iv = en.IV.fromBase64(ivBase64);
      final encrypter = en.Encrypter(en.AES(key));


      // Decrypt the encrypted data
      final encrypted = en.Encrypted.fromBase64(encryptedBase64);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      print('Decrypted Data (Timestamp + BaseID): $decrypted');


      // Split the decrypted data into timestamp and baseID
      String decryptedTimestamp = decrypted.substring(0, decrypted.length - 2); // Extract the timestamp part
      String decryptedBaseID = decrypted.substring(decrypted.length - 2); // Last 2 characters for baseID


      // Get the current time
      DateTime now = DateTime.now();
      print("Current time: $now");


      // Step 1: Validate the baseID
      String expectedBaseID = "25";
      if (decryptedBaseID != expectedBaseID) {
        print("BaseID mismatch. Barcode invalid.");
        showSuccessDialog(context, "Failed", "BaseID mismatch!");
        return; // Exit if baseID doesn't match
      }
      print("BaseID matched");


      // Step 2: Validate the timestamp (check if it's within 10 seconds)
      int scannedTimestamp = int.parse(decryptedTimestamp); // This will work now as it's numeric
      DateTime scannedDateTime = DateTime.fromMillisecondsSinceEpoch(scannedTimestamp);


      Duration difference = now.difference(scannedDateTime);
      print("Time difference: ${difference.inSeconds} seconds");


      if (difference.inSeconds <= 20) {
        showSuccessDialog(context, "Success", "ID Matched Successfully!");
        print("Timestamp is valid, barcode is valid");
      } else {
        showSuccessDialog(context, "Failed", " Session out ");
        print("Timestamp is invalid, barcode is invalid");
      }
    } catch (e) {
      showSuccessDialog(context, "Failed", "Error decrypting!");
      print('Error decrypting: $e');
    }
  }


  // Future<void> scanBarcode() async {
  //   print("Hasibul");
  //   var result = await BarcodeScanner.scan(); // Start barcode scanning
  //   var scannedValue = result.rawContent; // Get the scanned barcode data
  //   print('Scanned Barcode: $scannedValue');


  //   final key = en.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32-byte key


  //   try {
  //     // Extract the IV and the encrypted data from the scanned value
  //     String ivBase64 = scannedValue.substring(0, 24); // First 24 characters (16 bytes in Base64)
  //     String encryptedBase64 = scannedValue.substring(24); // Rest is the encrypted data


  //     final iv = en.IV.fromBase64(ivBase64);
  //     final encrypter = en.Encrypter(en.AES(key));


  //     // Decrypt the encrypted data
  //     final encrypted = en.Encrypted.fromBase64(encryptedBase64);
  //     final decrypted = encrypter.decrypt(encrypted, iv: iv);
  //     print('Decrypted Data (Timestamp + BaseID): $decrypted');


  //     // Split the decrypted data into timestamp and baseID
  //     String decryptedTimestamp = decrypted.substring(0, decrypted.length - 2); // Extract the timestamp part
  //     String decryptedBaseID = decrypted.substring(decrypted.length - 2); // Last 2 characters for baseID


  //     // Get the current time
  //     DateTime now = DateTime.now();


  //     print("timeeeeeeeeeeeeee $now");


  //     // Step 1: Validate the baseID
  //     String expectedBaseID = "25";
  //     if (decryptedBaseID != expectedBaseID) {
  //       print("BaseID mismatch. Barcode invalid.");
  //       return; // Exit if baseID doesn't match
  //     }


  //     print("BaseID matched");


  //     // Step 2: Validate the timestamp (check if it's within 10 seconds)
  //     int scannedTimestamp = int.parse(decryptedTimestamp);
  //     DateTime scannedDateTime = DateTime.fromMillisecondsSinceEpoch(scannedTimestamp);


  //     Duration difference = now.difference(scannedDateTime);
  //     print("Kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
  //     print(difference.inSeconds);


  //     if (difference.inSeconds <= 20) {
  //       scannedBaseID = decryptedBaseID;
  //       showSuccessDialog(context, "success", "ID Matched Successfully!");
  //       // Valid within the 10-second window
  //       print("Timestamp is valid, barcode is valid");
  //     } else {
  //       showSuccessDialog(context, "Faild", "ID not Matched !");
  //       // Timestamp is outside the valid window
  //       print("Timestamp is invalid, barcode is invalid");
  //     }
  //   } catch (e) {
  //     showSuccessDialog(context, "Faild e", "ID not Matched !");
  //     print('Error decrypting: $e');
  //   }
  // }


  void showSuccessDialog(BuildContext context, String textTitle, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(textTitle),
          content: Text(text),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Barcode Generator'),
        actions: [
          // icon: Icon(Icons.camera_alt),
          // onPressed: scanBarcode, // Trigger barcode scanning


          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: scanBarcode, // Trigger barcode scanning
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ticketing.Birth hasibul",
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
            const SizedBox(
              height: 10,
            ),
            // Center(
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       minimumSize: Size(180, 180),
            //       elevation: 10,
            //       backgroundColor: const Color.fromARGB(255, 29, 50, 28), // Background color
            //       shape: CircleBorder(), // Circular shape
            //     ),
            //     onPressed: () async {
            //       scanBarcode();
            //       // _startPeriodicMessages();
            //       // setState(() {
            //       //   showStartDialog(context);
            //       // });
            //     },
            //     child: Text(
            //       "Scan",
            //       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),


            BarcodeWidget(
              dec: dec,
              data: _data, // Use the dynamic data
              code: Barcode.pdf417(), // Specify the barcode type
            ),
            const SizedBox(height: 20),
            // Text(
            //   'Scanned BaseID: $scannedBaseID',
            //   style: TextStyle(fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}


class BarcodeWidget extends StatelessWidget {
  final String data;
  final String dec;
  final Barcode code;


  const BarcodeWidget({required this.data, required this.dec, required this.code});


  @override
  Widget build(BuildContext context) {
    // Generate the SVG string for the barcode
    final svg = code.toSvg(data, width: 200, height: 200); // Adjust width & height for QR code


    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SvgPicture.string(
              svg, // Use the SVG string here
              width: 200,
              height: 200,
            ),
          ),
        ),
        // Text("encrypt"),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     ' $data', // Show the current data
        //     style: const TextStyle(fontSize: 16),
        //   ),
        // ),
      ],
    );
  }
}


// import 'dart:async';
// import 'dart:convert';


// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:barcode/barcode.dart';
// import 'package:crypto/crypto.dart';
// import 'package:encrypt/encrypt.dart' as en;


// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }


// class _HomePageState extends State<HomePage> {
//   String _data = '1234567890'; // Initial barcode data
//   Timer? _timer;
//   String dec = '';
//   String baseID = "25"; // Original baseID
//   String scannedBaseID = '';
//   String hashedScannedValue = '';
//   String latestBarcodeData = '';


//   @override
//   void initState() {
//     super.initState();
//     // Timer for dynamic updates
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       setState(() {
//         _data = generateRandomData();
//       });
//     });
//   }


//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }


//   String generateRandomData() {
//     var randomNumber = "01794139939"; // Example random data
//     String hashingAlgo = md5.convert(utf8.encode(randomNumber)).toString();
//     print('Hash: $hashingAlgo');


//     final key = en.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32-byte key
//     final iv = en.IV.fromLength(16); // 16-byte IV for AES
//     final encrypter = en.Encrypter(en.AES(key));


//     String alldata = hashingAlgo + baseID;
//     final encrypted = encrypter.encrypt(alldata, iv: iv);
//     print('Encrypted baseID: ${encrypted.base64}');


//     // Combine IV and encrypted data (Base64 encode both)
//     String combined = iv.base64 + encrypted.base64;


//     // Store the latest barcode data
//     latestBarcodeData = combined;


//     return combined;
//   }


//   Future<void> scanBarcode() async {
//     var result = await BarcodeScanner.scan(); // Start barcode scanning
//     var scannedValue = result.rawContent; // Get the scanned barcode data
//     print('Scanned Barcode: $scannedValue');


//     // Decrypt the scanned value
//     final key = en.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32-byte key


//     try {
//       // Extract the IV and the encrypted data from the scanned value
//       String ivBase64 = scannedValue.substring(0, 24); // First 24 characters (16 bytes in Base64)
//       String encryptedBase64 = scannedValue.substring(24); // Rest is the encrypted data


//       final iv = en.IV.fromBase64(ivBase64);
//       final encrypter = en.Encrypter(en.AES(key));


//       // Decrypt the encrypted data
//       final encrypted = en.Encrypted.fromBase64(encryptedBase64);
//       final decrypted = encrypter.decrypt(encrypted, iv: iv);
//       dec = decrypted;
//       print('Decrypted From Scan: $decrypted');


//       // Split decrypted value into hash and baseID
//       String hashingAlgo = decrypted.substring(0, 32); // MD5 hash length is 32 characters
//       scannedBaseID = decrypted.substring(32); // Remaining part should be baseID


//       print('Hash from Scanned Data: $hashingAlgo');
//       print('BaseID from Scanned Data: $scannedBaseID');


//       // Verify if the baseID matches and if the scanned value is the latest one
//       if (scannedBaseID == baseID && scannedValue == latestBarcodeData) {
//         showSuccessDialog(context);
//         print('BaseID Matched: $scannedBaseID');
//       } else {
//         print('BaseID Mismatch or Outdated Barcode');
//       }


//       setState(() {
//         hashedScannedValue = hashingAlgo; // Store the scanned hash for display
//       });
//     } catch (e) {
//       print('Error decrypting: $e');
//     }
//   }


//   void showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Success"),
//           content: Text("ID Matched Successfully!"),
//           actions: [
//             TextButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dynamic Barcode Generator'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.camera_alt),
//             onPressed: scanBarcode, // Trigger barcode scanning
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             BarcodeWidget(
//               dec: dec,
//               data: _data, // Use the dynamic data
//               code: Barcode.pdf417(), // Specify the barcode type
//             ),
//             const SizedBox(height: 20),
//             Text("Decrypted"),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 ' $dec', // Show the current data
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//             Text(
//               'Scanned BaseID: $scannedBaseID',
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class BarcodeWidget extends StatelessWidget {
//   final String data;
//   final String dec;
//   final Barcode code;


//   const BarcodeWidget({required this.data, required this.dec, required this.code});


//   @override
//   Widget build(BuildContext context) {
//     // Generate the SVG string for the barcode
//     final svg = code.toSvg(data, width: 200, height: 200); // Adjust width & height for QR code


//     return Column(
//       children: [
//         SizedBox(
//           height: 100,
//         ),
//         Container(
//           padding: const EdgeInsets.all(20),
//           child: Center(
//             child: SvgPicture.string(
//               svg, // Use the SVG string here
//               width: 200,
//               height: 200,
//             ),
//           ),
//         ),
//         Text("encrypt"),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             ' $data', // Show the current data
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     );
//   }
// }




  // cupertino_icons: ^1.0.8
  // barcode: ^2.2.8
  // flutter_svg: ^2.0.10+1
  // crypto: ^3.0.5
  // encrypt: ^5.0.3
  // barcode_scan2: ^4.3.3
  // quickalert: ^1.1.0
  // shorebird_code_push: ^2.0.0
  // restart_app: ^1.3.2



