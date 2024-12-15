import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location_demo_1/Models/location_data_model.dart';

class Boxes {
  static Box<HiveLocationData> getLocationData() => Hive.box('locationData');
  static Box<ListofLocation> getLocationList() => Hive.box('locationList');

  static clearBox() {
    Hive.openBox('locationData').then((value) => value.clear());
    Hive.openBox('locationList').then((value) => value.clear());
    Boxes.getLocationData().clear();
    Boxes.getLocationList().clear();
  }
}
