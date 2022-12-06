import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/functions/MiscellaneousFunctions.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/widgets/playlistTileFullScreen.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile(
      {required this.playlistImage,
      required this.playlistName,
      required this.songsNum,
      super.key});

  final String playlistImage;
  final String playlistName;
  final songsNum;

  @override
  Widget build(BuildContext context) {
    Box<List> playlistBox = Hive.box<List>('Playlist');

    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(0.01 * screenHeight),
      child: Container(
                   

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: kListTile),
        width: double.infinity,
        height: 0.1 * screenHeight,
        child: InkWell(
          onTap: (() {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: ((context) => PlaylistTile(
            //         playlistImage: playlistImage,
            //         playlistName: playlistName,
            //         songsNum: songsNum)),),);

            Navigator.of(context).push(MaterialPageRoute(builder: ((context) => PlaylistTileFullScreen(playlistName: playlistName))));


          }),
          child: ListTile(
            
            tileColor: kListTile,
            leading: ClipOval(
              child: Image.asset(
                filterQuality: FilterQuality.high,
                playlistImage,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              '$playlistName',
              style: TextStyle(color: kWhite),
            ),
            subtitle: Text(
              '$songsNum Songs',
              style: const TextStyle(color: kWhite),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showEditingPlaylistDialogue(
                        context: context, playlistName: playlistName);
                  },
                  icon: const Icon(
                    Icons.edit_note_outlined,
                    size: 27,
                    color: kWhite,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await playlistBox.delete(playlistName);
                  },
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    size: 27,
                    color: kWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
