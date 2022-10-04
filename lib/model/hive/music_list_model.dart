import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'music_list_model.g.dart';

@HiveType(typeId: 1)
class MusicModel extends HiveObject {
  MusicModel({
    this.id,
    required this.title,
    required this.path,
    required this.album,
    required this.duration,

    // required this.albums,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? path;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? album;

  @HiveField(4)
  String duration;
}

String boxname = 'songs';

// ignore: avoid_classes_with_only_static_members
class StorageBox {
  static Box<List<dynamic>>? _box;
  static Box<List<dynamic>> getInstance() {
    return _box ??= Hive.box(boxname);
  }
}
