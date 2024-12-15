import 'package:location_demo_1/Local%20Storage/boxes.dart';
import 'package:location_demo_1/Models/location_data_model.dart';

class DataService {
  List<HiveLocationData> locationFunc() {
    List<HiveLocationData> locationList = [];
    final locationListF = Boxes.getLocationList();
    for (var e in locationListF.values) {
      locationList = e.locationList
          .map((e) => HiveLocationData(
              firstplaceLat: e.firstplaceLat,
              firstplaceLong: e.firstplaceLong,
              firstPlaceAddress: e.firstPlaceAddress,
              secondPlaceLat: e.secondPlaceLat,
              secondPlaceLong: e.secondPlaceLong,
              secondPlaceAddress: e.secondPlaceAddress,
              distance: e.distance,
              timeStamp: e.timeStamp))
          .toList();
    }
    return locationList;
  }
}
