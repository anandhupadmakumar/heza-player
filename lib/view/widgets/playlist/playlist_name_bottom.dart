import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/playlist_controller.dart';
import 'bottom_sheet_palylist.dart';

class PlayListNameBottomSheet extends StatelessWidget {
   PlayListNameBottomSheet({
    super.key,
    required this.indexs,
    required this.addSongs,
  });
  final int indexs;
  final List<dynamic> addSongs;
  final PlayListController controller = Get.put(PlayListController());

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        backgroundColor: const Color.fromARGB(255, 33, 81, 88),
        onClosing: () {},
        builder: (BuildContext context) {
          return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    controller.playlistGet(
                        controller.playListNames[index].toString());
                    palylistMusicModelList(
                        indexs,
                        controller.playListNames[index].toString(),
                        addSongs,controller);
                    Get.back();
                  },
                  leading: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
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
                  title: Text(
                    controller.playListNames[index].toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemCount: controller.playListNames.length);
        });
  }
}
