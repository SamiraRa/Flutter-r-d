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
      body: SingleChildScrollView(
        child: Column(
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
              child: const Text("Submit"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1,
              child: ListView.builder(
                  itemCount: ref.watch(riverpodModelIncrement).counter,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (index, context) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                ref.read(seatIncrement.notifier).state++;
                                // ref.read(riverpodModelIncrement.notifier).incrementSeat(index);
                              },
                              icon: Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () {
                                if (ref.watch(seatIncrement) > 0) {
                                  ref.read(seatIncrement.notifier).state--;
                                }
                              },
                              icon: Icon(Icons.remove),
                            ),
                          ],
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(100)),
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of squares per row
                                crossAxisSpacing: 0.0, // Space between columns
                                mainAxisSpacing: 00,
                              ),
                              itemCount: ref.watch(riverpodModelIncrement).counter,
                              itemBuilder: (index, context) {
                                return Padding(
                                  padding: const EdgeInsets.all(50),
                                  child: Container(
                                    margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
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
