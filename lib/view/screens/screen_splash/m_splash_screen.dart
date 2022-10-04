import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../controller/favorite_controller.dart';

import '../../../model/hive/music_list_model.dart';
import '../../../model/json/music_list_json.dart';

List<MusicListData> songlist2 = <MusicListData>[];

// final MusicController mController = MusicController();

class MSplashScreen extends StatelessWidget {
  MSplashScreen({super.key});
  final FavoriteController homeController = Get.put(FavoriteController());
  static const MethodChannel _platform =
      MethodChannel('search_files_in_storage/search');

  @override
  Widget build(BuildContext context) {
    splashFetch();
    homeController.favGetsongs();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hezaplayerlogo.png'),
          ),
        ),
      ),
    );
  }

  void searchInStorage() {
    _platform.invokeMethod('search').then((dynamic value) {
      final String res = value as String;

      onSuccess(res);
    }).onError((Object error, StackTrace stackTrace) {
      log('anandhu  $error');
    });
  }

  Future<void> splashFetch() async {
    log('requst permission');
    if (await _requestPermission(Permission.storage)) {
      searchInStorage();
      homeController.homeController.mSplashScreenDelay();
    } else {
      splashFetch();
    }
  }

  Future<bool> _requestPermission(Permission isPermission) async {
    log('$isPermission this is permisson');
    // const store = Permission.storage;
    const Permission store = Permission.storage;
    const Permission access = Permission.accessMediaLocation;
    log('$store this is store');
    log('$access this is access');

    if (await isPermission.isGranted) {
      await access.isGranted && await store.isGranted;

      return true;
    } else {
      final PermissionStatus result = await store.request();

      final PermissionStatus oneresult = await access.request();

      log('permission request ');

      if (result == PermissionStatus.limited &&
          oneresult == PermissionStatus.limited) {
        log('permission status granted ');

        return true;
      } else {
        log('permission denied ');

        return false;
      }
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  dynamic onSuccess(String audioListFromStorage) async {
    final dynamic valueMap = jsonDecode(audioListFromStorage);

    // final a = MusicListData.fromJson(valueMap);
    final List<dynamic> songlist = valueMap as List<dynamic>;

    songlist2 = songlist.map((dynamic e) {
      return MusicListData.fromJson(e as Map<String, dynamic>);
    }).toList();

    final List<MusicModel> allSongs = songlist2
        .map(
          (MusicListData music) => MusicModel(
            id: int.parse(music.id!),
            title: music.title,
            path: music.path,
            album: music.albums,
            duration: _printDuration(
              Duration(
                milliseconds: int.parse(
                  music.duration.toString(),
                ),
              ),
            ),
          ),
        )
        .toList();
    homeController.homeController.addsongsToHive(allSongs);
  }
}
