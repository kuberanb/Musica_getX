import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/functions/MiscellaneousFunctions.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/widgets/Song_List_Tile.dart';

class ScreenFavourites extends StatelessWidget {
  const ScreenFavourites({required this.playlistName, super.key});

  final String playlistName;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    Box<List> playlistBox = Hive.box<List>('Playlist');

    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
    final List<Songs> songList =
        playlistBox.get(playlistName)!.toList().cast<Songs>();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text('${playlistName}'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: (songList.isNotEmpty)
          ? ListView.builder(
              itemCount: songList.length,
              itemBuilder: ((context, index) {
                return SongListTile(
                    onpressed: () {
                      showPlaylistbottomSheet(
                          context: context,
                          screenHeight: screenHeight,
                          song: songList[index]);
                    },
                    index: index,
                    audioPlayer: audioPlayer,
                    songList: songList);
              }),
            )
          :const Center(
              child: Text(
                'No Songs Added ...',
                style: TextStyle(color: kWhite, fontSize: 18),
              ),
            ),
    );
  }
}
