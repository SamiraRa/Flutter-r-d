import 'package:barcode_scanner/purchase_ticket.dart';
import 'package:barcode_scanner/seat_mapping.dart';
import 'package:barcode_scanner/verify_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
