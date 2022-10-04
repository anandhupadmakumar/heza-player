import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:get/get.dart';

import '../main.dart';
import '../model/hive/music_list_model.dart';
import '../view/screens/home/m_home_screen.dart';

class MusicController extends GetxController {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  List<dynamic> songsFromDbFav = <dynamic>[].obs;
  bool? bottomSheetIcon;

  List<MusicModel> songsFromDb = <MusicModel>[];
  List<Audio> mMusicListMain1 = <Audio>[].obs;

  List<Audio> playListSongsAudio = <Audio>[].obs;
  bool? notification;
  bool playingLoop = false;

  Future<void> mSplashScreenDelay() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    Get.offAll(() => MHomeScreen());
  }

  Future<void> addsongsToHive(List<MusicModel> allSongs) async {
    await box.put('mymusic', allSongs);
    if (songsFromDb != null) {
      songsFromDb = box.get('mymusic')! as List<MusicModel>;
      log(songsFromDb.toString());

      mMusicListMain1 = musicAudioConvertings(allSongs);
    }
  }

  Future<void> musicPlay(List<Audio> music) async {
    await audioPlayer.open(
      showNotification: notification ?? true,
      // notification == null || notification == true ? true : false,
      autoStart: false,
      loopMode: LoopMode.playlist,
      respectSilentMode: true,
      Playlist(audios: music),
    );
  }

  //playlist section--------------------------------

  List<Audio> musicAudioConvertings(List<dynamic> audioSongs) {
    final List<Audio> mMusicListMain = <Audio>[];
    for (final dynamic element in audioSongs) {
      mMusicListMain.add(
        Audio.file(
          element.path!.toString(),
          metas: Metas(
              title: element.title.toString(),
              artist: element.album.toString(),
              id: element.id.toString()),
        ),
      );
    }
    return mMusicListMain;
  }
}
