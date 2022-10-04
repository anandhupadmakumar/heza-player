import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import '../../../controller/favorite_controller.dart';
import '../../../controller/music_controller.dart';
import '../../colors/m_colors.dart';
import '../../widgets/favorite/functions.dart';
import '../../widgets/home/list_view_widget.dart';
import '../../widgets/mini_player/mini_player.dart';
import '../../widgets/now_playing/now_playing_playlist_add.dart';

class NowPlayingScren extends StatelessWidget {
  NowPlayingScren({super.key});
  final FavoriteController favController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Now Playing'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: favController.homeController.audioPlayer
          .builderRealtimePlayingInfos(builder: (BuildContext context,
              RealtimePlayingInfos realtimePlayingInfos) {
        return SafeArea(
          child: SizedBox(
            child: Stack(
              children: <Widget>[
                themeBlue(),
                themePink(),
                Positioned(
                  left: 20.w,
                  top: 0.h,
                  right: 20.w,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        audioImage(realtimePlayingInfos),
                        SizedBox(
                          height: 50.h,
                        ),
                        playlistFavButtons(realtimePlayingInfos),
                        SizedBox(
                          height: 10.h,
                        ),
                        title(realtimePlayingInfos),
                        SizedBox(
                          height: 10.h,
                        ),
                        slider(realtimePlayingInfos),
                        tmeStamp(realtimePlayingInfos),
                        SizedBox(
                          height: 10.h,
                        ),
                        playBar(realtimePlayingInfos),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget audioImage(RealtimePlayingInfos realtimePlayingInfos) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Material(
        elevation: 8.0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 100.0,
          child: Image.asset(
            fit: BoxFit.fill,
            'assets/images/now_playing-mp3.png',
            height: 250,
          ),
        ),
      ),
    );
  }

  Widget playlistFavButtons(RealtimePlayingInfos realtimePlayingInfos) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            // margin: EdgeInsets.only(left: 10),
            width: double.infinity,
            height: 20.h,
            child: Marquee(
              text: realtimePlayingInfos.current!.audio.audio.metas.title!,
              pauseAfterRound: const Duration(seconds: 1),
              velocity: 5,
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
              blankSpace: 30,
              crossAxisAlignment: CrossAxisAlignment.start,
              // text: realtimePlayingInfos.current!.audio.audio.metas.title!,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          GetBuilder<FavoriteController>(builder: (FavoriteController nowplayingfav) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (nowplayingfav.songsFromDbFav
                      .where((dynamic element) =>
                          element.id ==
                          int.parse(realtimePlayingInfos
                              .current!.audio.audio.metas.id
                              .toString()))
                      .isEmpty)
                    IconButton(
                      onPressed: () {
                        favoriteSongModel(
                            realtimePlayingInfos.current!.index, favController);
                        // playListSongModel(index);
                      },
                      icon: Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.grey,
                        size: 30.sp,
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () {
                        nowplayingfav.favDeleteSongs(
                            int.parse(realtimePlayingInfos
                                .current!.audio.audio.metas.id
                                .toString()),
                            realtimePlayingInfos.current!.index);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30.sp,
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      //palylist add current song playing
                      //bottomsheet show function
                      Get.bottomSheet(NowPlayingBottomSheetWidget(
                        indexs: realtimePlayingInfos.current!.index,
                      ));
                    },
                    icon: Icon(
                      Icons.playlist_add,
                      color: Colors.grey,
                      size: 30.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                      size: 30.sp,
                    ),
                  ),
                ]);
          }),

          // IconButton(
          //   onPressed: () {

          //     // favoritebtnAction(realtimePlayingInfos.current!.index);
          //     // favoriteSnackbar(context: context);
          //     // setState(() {
          //     //   if (favoriteIdList.contains(songsFromDb[
          //     //           audioPlayer.current.value!.playlist.currentIndex]
          //     //       .id)) {
          //     //     favoriteIdList.remove(songsFromDb[
          //     //             audioPlayer.current.value!.playlist.currentIndex]
          //     //         .id);
          //     //     box.put('favourites', favoriteIdList);

          //     //   } else {
          //     //     favoriteIdAdd(
          //     //         songsFromDb[audioPlayer
          //     //                 .current.value!.playlist.currentIndex]
          //     //             .id!,
          //     //         audioPlayer.current.value!.playlist.currentIndex);
          //     //   }
          //     // })

          //     // add to user's favorite list
          //     //show snack bar when selected the favorite icon
          //   },
          //   icon: const Icon(
          //     Icons.favorite,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget title(RealtimePlayingInfos realtimePlayingInfos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[textMoving(realtimePlayingInfos)],
    );
  }

  Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
    return SliderTheme(
        data: SliderThemeData(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.8),
            trackShape: Customshape()),
        child: Slider.adaptive(
            autofocus: true,
            value: realtimePlayingInfos.currentPosition.inSeconds.toDouble(),
            max: realtimePlayingInfos.duration.inSeconds.toDouble() + 1,
            onChanged: (double value) {
              favController.homeController.audioPlayer.seek(Duration(seconds: value.toInt()));
            }));

    // return Slider.adaptive(
    //     value: realtimePlayingInfos.currentPosition.inSeconds.toDouble(),
    //     max: realtimePlayingInfos.duration.inSeconds.toDouble(),
    //     onChanged: (value) {
    //       widget.audioPlayer.seek(Duration(seconds: value.toInt()));
    //     });
  }



Widget tmeStamp(RealtimePlayingInfos realtimePlayingInfos) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(transformString(realtimePlayingInfos.currentPosition.inSeconds)),
      Text(
        transformString(realtimePlayingInfos.duration.inSeconds),
      ),
    ],
  );
}

Widget playBar(RealtimePlayingInfos realtimePlayingInfos) {
  return GetBuilder<MusicController>(builder: (MusicController loop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () {
            if (!loop.playingLoop) {
              favController.homeController.audioPlayer.setLoopMode(LoopMode.single);

              loop.playingLoop = true;
            } else {
              favController.homeController.audioPlayer.setLoopMode(LoopMode.playlist);

              loop.playingLoop = false;
            }
          },
          icon: loop.playingLoop
              ? const Icon(Icons.repeat_one)
              : const Icon(Icons.repeat),
          iconSize: 30.sp,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          onPressed: () async {
            if (songsSkip) {
              songsSkip = false;
              await favController.homeController.audioPlayer.previous();

              songsSkip = true;
            }
          },
          icon: const Icon(Icons.fast_rewind_rounded),
          iconSize: 30.sp,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          onPressed: () {
            favController.homeController.audioPlayer.playOrPause();
          },
          icon: Icon(realtimePlayingInfos.isPlaying
              ? Icons.pause_circle_filled_rounded
              : Icons.play_circle_fill_rounded),
          iconSize: 70.sp,
          color: const Color.fromARGB(255, 5, 237, 237),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          onPressed: () async {
            if (songsSkip) {
              songsSkip = false;
              await favController.homeController.audioPlayer.next();

              songsSkip = true;
            }
          },
          icon: const Icon(Icons.fast_forward_rounded),
          iconSize: 30.sp,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          onPressed: () {
            Get.bottomSheet(
                backgroundColor:
                    const Color.fromARGB(192, 3, 97, 116).withOpacity(1),
                 ListViewWidget(hController: favController.homeController,));

            // playlistNowPlayingScreen(context);
          },
          icon: const Icon(Icons.playlist_play),
          iconSize: 30.sp,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ],
    );
  });
}

String transformString(int seconds) {
  final String minuteString =
      '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
  final String scondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
  return '$minuteString:$scondString';
}
}

class Customshape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    @required RenderBox? parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme!.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox!.size.height - trackHeight) / 2;
    final double trackwidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackwidth, trackHeight);
  }
}
