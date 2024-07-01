import 'dart:math';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_object_box/controller/global_data.dart';
import 'package:flutter_object_box/model/user_model.dart';
import 'package:flutter_object_box/view/show_material_banner.dart';
import 'package:flutter_object_box/widget/floating_action_button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:objectbox/objectbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();
  LocationData? locationData;
  double firstLatitudeF = 0.0;
  double firstlongitudeF = 0.0;
  double secondLatitudeF = 0.0;
  double secondlongitudeF = 0.0;
  String locationAddress = "";
  List<User> users = [];
  final Box<User> userBox = store.box<User>();
  List<User> streamUser = [];
  bool firstLocationTaken = false;

  @override
  void initState() {
    super.initState();

    streamUser = userBox.getAll();
  }

  // Stream<List<User>> getUser()=> userBox.query().watch().map((event) => event.find());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Distance Meter"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // StreamBuilder(stream: stream, builder: (builder))
            ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemCount: streamUser.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(streamUser[index].firstLat.toStringAsFixed(2)),
                          Text(streamUser[index].firstLong.toStringAsFixed(2)),
                          // Text(
                          //   streamUser[index].firstlocAddress,
                          // ),
                          // const Divider(
                          //   height: 10,
                          //   thickness: 1,
                          //   color: Colors.orange,
                          // )
                        ],
                      ),
                      Text(streamUser[index].distance),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(streamUser[index].secondLat.toStringAsFixed(2)),
                          Text(streamUser[index].secondLong.toStringAsFixed(2)),
                          Text(streamUser[index].secondlocAddress),
                        ],
                      ),
                    ],
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: firstLocationTaken ? Colors.grey : Colors.white,
                      foregroundColor: firstLocationTaken ? Colors.white : Colors.purple),
                  onPressed: () async {
                    if (!firstLocationTaken) {
                      locationData = await getLocation();
                      firstLatitudeF = locationData!.latitude ?? 0.0;
                      firstlongitudeF = locationData!.longitude ?? 0.0;
                      firstLocationTaken = true;
                      setState(() {});
                    }
                  },
                  child: const Text("First Place"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!firstLocationTaken) {
                      Fluttertoast.showToast(msg: "Please click First Place button first!");
                      return;
                    }

                    locationData = await getLocation();
                    secondLatitudeF = locationData!.latitude ?? 0.0;
                    secondlongitudeF = locationData!.longitude ?? 0.0;
                    String distance =
                        calculateDistance(firstLatitudeF, firstlongitudeF, secondLatitudeF, secondlongitudeF)
                            .toStringAsFixed(2);
                    User userPlaceF = User(
                        firstLat: firstLatitudeF,
                        firstLong: firstlongitudeF,
                        secondLat: secondLatitudeF,
                        secondLong: secondlongitudeF,
                        firstlocAddress: locationAddress,
                        secondlocAddress: "",
                        distance: distance);
                    userBox.put(userPlaceF);
                    setState(() {
                      streamUser = userBox.getAll();
                      firstLocationTaken = false;
                    });
                  },
                  child: const Text("Second Place"),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionWidget(
            iconName: Icons.notifications_active_outlined,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowMaterialBanner()));
            },
            iconSize: 32,
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionWidget(
            iconName: Icons.call,
            onPressed: () async {
              await LaunchApp.openApp(androidPackageName: "com.whatsapp");
            },
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  //==========For Lacation=========//
  Future<void> requestLocationPermission() async {
    final hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await location.requestPermission();
    }
  }

  Future<LocationData?> getLocation() async {
    try {
      final LocationData locationDataT = await location.getLocation();
      setState(() {
        locationData = locationDataT;
        // firstLatitudeF = locationDataT.latitude ?? 0.0;
        // firstlongitudeF = locationDataT.longitude ?? 0.0;
      });

      if (locationDataT.latitude != null && locationDataT.longitude != null) {
        await getAddress(locationDataT.latitude!, locationDataT.longitude!);
      }
      return locationData;
    } catch (e) {
      return locationData;
    }
  }

  getAddress(lat, long) async {
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, long);
    // print(placemarks);
    setState(() {
      locationAddress =
          "${placemarks[2].street!}, ${placemarks[4].name!}, ${placemarks[1].name!}, ${placemarks[0].locality!} - ${placemarks[0].postalCode!}";
    });
    for (int i = 0; i < placemarks.length; i++) {}
    return locationAddress;
  }

  double calculateDistance(latitudeF, longitudeF, currentLatitude, currentLongitude) {
    var c = acos(sin(degreesToRadians(latitudeF)) * sin(degreesToRadians(currentLatitude)) +
            cos(degreesToRadians(latitudeF)) *
                cos(degreesToRadians(currentLatitude)) *
                cos(degreesToRadians(currentLongitude - longitudeF))) *
        6371;
    var d = c * 1000;
    return d; //d is the distance in meters
  }

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
