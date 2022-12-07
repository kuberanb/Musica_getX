import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/models/songs.dart';

class ScreenHomeListController extends GetxController {
  Box<Songs> songBox = Hive.box<Songs>('Songs');

  Box<List> playlistBox = Hive.box<List>('Playlist');

  List<Songs> songList = [];

  @override
  void onInit() {
    // TODO: implement onInit

    final List<int> Keys = songBox.keys.toList().cast<int>();

    for (final key in Keys) {
      songList.add(songBox.get(key)!);
    }
    print(songBox.length);

    super.onInit();
  }
}
