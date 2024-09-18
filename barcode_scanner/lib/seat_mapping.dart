// import 'dart:async';

import 'package:barcode_scanner/services/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class SeatMapping extends ConsumerWidget {
  const SeatMapping({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Timer? timer;

    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(preferredSize: Size(200, 20), child: Text("subtitle")),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          "Seat Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
            // ref.watch(riverpodIncrement).toString(),
            ref.watch(riverpodModelIncrement).counter.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (ref.watch(riverpodModelIncrement).counter > 0) {
                    // if (ref.watch(riverpodIncrement) > 0) {
                    // ref.read(riverpodIncrement.notifier).state--;
                    ref.read(riverpodModelIncrement).decCounter();
                  }
                },
                child: const Text("Decrement"),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(riverpodModelIncrement).addCounter();
                  // ref.read(riverpodIncrement.notifier).state++;
                },
                // onLongPress: () {
                //   Timer.periodic(const Duration(milliseconds: 100), (timer) {
                //     ref.read(riverpodIncrement.notifier).state++;
                //   });
                // },
                child: const Text("Increment"),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                loadingAnimation(context);
              },
              child: const Text("Submit"))
        ],
      ),
    );
  }

  Future<dynamic> loadingAnimation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: [
                  Lottie.asset("assets/json/loading_animation_person.json",
                      height: MediaQuery.of(context).size.height / 3)
                ],
              ),
            ),
          );
        });
  }
}
