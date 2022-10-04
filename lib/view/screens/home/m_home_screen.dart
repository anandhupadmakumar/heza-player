import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/music_controller.dart';
import '../../colors/m_colors.dart';

import '../../widgets/home/list_view_widget.dart';
import '../../widgets/home/nav_bar.dart';
import '../../widgets/mini_player/mini_player.dart';
import '../favorite/m_fav_screen.dart';
import '../playlist/playlist_name_screen.dart';

import '../search/search_screen.dart';

class MHomeScreen extends StatelessWidget {
    MHomeScreen({super.key});
 
   final  MusicController homeController = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    // homecontoller.getPlalylistNames()
    // if (songsFromDbFav == null) {
    //   box.put('favorites', []);
    // }else{
    //    songsFromDbFav = box.get('favorites')! as List<MusicModel>;

    // }

    return Scaffold(
      drawer:  MpDrawer(mcontroller: homeController,),
      bottomSheet: BottomSheet(
          enableDrag: false,
          clipBehavior: Clip.antiAlias,
          onClosing: () {},
          builder: (BuildContext ctx) {
            return const MiniPlayerWidget();
          }),
      // drawer: MpDrawer(
      //   audioPlayer: audioPlayer,
      //   value: notification,
      // ),
      backgroundColor: const Color.fromARGB(255, 44, 43, 43),
      extendBody: true,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool value) {
            return <Widget>[
              SliverAppBar(
                // snap: true,
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        showSearch(
                            context: context, delegate: SongsSearch());
                      },
                      icon: const Icon(Icons.search)),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  // title: Text('MUSIC'),
                  centerTitle: true,
                  background: Image.asset(
                    'assets/images/dj.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                backgroundColor:
                    const Color.fromARGB(192, 3, 97, 116).withOpacity(1),
                elevation: 0.0,
                pinned: true,
                floating: true,
                expandedHeight: 150.h,
                title: const Text('HEZA '),
                centerTitle: true,
                bottom: const TabBar(tabs: <Widget>[
                  Tab(
                    text: 'All Songs',
                  ),
                  Tab(
                    text: 'Favorite ',
                  ),
                  Tab(
                    text: 'Playlist',
                  )
                ]),
              ),
            ];
          },
          body: TabBarView(children: <Widget>[
            Stack(
              fit: StackFit.expand,
              children: <Widget>[
                themeBlue(),
                themePink(),
                // themecyan(),
                 Positioned(
                  top: 0.0,
                  left: 20.0,
                  right: 0.0,
                  bottom: 80.0,
                  child: SafeArea(
                    child: ListViewWidget(hController: homeController,),
                  ),

                  //  HomeListView(assetsAudioplayer: assetsaudioPlayer,),
                ),
              ],
            ),
             FavoriteScreen(),
             PlayListNameScreen(),
          ]),
        ),
      ),
    );
  }
}
