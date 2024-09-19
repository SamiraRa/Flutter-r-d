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
      home: const LoginPage(),
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
