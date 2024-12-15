import 'package:flutter/material.dart';

class DistanceCard extends StatelessWidget {
  final double? firstLat;
  final double? firstLong;
  final String? firstAddress;
  final double? secondLat;
  final double? secondLong;
  final String? secondAddress;
  final double? distance;

  const DistanceCard({
    super.key,
    this.firstLat,
    this.firstLong,
    this.firstAddress,
    this.secondLat,
    this.secondLong,
    this.secondAddress,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lat : $firstLat"),
                Text("Long : $firstLong"),
                Text("Address : $firstAddress"),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Distance"),
                Text("${distance!.toStringAsFixed(2)} km"),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Lat: $secondLat"),
                Text("Long: $secondLong"),
                Text("Address: $secondAddress"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
