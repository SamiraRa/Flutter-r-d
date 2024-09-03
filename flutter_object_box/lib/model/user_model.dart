// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_object_box/model/media_data.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
// @Sync()
class User {
  int? id;
  double firstLat;
  double firstLong;
  double secondLat;
  double secondLong;
  String firstlocAddress;
  String secondlocAddress;
  String distance;

  @Backlink()
  final gallery = ToMany<MediaFileToPreview>();

  User({
    this.id,
    required this.firstLat,
    required this.firstLong,
    required this.secondLat,
    required this.secondLong,
    required this.firstlocAddress,
    required this.secondlocAddress,
    required this.distance,
  });
}
