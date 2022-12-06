import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/screens/ScreenNavigation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

Future<void> gotoscreen(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: ((context) => const ScreenNavigation()),
    ),
  );
}

class _SplashScreenState extends State<SplashScreen> {
  OnAudioQuery audioQuery = OnAudioQuery();

  Box<Songs> songBox = Hive.box<Songs>('Songs');

  Box<List> playlistBox = Hive.box<List>('Playlist');

  List<SongModel> deviceSongs = [];

  List<SongModel> fetchedSongs = [];

  List<Songs> favSongs = [];

  List<Songs> recentSong = [];

  List<Songs> mostPlayedSongs = [];

  @override
  void initState() {

   // requestPermission();

    fetchSongs();

    // TODO: implement initState
   
    super.initState();
  }

  // Future<void> requestPermission() async {
  //  // setState(() async {

  //     await Permission.storage.request();

  // //  }
  //   //);
  //   //await Permission.audio.request();
  // }

  Future fetchSongs() async {

    await Permission.storage.request();

    final deviceSongs = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
      uriType: UriType.EXTERNAL,
    );

    for (final songs in deviceSongs) {
      if (songs.fileExtension == 'mp3' ||
          songs.fileExtension == 'aac' ||
          songs.fileExtension == 'wav') {
        fetchedSongs.add(songs);
      }
    }

    for (final audio in fetchedSongs) {
      final song = Songs(
          id: audio.id.toString(),
          title: audio.displayNameWOExt,
          artist: (audio.artist == null) ? 'Unknown' : audio.artist.toString(),
          uri: audio.uri!);

      await songBox.put(audio.id, song);
    }

    getFavSongs();
    getRecentSongs();
    getMostPlayedSongs();
    gotoscreen(context);
  }

  Future getFavSongs() async {
    if (!playlistBox.keys.contains('Favourites')) {
      await playlistBox.put('Favourites', favSongs);
    }
  }

  Future getMostPlayedSongs() async {
    if (!playlistBox.keys.contains('Most Played')) {
      await playlistBox.put('Most Played', mostPlayedSongs);
    }
  }

  Future getRecentSongs() async {
    if (!playlistBox.keys.contains('Recent')) {
      await playlistBox.put('Recent', recentSong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: kBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 0.2 * screenHeight,
                  width: 0.6 * screenWidth,
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(
                height: 0.03 * screenHeight,
              ),
              Text(
                'MUSICA',
                style: TextStyle(color: kWhite, fontSize: 19 * textScale),
              ),
              SizedBox(height: 0.05 * screenHeight),
              const CircularProgressIndicator(
                color: kWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
