import '../../../controller/favorite_controller.dart';
import '../../../controller/music_controller.dart';
import '../../../model/hive/music_list_model.dart';


void favoriteSongModel(int index,FavoriteController controller) {
  final MusicModel data = MusicModel(
    id:controller.homeController.songsFromDb[index].id ,
    title: controller.homeController.songsFromDb[index].title,
    path: controller.homeController.songsFromDb[index].path,
    album: controller.homeController.songsFromDb[index].album,
    duration: controller.homeController.songsFromDb[index].duration,
  );
  

  controller.favoriteSongAdd(
    'favorites',
    data,
    index
  );
}
