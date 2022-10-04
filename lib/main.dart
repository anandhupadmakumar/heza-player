import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/hive/music_list_model.dart';
import 'view/screens/screen_splash/m_splash_screen.dart';

final Box<List<dynamic>> box = StorageBox.getInstance();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MusicModelAdapter());
  await Hive.openBox<List<dynamic>>(boxname);

  final List<dynamic> favKey = box.keys.toList();
  if (!favKey.contains('favorites')) {
    final List<dynamic> favouritesSongs = <dynamic>[];
    await box.put('favorites', favouritesSongs);
  }
  
  final List<dynamic> playListName = box.keys.toList();
  if (!playListName.contains('playlist_name')) {
   final  List<dynamic> playlistName =<dynamic> [];
    await box.put('playlist_name', playlistName);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      designSize: const Size(392.72727272727275, 781.0909090909091),
      builder: (BuildContext context, _) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:  MSplashScreen());
      },
    );
  }
}
