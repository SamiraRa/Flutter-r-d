// import 'package:flutter/foundation.dart';
// import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart' as geo;

// class LocationServiceValNotifier {
//   final Location _location = Location();

//   // ValueNotifiers to expose data
//   final ValueNotifier<LocationData?> locationDataNotifier = ValueNotifier(null);
//   final ValueNotifier<String> locationAddressNotifier = ValueNotifier('Fetching address...');
//   final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

//   LocationServiceValNotifier() {
//     _initializeLocation();
//   }

//   Future<void> _initializeLocation() async {
//     await _requestLocationPermission();
//     await getLocation();
//   }

//   Future<void> _requestLocationPermission() async {
//     final hasPermission = await _location.hasPermission();
//     if (hasPermission == PermissionStatus.denied) {
//       await _location.requestPermission();
//     }
//   }

//   Future<void> getLocation() async {
//     try {
//       isLoadingNotifier.value = true;

//       final LocationData locationData = await _location.getLocation();
//       locationDataNotifier.value = locationData;

//       if (locationData.latitude != null && locationData.longitude != null) {
//         await _getAddress(locationData.latitude!, locationData.longitude!);
//       }
//     } catch (e) {
//       debugPrint('Error: $e');
//       locationAddressNotifier.value = 'Error fetching location';
//     } finally {
//       isLoadingNotifier.value = false;
//     }
//   }

//   Future<void> _getAddress(double lat, double long) async {
//     try {
//       List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, long);
//       locationAddressNotifier.value =
//           "${placemarks[2].street!}, ${placemarks[4].name!}, ${placemarks[1].name!}, ${placemarks[0].locality!} - ${placemarks[0].postalCode!}";
//     } catch (e) {
//       locationAddressNotifier.value = 'Error fetching address';
//       debugPrint('Error: $e');
//     }
//   }
// }
