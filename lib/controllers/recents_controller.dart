

import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica/controllers/most_played_controller.dart';
import 'package:musica/models/songs.dart';

class RecentsController extends GetxController{

//final mostPlayedController = Get.find<MostPlayedController>();

final mostPlayedController = Get.put(MostPlayedController());
  @override
  void onInit() {
    // TODO: implement onInit

    
    super.onInit();
  }

  
 final Box<Songs> songBox = Hive.box<Songs>('Songs');
   final Box<List> playlistBox = Hive.box<List>('Playlist');

   addSongsToRecents({required String songId}) async {
    
    final List<Songs> dbSongs = songBox.values.toList().cast<Songs>();
    final List<Songs> recentSongList =
        playlistBox.get('Recent')!.toList().cast<Songs>();

    final Songs recentSong =
        dbSongs.firstWhere((song) => song.id.contains(songId));
        
    /////////////////---------For Most Played----------///////////////////////////
    int count = recentSong.count;
    recentSong.count = count + 1;
    log(recentSong.count.toString());
    //////////////////////////////////////////////////////////////////////////////
    /////////////////---------Calling MostPlayed---------/////////////////////////
    mostPlayedController.addSongToPlaylist(songId);
    //////////////////////////////////////////////////////////////////////////////
    if (recentSongList.length >= 10) {
      recentSongList.removeLast();
    }
    if (recentSongList.where((song) => song.id == recentSong.id).isEmpty) {
      recentSongList.insert(0, recentSong);
      await playlistBox.put('Recent', recentSongList);
    } else {
      recentSongList.removeWhere((song) => song.id == recentSong.id);
      recentSongList.insert(0, recentSong);
      await playlistBox.put('Recent', recentSongList);
    }

  }


}