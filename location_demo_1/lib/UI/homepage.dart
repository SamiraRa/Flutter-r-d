import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_demo_1/Models/location_data_model.dart';
import 'package:location_demo_1/Services/background_serv.dart';
import 'package:location_demo_1/Services/repositories.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

///*******************Used Location, GeoCoding, StreamBuilder for this Part****************///

class _HomepageState extends State<Homepage> {
  // final LocationServiceStream _locationService = LocationServiceStream();
  List<HiveLocationData> hiveLocationData = [];
  List locationTrackerList = [];
  double lat = 0.0;
  double long = 0.0;
  String address = "";

  @override
  void initState() {
    debugHiveData();
    super.initState();
  }

  @override
  void dispose() {
    // _locationService.dispose();
    super.dispose();
  }

  void debugHiveData() async {
    locationTrackerList = await Repository().locationRepo("", "", "", address, "", "");
    // hiveLocationData = DataService().locationFunc();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              locationTrackerList.isEmpty || locationTrackerList == null
                  ? SizedBox()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: locationTrackerList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                  "${locationTrackerList[index]['id']})  Lat: ${locationTrackerList[index]['latitude']},  Long: ${locationTrackerList[index]['longitude']}\nAddress: ${locationTrackerList[index]['address']}"),
                            ),
                            SizedBox(
                              height: 10,
                            )
                            // DistanceCard(
                            //   firstLat: hiveLocationData[index].firstplaceLat,
                            //   firstLong: hiveLocationData[index].firstplaceLong,
                            //   firstAddress: hiveLocationData[index].firstPlaceAddress,
                            //   secondLat: 0.0,
                            //   secondLong: 0.0,
                            //   secondAddress: "",
                            //   distance: 0.0,
                            // ),
                          ],
                        );
                      }),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () async {
              //         String id = DateTime.now().toIso8601String().replaceAll(RegExp(r'[-:.T]'), '');

              //         await getLatLong();
              //         await getAddress(lat, long);
              //         final boxData = HiveLocationData(
              //             firstplaceLat: lat,
              //             firstplaceLong: long,
              //             firstPlaceAddress: address,
              //             secondPlaceLat: 0.0,
              //             secondPlaceLong: 0.0,
              //             secondPlaceAddress: '',
              //             distance: 0.0,
              //             timeStamp: id);

              //         hiveLocationData.add(boxData);

              //         final box = Boxes.getLocationList();
              //         final locationList = ListofLocation(locationList: hiveLocationData);

              //         box.put('locationList', locationList);
              //         setState(() {});
              //       },
              //       child: const Text("Starting Point"),
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     ElevatedButton(
              //       onPressed: () async {
              //         // final locationManualData = getLatLong();
              //         await getLatLong();
              //         await getAddress(lat, long);
              //         final box = Boxes.getLocationList().get('locationList');
              //         hiveLocationData = box!.locationList;

              //         int index = hiveLocationData.indexWhere((element) =>
              //             element.timeStamp != "" && element.secondPlaceLat == 0.0 && element.secondPlaceAddress == "");
              //         hiveLocationData[index].secondPlaceLat = lat;
              //         hiveLocationData[index].secondPlaceLat = long;
              //         hiveLocationData[index].secondPlaceAddress = address;
              //         setState(() {});
              //         final listOfLocation = ListofLocation(locationList: hiveLocationData);
              //         Boxes.getLocationList().put('locationList', listOfLocation);
              //       },
              //       child: const Text("Destination"),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddress(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    // Combine the address components into a single string
    String address = "${placemarks[0].name}, "
        "${placemarks[0].street}, "
        "${placemarks[0].subLocality}, "
        "${placemarks[0].locality}, "
        "${placemarks[0].administrativeArea}, "
        "${placemarks[0].country}, "
        "${placemarks[0].postalCode}";

    return address;
  }

  Future<Map<String, dynamic>> getLatLong() async {
    Map<String, dynamic> addressData = {
      "lat": 0.0,
      "long": 0.0,
      "address": "",
    };
    try {
      Position position = await _determinePosition();
      double lat = position.latitude;
      double long = position.longitude;

      final address = await getAddress(lat, long);
      setState(() {});
      addressData['lat'] = lat;
      addressData['long'] = long;
      addressData['address'] = address;

      return addressData;
    } catch (error) {
      // Handle the error
      return addressData;
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Placeholder for actual distance calculation logic (e.g., Haversine formula)
    return ((lat1 - lat2).abs() + (lon1 - lon2).abs()) * 111; // Rough distance in km
  }
}
