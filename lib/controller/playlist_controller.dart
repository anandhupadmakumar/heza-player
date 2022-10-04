import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'favorite_controller.dart';
import 'music_controller.dart';

class PlayListController extends GetxController {
  @override
  void onReady() {
    getPlalylistNames();

    super.onReady();
  }

  MusicController homeController = Get.put(MusicController());
  FavoriteController favoriteController = Get.put(FavoriteController());
  List<dynamic> playListNames = <dynamic>[].obs;
  List<dynamic> playlistSongs = <dynamic>[];

  void playlistNameAdd(List<dynamic> playListnames) {
    box.put('playlist_name', playListNames);
    update();
  }

  void getPlalylistNames() {
    playListNames = box.get('playlist_name') ?? <dynamic>[];
    update();
  }

  void playlistNameDelete(int index, String playlistnamekey) {
    playListNames.removeAt(index);
    box.put('playlist_name', playListNames);
    box.delete(playlistnamekey);
    update();
  }

  Future<void> playlistAdd(
      String palylistnameKey, int index, dynamic songs) async {
    final List<dynamic> result = playlistSongs
        .where((dynamic element) => element.id == songs.id)
        .toList();

    if (result.isEmpty) {
      playlistSongs.add(songs);
      // songsFromDbFav.sort();

      await box.put(palylistnameKey, playlistSongs);
      log(playlistSongs.toString());
      playlistGet(palylistnameKey);
      log(playlistSongs.toString());

      final Audio playListaudio = Audio.file(songs.path.toString(),
          metas: Metas(
              id: songs.id.toString(),
              title: songs.title.toString(),
              artist: songs.album.toString()));
      homeController.audioPlayer.playlist?.add(playListaudio);

      update();
    } else {
      Get.snackbar('warning ', 'Song already exist');
    }
  }

  void playlistGet(String key) {
    // playlistSongs = musicAudioConvertings(songsFromDbFav);
    if (playlistSongs != null) {
      playlistSongs = box.get(key) ?? <dynamic>[];
      update();
    }
  }

  Future<void> playlistDeleteSongs(dynamic index, String playlistKey) async {
    playlistSongs.removeWhere((dynamic element) => element.id == index);
    await box.put(playlistKey, playlistSongs);
    homeController.audioPlayer.playlist?.audios
        .removeWhere((dynamic element) => element.metas.id == index.toString());
    update();
  }
}
