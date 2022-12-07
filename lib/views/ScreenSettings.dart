import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/views/ScreenSettingTile.dart';
import 'package:musica/widgets/SettingsTile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

const String NOTIFICATION = 'NOTIFICATION';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({Key? key}) : super(key: key);

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  bool switchkey = true;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

    // bool SWITCHVALUE;

    // Future<void> setNotification(bool newValue) async {
    //   setState(() {
    //     SWITCHVALUE = newValue;
    //     SWITCHVALUE == true
    //         ? audioPlayer.showNotification = true
    //         : audioPlayer.showNotification = false;
    //   });

    //   SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    //   await sharedPrefs.setBool(NOTIFICATION, SWITCHVALUE!);
    // }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(color: kWhite, fontSize: 25),
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: Column(
        children: [
          SettingsTile(
            text: 'About me',
            ic: Icons.person_outline_outlined,
            onpressed: () {
              showAboutMe(context: context);
            },
          ),
          // SizedBox(
          //   height: 0.02 * screenHeight,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SettingsTile(
          //         text: 'Notification',
          //         ic: Icons.notifications_none_outlined,
          //         onpressed: () {}),
          //     Switch(
          //       value: SWITCHVALUE!,
          //         onChanged: (newValue) async {
          //           setNotification(newValue);
          //         },),

          //   ],
          // ),
          SizedBox(
            height: 0.02 * screenHeight,
          ),
          SettingsTile(
              text: 'Share',
              ic: Icons.share_outlined,
              onpressed: () async {
                Share.share(
                    'https://play.google.com/store/apps/details?id=com.example.musica',
                   // subject: 'Share it with your friends or Relatives ...'
                    );
              }),
          SizedBox(
            height: 0.02 * screenHeight,
          ),
          SettingsTile(
              text: 'Terms And Conditions',
              ic: Icons.warning_amber_rounded,
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ScreenSettingTile(
                        screenName: 'Terms And Conditions');
                  }),
                );
              }),
          SizedBox(
            height: 0.02 * screenHeight,
          ),
          SettingsTile(
              text: 'Privacy Policy',
              ic: Icons.privacy_tip_outlined,
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ScreenSettingTile(screenName: 'Privacy Policy');
                  }),
                );
              }),
          const Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 0.02 * screenHeight,
          ),
        ],
      ),
    );
  }
}

showAboutMe(
    {
    // required final screenHeight,
    required BuildContext context}) {
  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        backgroundColor: kListTile,
        title: const Text(
          'About Me',
          style: TextStyle(color: kWhite, fontSize: 24),
        ),
        content: const Text(
          '''I am Kuberan B, A Flutter Developer         
who Designed and Developed this Music Player APP 


To Contact : Kuberanbaluchami@gmail.com
        ''',
          style: TextStyle(color: kWhite, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: kWhite, fontSize: 20),
            ),
          ),
        ],
      );
    }),
  );
}
