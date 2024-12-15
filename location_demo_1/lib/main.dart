import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location_demo_1/Local%20Storage/hive_adapter.dart';
import 'package:location_demo_1/Services/background_serv.dart';
import 'package:location_demo_1/UI/homepage.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveAdapter().hiveAdapterbox();
  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  await determinePosition();
  await initializeService();
  final service = FlutterBackgroundService();
  service.startService();
  service.invoke('setAsForeground');
  // startBackgroundService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
