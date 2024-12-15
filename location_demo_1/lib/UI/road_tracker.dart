// StreamBuilder<Map<String,dynamic>>(
//           stream: getLatLong(

//           ),
//           builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : snapshot.hasError
//                   ? const Center(child: Text("Something went Wrong"))
//                   : !snapshot.hasData
//                       // ? const DistanceCard()
//                       ? const SizedBox()
//                       : Column(
//                           children: [
//                             DistanceCard(
//                               firstLat: snapshot.data!,
//                               firstLong: snapshot.data!.firstplaceLong,
//                               firstAddress: snapshot.data!.firstPlaceAddress,
//                               secondLat: 0.0,
//                               secondLong: 0.0,
//                               secondAddress: "",
//                               distance: 0.0,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     // hiveLocationDate.add(_locationService.fetchLocationAndAddress(saveToHive: true));
//                                   },
//                                   child: const Text("Starting Point"),
//                                 ),
//                                 const SizedBox(
//                                   width: 20,
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {},
//                                   child: const Text("Destination"),
//                                 ),
//                               ],
//                             ),
//                             Expanded(
//                               child: FutureBuilder<List<HiveLocationData>>(
//                                 future:
//                                     Hive.openBox<HiveLocationData>('locationData').then((box) => box.values.toList()),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState == ConnectionState.waiting) {
//                                     return const Center(child: CircularProgressIndicator());
//                                   }
//                                   if (snapshot.hasError) {
//                                     return const Center(child: Text("Error loading saved locations"));
//                                   }
//                                   final locations = snapshot.data ?? [];
//                                   return ListView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: locations.length,
//                                     itemBuilder: (context, index) {
//                                       final location = locations[index];
//                                       return ListTile(
//                                         title: Text("Address: ${location.firstPlaceAddress}"),
//                                         subtitle: Text("Distance: ${location.distance} km"),
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//         )