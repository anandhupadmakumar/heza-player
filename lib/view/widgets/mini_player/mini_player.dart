import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import '../../../controller/music_controller.dart';
import '../../screens/now_playing/now_playing_screen.dart';

import '../home/list_view_widget.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Get.find<MusicController>().audioPlayer.builderRealtimePlayingInfos(
      builder:
          (BuildContext context, RealtimePlayingInfos realtimePlayingInfos) {
        return GestureDetector(
          onTap: () {
            Get.to(() =>  NowPlayingScren());
          },
          child: Container(
            color: const Color.fromARGB(255, 50, 50, 50),
            width: double.infinity,
            height: 70.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor:
                              const Color.fromARGB(255, 0, 94, 172),
                          backgroundImage: const AssetImage(
                              'assets/images/music logomp3.jpg'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            textMoving(realtimePlayingInfos),
                          ],
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (songsSkip) {
                              songsSkip = false;
                              await Get.find<MusicController>().audioPlayer.previous();

                              songsSkip = true;
                            }
                          },
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.find<MusicController>().audioPlayer.playOrPause();
                          },
                          icon: Icon(realtimePlayingInfos.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded),
                          iconSize: 40,
                          color: const Color.fromARGB(255, 7, 225, 236),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            if (songsSkip) {
                              songsSkip = false;
                              await Get.find<MusicController>().audioPlayer.next();

                              songsSkip = true;
                            }
                          },
                          child:
                              const Icon(Icons.skip_next, color: Colors.white),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}

Widget textMoving(
  RealtimePlayingInfos realtimePlayingInfos,
) {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    width: 120.w,
    height: 20.h,
    child: Marquee(
      pauseAfterRound: const Duration(seconds: 1),
      velocity: Get.find<MusicController>().audioPlayer.current.hasValue ? 5 : 0,
      style: const TextStyle(color: Colors.white),
      blankSpace: 30,
      crossAxisAlignment: CrossAxisAlignment.start,
      text: realtimePlayingInfos.current!.audio.audio.metas.title.toString(),
    ),
  );
}
