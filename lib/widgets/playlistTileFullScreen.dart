import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/functions/MiscellaneousFunctions.dart';
import 'package:musica/functions/Playlist.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/widgets/CreatedPlaylist_ListTile.dart';
import 'package:musica/widgets/Song_List_Tile.dart';

import '../screens/ScreenNavigation.dart';

class PlaylistTileFullScreen extends StatefulWidget {
  const PlaylistTileFullScreen({required this.playlistName, super.key});

  final String playlistName;

  @override
  State<PlaylistTileFullScreen> createState() => _PlaylistTileFullScreenState();
}

class _PlaylistTileFullScreenState extends State<PlaylistTileFullScreen> {
  @override
  Widget build(BuildContext context) {
    Box<Songs> songBox = Hive.box<Songs>('Songs');

    Box<List> playlistBox = Hive.box<List>('Playlist');

    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

    List<Songs> songList = [];

    @override
    void initState() {
      // songList = playlistBox.get(widget.playlistName)!.toList().cast<Songs>();
      super.initState();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    songList = playlistBox.get(widget.playlistName)!.toList().cast<Songs>();

    Future<bool> _onWillPop() async {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ScreenNavigation(),
          ),
          (route) => false);
      return false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          title: Text(
            widget.playlistName,
            style: const TextStyle(color: kWhite),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: ((context) => const ScreenNavigation()),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(
              onPressed: () {
                //  setState(() {
                showSongModalSheet(
                    context: context,
                    screenHeight: screenHeight,
                    playlistKey: widget.playlistName);
                //   });
              },
              icon: const Icon(
                Icons.add,
                size: 24,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: songList.length,
            itemBuilder: ((context, index) {
              return CreatedPlaylistTile(
                  onpressed: () {
                    setState(() {
                      UserPlaylist.deleteFromPlaylist(
                        context: context,
                        songId: songList[index].id,
                        playlistName: widget.playlistName,
                      );
                    });
                  },
                  index: index,
                  audioPlayer: audioPlayer,
                  songList: songList);
            }),
          ),
        ),
      ),
    );
  }
}
