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
