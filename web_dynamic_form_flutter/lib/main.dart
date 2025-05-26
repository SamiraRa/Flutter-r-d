import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_dynamic_form_flutter/Services/repositories.dart';
import 'package:web_dynamic_form_flutter/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("imageList");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List unsplashData = [];

  @override
  void initState() {
    super.initState();
    apicall();
  }

  apicall() async {
    int pageNumber = 1;
    final box = await Hive.box("imageList");
    var a = box.get("imageData");

    print("x  ${unsplashData.length} $pageNumber");
    for (int i = pageNumber; i < 20; i++) {
      List x = await Repositories().getImageRepo(pageNumber);

      for (var a in x) {
        unsplashData.add(a);
      }

      box.put("imageData", unsplashData);

      pageNumber++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RND',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
