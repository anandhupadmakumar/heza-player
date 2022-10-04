import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/favorite_controller.dart';
import '../../../controller/music_controller.dart';
import '../../../controller/playlist_controller.dart';
import '../../../model/hive/music_list_model.dart';
import '../../colors/m_colors.dart';

import '../../widgets/home/list_view_widget.dart';
import '../../widgets/playlist/bottom_sheet_palylist.dart';

class PlaylsitSongScreen extends StatelessWidget {
  const PlaylsitSongScreen(
      {super.key, required this.indexs, required this.pController});
  final int indexs;
  final PlayListController pController;

  @override
  Widget build(BuildContext context) {
    pController.homeController.playListSongsAudio = pController.homeController
        .musicAudioConvertings(pController.playlistSongs);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(pController.playListNames[indexs].toString()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                BottomSheet(
                  onClosing: () {},
                  builder: (BuildContext context) {
                    return Container(
                      color: const Color.fromARGB(255, 33, 81, 88),
                      child: BottomSheetListViewWidgetPlaylist(
                          playlistname:
                              pController.playListNames[indexs].toString(),
                          addSongs: pController.playlistSongs),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline_outlined),
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 44, 43, 43),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          themeBlue(),
          themePink(),
          if (pController.playlistSongs.isEmpty)
            const Center(
              child: Text(
                'No songs found',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            )
          else
            Positioned(
              top: 10.0.h,
              left: 20.0.w,
              right: 0.0.w,
              bottom: 80.0.h,
              child: SafeArea(
                child: GetBuilder<PlayListController>(
                  init: PlayListController(),
                  builder: (PlayListController playlists) {
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () async {
                              if (songsSkip) {
                                songsSkip = false;
                                // FavoriteAudioSongs.clear();
                                log(index.toString());
                                await playlists.homeController.musicPlay(
                                    pController
                                        .homeController.playListSongsAudio);

                                await pController.homeController.audioPlayer
                                    .playlistPlayAtIndex(index);
                                songsSkip = true;
                              }
                            },
                            onLongPress: () {
                              Get.defaultDialog(
                                title: 'Warning',
                                content: const Text('Do you want to delete ?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      playlists.playlistDeleteSongs(
                                          playlists.playlistSongs[index].id,
                                          playlists.playListNames[indexs]
                                              .toString());
                                      Get.back();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Cancel'),
                                  )
                                ],
                              );

                              // data.favDeleteSongs(index);
                              // deletePopupFavorite(context, index);

                              // favorites = false;
                            },
                            leading: CircleAvatar(
                              maxRadius: 30.r,
                              backgroundImage: const AssetImage(
                                  'assets/images/music logomp3.jpg'),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 41, 41, 41)
                                              .withOpacity(0.3),
                                      spreadRadius: 8,
                                      blurRadius: 5,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            title: Text(
                              playlists.playlistSongs[index].title.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            subtitle: Text(
                              playlists.playlistSongs[index].album.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            trailing: GetBuilder<FavoriteController>(
                                builder: (FavoriteController favCntrl) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  if (favCntrl.songsFromDbFav
                                      .where((dynamic element) =>
                                          element.id ==
                                          playlists.playlistSongs[index].id)
                                      .isEmpty)
                                    IconButton(
                                      onPressed: () {
                                        //favoriteSongModel(index);

                                        final dynamic data = MusicModel(
                                          id: int.parse(playlists
                                              .playlistSongs[index].id
                                              .toString()),
                                          title: playlists
                                              .playlistSongs[index].title
                                              .toString(),
                                          path: playlists
                                              .playlistSongs[index].path
                                              .toString(),
                                          album: playlists
                                              .playlistSongs[index].album
                                              .toString(),
                                          duration: playlists
                                              .playlistSongs[index].duration
                                              .toString(),
                                        );

                                        favCntrl.favoriteSongAdd(
                                            'favorites', data, index);

                                        // playListSongModel(index);
                                      },
                                      icon: const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else
                                    IconButton(
                                      onPressed: () {
                                        favCntrl.favDeleteSongs(
                                            favCntrl.homeController
                                                    .songsFromDb[index].id ??
                                                0,
                                            index);
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ),
                                ],
                              );
                            }));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemCount: playlists.playlistSongs.length,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
