import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_object_box/controller/global_data.dart';
import 'package:flutter_object_box/model/user_model.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:objectbox/objectbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location _location = Location();
  LocationData? _locationData;
  double latitudeF = 0.0;
  double longitudeF = 0.0;
  String locationAddress = "";
  List<User> users = [];
  final Box<User> userBox = store.box<User>();
  List<User> streamUser = [];

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
        title: const Text("Home Page"),
      ),
      body: Column(
        children: [
          // StreamBuilder(stream: stream, builder: (builder))
          ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount: streamUser.length,
              shrinkWrap: true,
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
                  onPressed: () {
                    getLocation();
                    final userPlaceF = User(
                        firstLat: latitudeF,
                        firstLong: longitudeF,
                        secondLat: 0.0,
                        secondLong: 0.0,
                        firstlocAddress: locationAddress,
                        secondlocAddress: "",
                        distance: "distance");
                    userBox.put(userPlaceF);
                    setState(() {});
                  },
                  child: const Text("First Place")),
              ElevatedButton(
                  onPressed: () {
                    getLocation();
                  },
                  child: const Text("Second Place")),
            ],
          )
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.green,
        ),
        child: IconButton(
            onPressed: () async {
              // await LaunchApp.openApp(androidPackageName: "com.whatsapp");
              await LaunchApp.openApp(androidPackageName: "com.whatsapp");
            },
            icon: const Icon(
              Icons.call,
              size: 32,
            )),
      ),
    );
  }

  //==========For Lacation=========//
  Future<void> _requestLocationPermission() async {
    final hasPermission = await _location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await _location.requestPermission();
    }
  }

  Future<void> getLocation() async {
    try {
      final LocationData locationData = await _location.getLocation();
      setState(() {
        _locationData = locationData;
        latitudeF = locationData.latitude ?? 0.0;
        longitudeF = locationData.longitude ?? 0.0;
      });

      if (locationData.latitude != null && locationData.longitude != null) {
        await getAddress(locationData.latitude!, locationData.longitude!);
      }
    } catch (e) {
      print('Error: $e');
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
}
