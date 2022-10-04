import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'music_controller.dart';

class FavoriteController extends GetxController {
  @override
  void onReady() {
    favGetsongs();
    super.onReady();
  }

  MusicController homeController = Get.put(MusicController());

  List<Audio> mfavoriteMusic = <Audio>[].obs;
  List<dynamic> songsFromDbFav = <dynamic>[].obs;

  Future<void> favoriteSongAdd(String key, dynamic songs, int index) async {
    final List<dynamic> result = songsFromDbFav
        .where((dynamic element) => element.id == songs.id)
        .toList();

    if (result.isEmpty) {
      songsFromDbFav.add(songs);
      // songsFromDbFav.sort();

      await box.put(key, songsFromDbFav);
      favGetsongs();

      final Audio audio = Audio.file(songs.path.toString(),
          metas: Metas(
              id: songs.id.toString(),
              title: songs.title.toString(),
              artist: songs.album.toString()));
      homeController.audioPlayer.playlist?.add(audio);

      update();
    } else {
      Get.snackbar('warning', 'song exist ');
    }
  }

  void favGetsongs() {
    mfavoriteMusic = homeController.musicAudioConvertings(songsFromDbFav);
    if (songsFromDbFav != null) {
      songsFromDbFav = box.get('favorites') ?? <dynamic>[];

      update();
    }
  }

  Future<void> favDeleteSongs(dynamic index, int indexs) async {
    songsFromDbFav.removeWhere((dynamic element) => element.id == index);
    await box.put('favorites', songsFromDbFav);
    favGetsongs();

    homeController.audioPlayer.playlist?.audios
        .removeWhere((dynamic element) => element.metas.id == index.toString());
    update();
  }
}
