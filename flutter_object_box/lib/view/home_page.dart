import 'dart:math';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_object_box/controller/global_data.dart';
import 'package:flutter_object_box/model/user_model.dart';
import 'package:flutter_object_box/objectbox.g.dart';
import 'package:flutter_object_box/view/download_and_preview.dart';
import 'package:flutter_object_box/view/pdftron_flutter.dart';
import 'package:flutter_object_box/view/ppt_view.dart';
import 'package:flutter_object_box/view/show_material_banner.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowMaterialBanner()));
            },
            icon: const Icon(Icons.notifications_active_outlined),
          ),
          IconButton(
            onPressed: () async {
              await LaunchApp.openApp(androidPackageName: "com.whatsapp");
            },
            icon: const Icon(Icons.call),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/textures_patterns.jpg",
                    ),
                    fit: BoxFit.cover),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.pink,
                    child: Text("S"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Hi!"), Text("samirarashid698@gmail.com")],
                  )
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PptView()));
              },
              leading: Image.asset(
                "assets/images/slide.png",
                height: 40,
                width: 40,
                color: const Color.fromARGB(255, 214, 149, 171),
              ),
              title: const Text(
                "MP4 Files",
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 30, 48, 129),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PdfTronFlutterScreen()));
              },
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Image.asset(
                  "assets/icons/document-file.png",
                  height: 30,
                  width: 30,
                  color: const Color.fromARGB(255, 214, 149, 171),
                ),
              ),
              title: const Text(
                "PdfTron",
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 30, 48, 129),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DownloadAndPreview()));
              },
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Image.asset(
                  "assets/icons/open.png",
                  height: 30,
                  width: 30,
                  color: const Color.fromARGB(255, 214, 149, 171),
                ),
              ),
              title: const Text(
                "Download and Preview",
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 30, 48, 129),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
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
                      User userPlaceF = User(
                          firstLat: firstLatitudeF,
                          firstLong: firstlongitudeF,
                          secondLat: 0.0,
                          secondLong: 0.0,
                          firstlocAddress: "",
                          secondlocAddress: "",
                          distance: "");
                      userBox.put(userPlaceF);
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
                    final query =
                        userBox.query(User_.secondLat.lessOrEqual(0.0) & User_.secondLong.lessOrEqual(0.0)).build();
                    final userplaceF = query.findFirst();
                    query.close();
                    userplaceF!.secondLat = secondLatitudeF;
                    userplaceF.secondLong = secondlongitudeF;
                    userplaceF.distance = distance;
                    userplaceF.secondlocAddress = "";
                    userBox.put(userplaceF);
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
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionWidget(
      //       iconName: Icons.notifications_active_outlined,
      //       onPressed: () {
      //         Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowMaterialBanner()));
      //       },
      //       iconSize: 32,
      //     ),
      //     const SizedBox(
      //       width: 20,
      //     ),
      //     FloatingActionWidget(
      //       iconName: Icons.call,
      //       onPressed: () async {
      //         await LaunchApp.openApp(androidPackageName: "com.whatsapp");
      //       },
      //       iconSize: 32,
      //     ),
      //   ],
      // ),
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
