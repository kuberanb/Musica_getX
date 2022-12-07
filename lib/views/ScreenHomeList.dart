import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/screen_home_list_controller.dart';
import 'package:musica/functions/MiscellaneousFunctions.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/views/ScreenSearch.dart';
import 'package:musica/widgets/Song_List_Tile.dart';

class ScreenHomeList extends StatefulWidget {
  const ScreenHomeList({super.key});

  @override
  State<ScreenHomeList> createState() => _ScreenHomeListState();
}

class _ScreenHomeListState extends State<ScreenHomeList> {
  final screeHomeController = Get.put(ScreenHomeListController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kBackgroundColor,
        title: const Text(
          'All Songs',
          style: TextStyle(
              color: kWhite, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // const SearchScreen();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => SearchScreen(
                        audioPlayer: audioPlayer,
                      )),
                ),
              );
            },
            icon: const Icon(Icons.search, size: 25),
            color: kWhite,
          )
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return SongListTile(
            onpressed: () {
              showPlaylistbottomSheet(
                context: context,
                screenHeight: screenHeight,
                song: screeHomeController.songList[index],
              );
            },
            songList: screeHomeController.songList,
            index: index,
            audioPlayer: audioPlayer,
          );
        },
        itemCount: screeHomeController.songBox.length,
      ),
    );
  }
}
