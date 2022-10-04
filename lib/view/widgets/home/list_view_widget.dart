import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/favorite_controller.dart';

import '../../../controller/music_controller.dart';
import '../favorite/functions.dart';
import '../playlist/playlist_name_bottom.dart';

bool songsSkip = true;

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({super.key,required this.hController});
  final MusicController hController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(builder: (FavoriteController mcdata) {
      return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () async {
                if (songsSkip) {
                  songsSkip = false;

                  await hController
                      .musicPlay(hController.mMusicListMain1);

                  await hController.audioPlayer.playlistPlayAtIndex(index);
                  songsSkip = true;
                }
              },
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
                      mcdata.homeController.songsFromDb[index].title ??
                          'unknown',
                      style: const TextStyle(
                          color: Colors.white, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Row(
                    children: favIconAddDeleteWidget(mcdata, index),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 100.w,
                    child: Text(
                      hController.songsFromDb[index].album ?? 'unknown',
                      style: const TextStyle(
                          color: Colors.white, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Text(hController.songsFromDb[index].duration)
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              thickness: 2,
            );
          },
          itemCount: hController.songsFromDb.length);
    });
  }

  List<Widget> favIconAddDeleteWidget(FavoriteController mcdata, int index) {
    return <Widget>[
      IconButton(
          onPressed: () {
            Get.bottomSheet(
              PlayListNameBottomSheet(
                indexs: index,
                addSongs: hController.songsFromDb,
             
              ),
            );
          },
          icon: const Icon(Icons.playlist_add)),
      if (mcdata.songsFromDbFav
          .where((dynamic element) =>
              element.id == mcdata.homeController.songsFromDb[index].id)
          .isEmpty)
        IconButton(
          onPressed: () {
            favoriteSongModel(index,mcdata);
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
            mcdata.favDeleteSongs(
                mcdata.homeController.songsFromDb[index].id ?? 0, index);
          },
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
    ];
  }
}



// List<Widget> playlistIconAddDeleteWidget(MusicController mcdata, int index,dynamic songs) {
//   return <Widget>[
   
//     if (mcdata.songsFromDbFav
//         .where((dynamic element) => element.id == songs.id)
//         .isEmpty)
//       IconButton(
//         onPressed: () {
//           favoriteSongModel(index);
//         },
//         icon: const Icon(
//           Icons.favorite_border_outlined,
//           color: Colors.grey,
//         ),
//       )
//     else
//       IconButton(
//         onPressed: () {
//           mcdata.favDeleteSongs(mcdata.songsFromDb[index].id ?? 0);
//         },
//         icon: const Icon(
//           Icons.favorite,
//           color: Colors.red,
//         ),
//       ),
//   ];
// }
