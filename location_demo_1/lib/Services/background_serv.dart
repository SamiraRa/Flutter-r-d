import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:location_demo_1/Services/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

// String tempTimer = "";

// void startBackgroundService() {
//   final service = FlutterBackgroundService();
//   service.startService();
// }

// void stopBackgroundService() {
//   final service = FlutterBackgroundService();
//   service.invoke("stop");
// }

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      // initialNotificationTitle: "Location Demo",
      // initialNotificationContent: (DateTime.now().millisecondsSinceEpoch * 1000).toString(),
      foregroundServiceTypes: [AndroidForegroundType.location, AndroidForegroundType.dataSync],
      autoStartOnBoot: true,
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceName = await deviceInfoPlugin.androidInfo.then((value) => value.model + value.brand);
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(minutes: 15), (timer) async {
    // tempTimer = timer.toString();
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        ForegroundNotificationConfig(
            notificationTitle: "Background Service", notificationText: timer.toString(), setOngoing: true);
        try {
          // Fetch location data

          Position position = await Geolocator.getCurrentPosition();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          double lat = position.latitude;
          double long = position.longitude;
          prefs.setString("lat", lat.toString());
          prefs.setString("long", long.toString());
          // Fetch address
          List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, long);
          String address = "${placemarks[0].name}, "
              "${placemarks[0].street}, "
              "${placemarks[0].subLocality}, "
              "${placemarks[0].locality}, "
              "${placemarks[0].administrativeArea}, "
              "${placemarks[0].country}, "
              "${placemarks[0].postalCode}";

          prefs.setString("address", address);
          // Send to repository
          // if (timer.tick == 5) {
          if (lat != 0.0 && long != 0.0 && address.isNotEmpty) {
            var body = await Repository().locationRepo(
                "yes",
                prefs.getString('lat').toString(),
                prefs.getString('long').toString(),
                prefs.getString('address').toString(),
                DateTime.now().toIso8601String().replaceAll(RegExp(r'[-:.T]'), ''),
                deviceName);
            print("Server Response Status: ${body}");
          } else {
            print("Invalid location data, skipping server update.");
          }
          // }
        } catch (e) {
          debugPrint("Error during location update: $e");
        }
      }
    }
  });

  service.invoke('update');
}

// void getLocationUpdates() {
//   final locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);
//   StreamSubscription<Position> positionStream =
//       Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
//     position.latitude;
//     print(position == null ? 'Unknown' : '${position.latitude}, ${position.longitude}');
//   });
//   positionStream.onData((data) {
//     data.latitude;
//   });
// }

Future determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  Location location = Location();
  if (await location.isBackgroundModeEnabled()) {
    await location.enableBackgroundMode();
  }

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
}
