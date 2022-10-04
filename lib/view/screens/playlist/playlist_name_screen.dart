import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/music_controller.dart';

import '../../../controller/playlist_controller.dart';
import '../../colors/m_colors.dart';
import '../screen_splash/m_splash_screen.dart';
import 'playlist_songs_screen.dart';

TextEditingController playListNameController = TextEditingController();

class PlayListNameScreen extends StatelessWidget {
   PlayListNameScreen({super.key});
 final PlayListController playListController = Get.put(PlayListController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        themeBlue(),
        themePink(),
        Positioned(
          top: 0,
          child: InkWell(
            onTap: () {
              Get.defaultDialog(
                  title: 'Add new playlist',
                  content: Form(
                    child: TextFormField(
                      controller: playListNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(const Radius.circular(5).r),
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('cancel')),
                    TextButton(
                        onPressed: () {
                          if (playListNameController.text.isEmpty ||
                              playListNameController.text == 'favorites') {
                            const SnackBar playlistSnackbar = SnackBar(
                              content: Text('Enter a valid name'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(playlistSnackbar);
                            // Get.snackbar('warning', 'Enter a valid name');
                            // Get.snackbar('title', 'message');
                            Get.back();
                            playListNameController.clear();
                          } else {
                            if (!playListController.playListNames
                                .contains(playListNameController.text)) {
                              playListController.playListNames
                                  .add(playListNameController.text);
                              playListController
                                  .playlistNameAdd(playListController.playListNames);

                              Get.back();
                              playListNameController.clear();
                            } else {
                              const SnackBar playlistSnackbara = SnackBar(
                                content: Text('warning Name is already exist'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(playlistSnackbara);
                              Get.snackbar('warning', 'Name is already exist');
                              Get.back();
                              playListNameController.clear();
                            }
                          }
                        },
                        child: const Text('create')),
                  ]);
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
                        'Create Playlist',
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
        if (playListController.playListNames.isEmpty)
          const Center(
            child: Text(
              'no playlist found',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          )
        else
          Positioned(
              top: 20.0.h,
              left: 20.0.w,
              right: 0.0.w,
              bottom: 80.0.h,
              child: SafeArea(
                child: GetBuilder<PlayListController>(
                    init: PlayListController(),
                    builder: (PlayListController mpData) {
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                mpData.playlistGet(mpData
                                    .playListNames[index]
                                    .toString());
                                Get.to(() => PlaylsitSongScreen(
                                      indexs: index,pController: mpData,
                                    ));
                              },
                              onLongPress: () {
                                Get.defaultDialog(
                                  title: 'Warning',
                                  content:
                                      const Text('Do you want to delete ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        mpData.playlistNameDelete(
                                            index,
                                            mpData.playListNames[index]
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
                              leading: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Material(
                                  elevation: 18.0,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50.0).r,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0).r,
                                    child: Image.asset(
                                      'assets/images/playlist-app-icon-button-260nw-1906619590.png',
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ),
                              ),
                              title:
                                  Text(mpData.playListNames[index].toString()),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: mpData.playListNames.length);
                    }),
              ))
        // themecyan(),
      ],
    );
  }
}
