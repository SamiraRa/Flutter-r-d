// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart' as geo;
// import 'package:location_demo_1/Models/location_data_model.dart';

// class LocationServiceStream {
//   final Location _location = Location();
//   final StreamController<HiveLocationData> _locationStreamController = StreamController<HiveLocationData>.broadcast();

//   Stream<HiveLocationData> get locationStream => _locationStreamController.stream;

//   LocationServiceStream() {
//     _initializeLocation();
//   }

//   Future<void> _initializeLocation() async {
//     await _requestLocationPermission();
//     await fetchLocationAndAddress(saveToHive: false);
//   }

//   Future<void> _requestLocationPermission() async {
//     final hasPermission = await _location.hasPermission();
//     if (hasPermission == PermissionStatus.denied) {
//       await _location.requestPermission();
//     }
//   }

//   Future<HiveLocationData?> fetchLocationAndAddress({required saveToHive}) async {
//     try {
//       final LocationData locationData = await _location.getLocation();
//       HiveLocationData? locationModel;

//       if (locationData.latitude != null && locationData.longitude != null) {
//         final double latitude = locationData.latitude!;
//         final double longitude = locationData.longitude!;
//         final String address = await getAddress(latitude, longitude);
//         // Example for distance (you can use a specific calculation logic)
//         final double distance = _calculateDistance(latitude, longitude, 37.7749, -122.4194);

//         // Push data to the stream
//         locationModel = HiveLocationData(
//             firstplaceLat: latitude,
//             firstplaceLong: longitude,
//             firstPlaceAddress: address,
//             secondPlaceLat: 37.7749,
//             secondPlaceLong: -122.4194,
//             secondPlaceAddress: "San Francisco, CA",
//             distance: distance);

//         _locationStreamController.sink.add(locationModel);

//         //     { "firstLat": latitude,
//         //   "firstLong": longitude,
//         //   "firstAddress": address,
//         //   "secondLat": 37.7749, // Example lat
//         //   "secondLong": -122.4194, // Example long
//         //   "secondAddress": "San Francisco, CA", // Example address
//         //   "distance": distance,
//         // }
//         if (saveToHive) {
//           final box = await Hive.openBox<HiveLocationData>('locationData');
//           await box.add(locationModel);
//           print("Data saved to Hive: ${locationModel.firstPlaceAddress}");
//         }
//         return locationModel;
//       }
//     } catch (e) {
//       debugPrint("Error fetching location: $e");
//       _locationStreamController.sink.addError("Error fetching location");
//     }
//     return null;
//   }

//   Future<String> getAddress(double lat, double long) async {
//     try {
//       List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, long);
//       return "${placemarks[0].street!}, ${placemarks[0].locality!}";
//     } catch (e) {
//       print("Error fetching address: $e");
//       return "Unknown address";
//     }
//   }

//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     // Placeholder for actual distance calculation logic (e.g., Haversine formula)
//     return ((lat1 - lat2).abs() + (lon1 - lon2).abs()) * 111; // Rough distance in km
//   }

//   void dispose() {
//     _locationStreamController.close();
//   }
// }










// //------------------------------------------------------------------------------------------------------------------------------------------
// //------------------------------------------------------------------------------------------------------------------------------------------
// // import 'package:geocoding/geocoding.dart' as geo;

// // enum {

// // }

// // class LocationService {
// //   //==========For Lacation=========//
// //   Future<void> _requestLocationPermission() async {
// //     final hasPermission = await _location.hasPermission();
// //     if (hasPermission == PermissionStatus.denied) {
// //       await _location.requestPermission();
// //     }
// //   }

// //   Future<void> getLocation() async {
// //     try {
// //       final LocationData locationData = await _location.getLocation();
// //       setState(() {
// //         _locationData = locationData;
// //         latitudeF = locationData.latitude ?? 0.0;
// //         longitudeF = locationData.longitude ?? 0.0;
// //       });

// //       if (locationData.latitude != null && locationData.longitude != null) {
// //         await getAddress(locationData.latitude!, locationData.longitude!);
// //       }
// //     } catch (e) {
// //       print('Error: $e');
// //     }
// //   }

// //   getAddress(lat, long) async {
// //     List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, long);
// //     // print(placemarks);
// //     setState(() {
// //       locationAddress =
// //           "${placemarks[2].street!}, ${placemarks[4].name!}, ${placemarks[1].name!}, ${placemarks[0].locality!} - ${placemarks[0].postalCode!}";
// //     });
// //     for (int i = 0; i < placemarks.length; i++) {}
// //     return locationAddress;
// //   }
// // }