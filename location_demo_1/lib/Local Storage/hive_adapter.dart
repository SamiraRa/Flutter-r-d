import 'package:hive_flutter/hive_flutter.dart';
import 'package:location_demo_1/Models/location_data_model.dart';

class HiveAdapter {
  hiveAdapterbox() async {
    Hive.registerAdapter(HiveLocationDataAdapter());
    Hive.registerAdapter(ListofLocationAdapter());
    await Hive.openBox<HiveLocationData>('locationData');
    await Hive.openBox<ListofLocation>('locationList');
  }
}
