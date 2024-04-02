import 'package:flutter/material.dart';
import 'package:flutter_object_box/controller/global_data.dart';
import 'package:flutter_object_box/controller/objectbox.dart';
import 'package:flutter_object_box/view/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = (await ObjectBox.create()).store;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
