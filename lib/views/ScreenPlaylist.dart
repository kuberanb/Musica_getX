import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/functions/MiscellaneousFunctions.dart';
import 'package:musica/functions/exit_dialog_box.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/widgets/CreatedPlaylistTile.dart';
import 'package:musica/widgets/CustomPlaylist.dart';

class ScreenPlaylist extends StatefulWidget {
  const ScreenPlaylist({super.key});

  @override
  State<ScreenPlaylist> createState() => _ScreenPlaylistState();
}

class _ScreenPlaylistState extends State<ScreenPlaylist> {
  Box<List> playlistBox = Hive.box<List>('Playlist');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);

        return false;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kBackgroundColor,
          centerTitle: true,
          title: const Text(
            'Your Library',
            style: TextStyle(
                color: kWhite, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showCreatingPlaylistDialoge(context: context);
              },
              icon: Icon(Icons.add),
              color: kWhite,
              iconSize: 25,
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: screenHeight * 0.22,
              width: double.infinity,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: const [
                    CustomPlaylist(
                        playlistName: 'Favourites',
                        playlistImage: 'assets/images/guitar.jpg'),
                    CustomPlaylist(
                        playlistName: 'Recent',
                        playlistImage: 'assets/images/livemusic.jpg'),
                    CustomPlaylist(
                        playlistName: 'Most Played',
                        playlistImage: 'assets/images/music.jpg')
                  ]),
            ),
            SizedBox(
              height: 0.03 * screenHeight,
            ),
            // SizedBox(width: 0.7*screenWidth,),
            Padding(
              padding: EdgeInsets.only(left: 0.045 * screenWidth),
              child: const Text(
                'Created Playlist ',
                style: TextStyle(
                    color: kWhite, fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 0.01 * screenHeight,
            ),

            Container(
              height: 0.75 * screenHeight,
              width: double.infinity,
              child: ValueListenableBuilder(
                valueListenable: playlistBox.listenable(),
                builder: ((context, value, child) {
                  List Keys = playlistBox.keys.toList();
                  Keys.removeWhere((key) => key == 'Favourites');
                  Keys.removeWhere((key) => key == 'Most Played');
                  Keys.removeWhere((key) => key == 'Recent');

                  return (Keys.isNotEmpty)
                      ? ListView.builder(
                          itemCount: Keys.length,
                          itemBuilder: ((context, index) {
                            final String playlistName = Keys[index];

                            final List<Songs> songList = playlistBox
                                .get(playlistName)!
                                .toList()
                                .cast<Songs>();

                            final songNum = songList.length;

                            return PlaylistTile(
                                playlistImage: index % 2 == 0
                                    ? 'assets/images/guitar.jpg'
                                    : 'assets/images/livemusic.jpg',
                                playlistName: playlistName,
                                songsNum: songNum);
                          }),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 0.2 * screenHeight,
                            ),
                            Text(
                              'No Created Playlist ...',
                              style: TextStyle(color: kWhite, fontSize: 18),
                            ),
                          ],
                        );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
