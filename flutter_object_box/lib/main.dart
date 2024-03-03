import 'package:flutter/material.dart';
import 'package:flutter_object_box/view/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ObjectBox.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
