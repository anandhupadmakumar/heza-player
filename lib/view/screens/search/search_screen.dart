import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/music_controller.dart';
import '../screen_splash/m_splash_screen.dart';

class SongsSearch extends SearchDelegate<dynamic> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(
              context,
              null,
            );
          } else {
            query = ' ';
          }
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      textTheme: const TextTheme(
        displayMedium: TextStyle(
          color: Colors.white,
        ),
      ),
      hintColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 38, 231, 238),
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          const InputDecorationTheme(
            border: InputBorder.none,
          ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
          context,
          null,
        );
      },
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

// search element
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Audio> searched = Get.find<MusicController>().mMusicListMain1
        .toList()
        .where(
          (Audio element) => element.metas.title!.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 38, 38),
      body: searched.isEmpty
          ? const Center(
              child: Text(
                'No Search Result !',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 21, 132, 145),
                        borderRadius: BorderRadius.circular(15).r,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          maxRadius: 30.r,

                          backgroundImage: const AssetImage(
                              'assets/images/music logomp3.jpg'),
                          
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: const Color.fromARGB(255, 41, 41, 41)
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
                        onTap: () async {
                          Navigator.pop(context);
                          await Get.find<MusicController>().musicPlay(
                            searched,
                          );
                          await Get.find<MusicController>().audioPlayer
                              .playlistPlayAtIndex(index);
                        },
                        title: Padding(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            bottom: 3,
                            top: 3,
                          ),
                          child: Text(
                            searched[index].metas.title!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(
                            left: 7.0,
                          ),
                          child: Text(
                            Get.find<MusicController>().mMusicListMain1[index].metas.artist!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemCount: searched.length),
            ),
    );
  }
}
