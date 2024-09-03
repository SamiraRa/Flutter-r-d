// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_object_box/model/user_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class MediaFileToPreview {
  int? id;
  String filePath;
  String previewTiming;
  String endTime;
  String startTime;

  final user = ToOne<User>();
  MediaFileToPreview({
    this.id,
    required this.filePath,
    required this.previewTiming,
    required this.endTime,
    required this.startTime,
  });
}
