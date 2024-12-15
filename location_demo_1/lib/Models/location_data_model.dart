// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'location_data_model.g.dart';

@HiveType(typeId: 0)
class HiveLocationData extends HiveObject {
  @HiveField(0)
  double firstplaceLat;
  @HiveField(1)
  double firstplaceLong;
  @HiveField(2)
  String firstPlaceAddress;
  @HiveField(3)
  double secondPlaceLat;
  @HiveField(4)
  double secondPlaceLong;
  @HiveField(5)
  String secondPlaceAddress;
  @HiveField(6)
  double distance;
  @HiveField(7)
  String timeStamp;

  HiveLocationData({
    required this.firstplaceLat,
    required this.firstplaceLong,
    required this.firstPlaceAddress,
    required this.secondPlaceLat,
    required this.secondPlaceLong,
    required this.secondPlaceAddress,
    required this.distance,
    required this.timeStamp,
  });
}

@HiveType(typeId: 1)
class ListofLocation extends HiveObject {
  @HiveField(0)
  List<HiveLocationData> locationList;

  ListofLocation({
    required this.locationList,
  });
}
