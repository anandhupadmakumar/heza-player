import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/music_controller.dart';

import '../../../controller/playlist_controller.dart';
import '../../../model/hive/music_list_model.dart';
import '../../screens/screen_splash/m_splash_screen.dart';

class BottomSheetListViewWidgetPlaylist extends StatelessWidget {
  const BottomSheetListViewWidgetPlaylist(
      {super.key, required this.playlistname, required this.addSongs});
  final String playlistname;
  final List<dynamic> addSongs;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayListController>(
        init: PlayListController(),
        builder: (PlayListController playlistcntrl) {
          return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    maxRadius: 30.r,
                    backgroundImage:
                        const AssetImage('assets/images/music logomp3.jpg'),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color.fromARGB(255, 41, 41, 41)
                                .withOpacity(0.3),
                            spreadRadius: 8,
                            blurRadius: 5,
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          playlistcntrl.homeController.songsFromDb[index].title ?? 'unknown',
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      if (playlistcntrl.playlistSongs
                          .where((dynamic element) =>
                              element.id == playlistcntrl.homeController.songsFromDb[index].id)
                          .isEmpty)
                        IconButton(
                          onPressed: () {
                            //playlist add function

                            palylistMusicModelList(
                                index, playlistname, playlistcntrl.homeController.songsFromDb,playlistcntrl);
                          },
                          icon: const Icon(Icons.add_circle_outline_sharp),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            playlistcntrl.playlistDeleteSongs(
                                playlistcntrl.homeController.songsFromDb[index].id,
                                playlistname);
                          },
                          icon: const Icon(Icons.minimize),
                        ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 100.w,
                        child: Text(
                          playlistcntrl.homeController.songsFromDb[index].album ?? 'unknown',
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Text(playlistcntrl.homeController.songsFromDb[index].duration)
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 2,
                );
              },
              itemCount: playlistcntrl.homeController.songsFromDb.length);
        });
  }
}

void palylistMusicModelList(
    int index, String palylistnameKey, List<dynamic> songs,PlayListController cntrl) {
  final MusicModel data = MusicModel(
    id: int.parse(songs[index].id.toString()),
    title: songs[index].title.toString(),
    path: songs[index].path.toString(),
    album: songs[index].album.toString(),
    duration: songs[index].duration.toString(),
  );

  cntrl.playlistAdd(palylistnameKey, index, data);
}
