import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Form"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "PURPOSE FOR DEVELOPMENT",
              style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
            ),
            const Text(
              "My Career Interest",
              style: TextStyle(color: Colors.grey),
            ),
            const TextField(),
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              color: const Color.fromARGB(255, 23, 26, 137),
              child: const Center(
                  child: Text(
                "Short-Term Development",
                style: TextStyle(color: Colors.white),
              )),
            )
          ],
        ),
      ),
    );
  }
}
