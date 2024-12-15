import 'package:barcode_scanner/purchase_ticket.dart';
import 'package:barcode_scanner/seat_mapping.dart';
import 'package:barcode_scanner/services/riverpod.dart';
import 'package:barcode_scanner/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    ref.read(riverpodDarkMode.notifier).state = false;
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.sunny),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Light Mode"),
                    ],
                  )),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    ref.read(riverpodDarkMode.notifier).state = true;
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.dark_mode),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Dark Mode"),
                    ],
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PurchaseTicketScreen()));
                  },
                  child: const Text("User")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const OrganizerVerifierScreen()));
                  },
                  child: const Text("Organizer")),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SeatMapping()));
              },
              child: const Text("Seat Mapping")),
        ],
      ),
    );
  }
}

class MyPage extends ConsumerStatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  int _localCounter = 0; // Local state with setState

  @override
  Widget build(BuildContext context) {
    // Riverpod state
    final counterProvider = ref.watch(counterStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod and setState Together')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display Riverpod state
            Text('Riverpod Counter: $counterProvider'),

            // Display local state with setState
            Text('setState Counter: $_localCounter'),

            // Button to increment local state with setState
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _localCounter++; // Updates local state
                });
              },
              child: Text('Increment Local Counter'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update Riverpod state
          ref.read(counterStateProvider.notifier).state++;
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
