import 'package:flutter/material.dart';
import 'package:flutter_object_box/model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [
    User(name: "User 1", email: "user1@gmail.com"),
    User(name: "User 2", email: "user2@gmail.com"),
    User(name: "User 3", email: "user3@gmail.com"),
  ];
// 01857924499 //bkash2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(users[index].name),
                Text(users[index].email),
                const Divider(
                  height: 0.8,
                ),
              ],
            );
          }),
    );
  }
}
