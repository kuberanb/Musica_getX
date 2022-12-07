
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica/controllers/Favourite_controller.dart';
import 'package:musica/controllers/recents_controller.dart';
import 'package:musica/functions/MiscellaneousFunctions.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../functions/Favourites.dart';

class CreatedPlaylistTile extends StatefulWidget {
  const CreatedPlaylistTile({super.key,
  this.icon = Icons.delete,
    required this.onpressed,
    required this.index,
    required this.audioPlayer,
    required this.songList,
  
  
  });

  final IconData icon;
  final void Function()? onpressed;
  final int index;
  final AssetsAudioPlayer audioPlayer;
  final List<Songs> songList;


  @override
  State<CreatedPlaylistTile> createState() => _CreatedPlaylistTileState();
}

class _CreatedPlaylistTileState extends State<CreatedPlaylistTile> {
 Box<Songs> songBox = Hive.box<Songs>('Songs');

  Box<List> playlistBox = Hive.box<List>('Playlist');
  final recentsController = Get.find<RecentsController>();
  final favouritesContoller = Get.find<FavouriteController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

          width:0.8*screenWidth,
          height: 0.1 * screenHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: kListTile),

        child: ListTile(
          
          onTap: () {
            recentsController.addSongsToRecents(songId: widget.songList[widget.index].id);
            showMiniPlayer(context: context, index: widget.index, songList: widget.songList, audioPlayer: widget.audioPlayer);


          },
          contentPadding: const EdgeInsets.all(0),
          leading: Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: QueryArtworkWidget(
              type: ArtworkType.AUDIO,
              id: int.parse(widget.songList[widget.index].id),
              nullArtworkWidget: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/music.jpg',
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ),
          title: Text(
            widget.songList[widget.index].title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: kWhite),
          ),
          subtitle: Text(
            widget.songList[widget.index].artist == '<unknown>'
                ? 'UnKnown'
                : widget.songList[widget.index].artist,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w300, color: kWhite),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              IconButton(
                padding: const EdgeInsets.only(left: 0),
                onPressed: widget.onpressed,
                icon: Icon(
                  widget.icon,
                  color: kWhite,
                  size: 25,
                ),
              ),

              
              IconButton(
                onPressed: () {
                  favouritesContoller.addSongToFavourites(
                    context: context,
                    id: widget.songList[widget.index].id,
                  );
                  setState(() {
                    favouritesContoller.isThisFavourite(
                      id: widget.songList[widget.index].id,
                    );
                  });
                },
                icon: Icon(
                  favouritesContoller.isThisFavourite(
                    id: widget.songList[widget.index].id,
                  ),
                  color: kWhite,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}