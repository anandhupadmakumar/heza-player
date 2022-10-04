import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/favorite_controller.dart';



import 'functions.dart';

class BottomSheetListViewWidget extends StatelessWidget {
  const BottomSheetListViewWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(
        init: FavoriteController(),
        builder: (FavoriteController cntrl) {
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
                          cntrl.homeController.songsFromDb[index].title ?? 'unknown',
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      if (cntrl.songsFromDbFav
                          .where((dynamic element) =>
                              element.id == cntrl.homeController.songsFromDb[index].id)
                          .isEmpty)
                        IconButton(
                          onPressed: () {
                            favoriteSongModel(index,cntrl);
                          },
                          icon: const Icon(Icons.add_circle_outline_sharp),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            cntrl.favDeleteSongs(
                                cntrl.homeController.songsFromDb[index].id ?? 0, index);
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
                          cntrl.homeController.songsFromDb[index].album ?? 'unknown',
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Text(cntrl.homeController.songsFromDb[index].duration)
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 2,
                );
              },
              itemCount: cntrl.homeController.songsFromDb.length);
        });
  }
}
