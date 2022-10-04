// ignore_for_file: unused_field, avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controller/music_controller.dart';

bool? notification;

class MpDrawer extends StatefulWidget {
  const MpDrawer({
    super.key,
    required this.mcontroller,
  });
  final MusicController mcontroller;

  @override
  State<MpDrawer> createState() => _MpDrawerState();
}

class _MpDrawerState extends State<MpDrawer> {
  late String _appName;
  late String _packageName;
  late String _version;
  late String _buildNumber;
  bool isloading = true;
  double rating = 0;

  Future<void> applicationinfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
    _packageName = packageInfo.packageName;
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;

    isloading = false;
    setState(() {});
  }

  Widget buildRating() {
    return RatingBar.builder(
      allowHalfRating: true,
      initialRating: rating,
      updateOnDrag: true,
      minRating: 0.5,
      itemBuilder: (BuildContext context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (double rating) {
        setState(() {
          this.rating = rating;
        });
      },
    );
  }

  void ratingShowDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Rting sample'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Leave a star rating'),
                const SizedBox(
                  height: 20,
                ),
                buildRating(),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Drawer(
            backgroundColor: const Color.fromARGB(91, 11, 185, 234),
            child: SafeArea(
              child: InkWell(
                  child: ListView(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                      onTap: () async {
                        await Share.share('My music app');

                        //share bottomsheet or some page navigation
                      },
                      leading: const Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Share',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )),
                  ListTile(
                    leading: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Notification',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    trailing: Switch(
                        value: notification ?? true ? true : false,
                        onChanged: (bool newValue) {
                          setState(() {
                            notification = newValue;
                           widget.mcontroller .audioPlayer.showNotification =
                                newValue;

                            // play(widget.audio, widget.value);
                          });

                          //set state switch value
                        }),
                  ),
                  ListTile(
                      onTap: () {
                        ratingShowDialog(context);
                        //rate us
                      },
                      leading: const Icon(
                        Icons.star_border_purple500_outlined,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Rate Us',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      trailing: Text(
                        '$rating',
                        style: const TextStyle(color: Colors.yellow),
                      )),
                  ListTile(
                    onTap: () {
                      //privacy page
                    },
                    leading: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Privacy policy',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: _appName,
                        applicationVersion: _version,
                      );

                      //about page navigation
                    },
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'About',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      applicationExit(context);
                      //exit from the app
                    },
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Text(
                      _version,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 232, 239, 11)),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )),
            ),
          );
  }

  @override
  void initState() {
    applicationinfo();

    super.initState();
  }
}

void applicationExit(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to exit'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'))
          ],
        );
      });
}

// PackageInfo packageInfo = PackageInfo(
//     appName: 'music_sample',
//     packageName: 'packageName',
//     version: 'version: 1.0.0+1',
//     buildNumber: 'buildNumber');
