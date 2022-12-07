
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/views/ScreenNavigation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/ScreenSplash.dart';

class ScreenSpashController extends GetxController{


   @override
  void onInit() {
    // TODO: implement onInit
    fetchSongs();
    super.onInit();
  }

  Future<void> gotoscreen() async {
  await Future.delayed(const Duration(seconds: 2));
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: ((context) => const ScreenNavigation()),
  //   ),
  // );
   Get.to(()=> const ScreenNavigation());

}

OnAudioQuery audioQuery = OnAudioQuery();

  Box<Songs> songBox = Hive.box<Songs>('Songs');

  Box<List> playlistBox = Hive.box<List>('Playlist');

  List<SongModel> deviceSongs = [];

  List<SongModel> fetchedSongs = [];

  List<Songs> favSongs = [];

  List<Songs> recentSong = [];

  List<Songs> mostPlayedSongs = [];

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
    gotoscreen();
   
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

 

  
}