import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/favorite_controller.dart';
import '../../../controller/music_controller.dart';
import '../../colors/m_colors.dart';
import '../../widgets/favorite/bottom_sheet_list_view.dart';
import '../../widgets/home/list_view_widget.dart';
import '../../widgets/playlist/playlist_name_bottom.dart';
import '../screen_splash/m_splash_screen.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
  final FavoriteController favController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 43, 43),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          themeBlue(),
          themePink(),
          // themecyan(),
          Positioned(
            top: 0,
            child: InkWell(
              onTap: () {
                Get.bottomSheet(BottomSheet(
                    onClosing: () {},
                    builder: (BuildContext context) {
                      return Container(
                        color: const Color.fromARGB(255, 33, 81, 88),
                        child: const BottomSheetListViewWidget(),
                      );
                    }));
                // bottomSheetPlaylistFavoirte(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.only(left: 40, top: 20),
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color.fromARGB(255, 14, 14, 14)
                            .withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(5, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color.fromARGB(255, 2, 101, 114),
                      width: 2,
                    )),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: const Color.fromARGB(255, 232, 74, 6),
                        size: 40.sp,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Add songs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          if (favController.songsFromDbFav.isEmpty)
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
                child: GetBuilder<FavoriteController>(
                    init: FavoriteController(),
                    builder: (FavoriteController data) {
                      log(data.toString());

                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              onTap: () async {
                                if (songsSkip) {
                                  songsSkip = false;
                                  // FavoriteAudioSongs.clear();
                                  log(index.toString());
                                  await data.homeController
                                      .musicPlay(favController.mfavoriteMusic);

                                  await favController.homeController.audioPlayer
                                      .playlistPlayAtIndex(index);
                                  songsSkip = true;
                                }
                              },
                              onLongPress: () {
                                Get.defaultDialog(
                                  title: 'Warning',
                                  content:
                                      const Text('Do you want to delete ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        data.favDeleteSongs(
                                            data.songsFromDbFav[index].id ?? 0,
                                            index);
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
                                        color: const Color.fromARGB(
                                                255, 41, 41, 41)
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
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  // 'data',
                                  data.songsFromDbFav[index].title.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              subtitle: Text(
                                data.songsFromDbFav[index].album.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    // nowPlayerBottomSheetPlaylist(index, context);
                                    Get.bottomSheet(PlayListNameBottomSheet(
                                      indexs: index,
                                      addSongs: data.songsFromDbFav,
                                    ));
                                  },
                                  icon: const Icon(Icons.playlist_add)));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            thickness: 2,
                          );
                        },
                        itemCount: data.songsFromDbFav.length,
                      );
                    }),
              ),

              //  HomeListView(assetsAudioplayer: assetsaudioPlayer,),
            ),
        ],
      ),
    );
  }
}
