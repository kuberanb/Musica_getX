import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/views/ScreenFavouriteList.dart';

class CustomPlaylist extends StatelessWidget {
  const CustomPlaylist(
      {required this.playlistName, required this.playlistImage, super.key});

  final String playlistName;
  final String playlistImage;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    Box<List> playlistBox = Hive.box<List>('Playlist');
    final List<Songs> songList =
        playlistBox.get(playlistName)!.toList().cast<Songs>();

    return InkWell(
      onTap: (() {
        if (playlistName == 'Recent') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) =>
                  const ScreenFavourites(playlistName: 'Recent')),
            ),
          );
        } else if (playlistName == 'Most Played') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) =>
                  const ScreenFavourites(playlistName: 'Most Played')),
            ),
          );
        } else if (playlistName == 'Favourites') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) =>
                const  ScreenFavourites(playlistName: 'Favourites')),
            ),
          );
        }
      }),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            margin: const EdgeInsets.only(right: 15),
            width: 0.35 * screenWidth,
            height: 0.22 * screenHeight,
            child: ClipRRect(
              child: Image.asset(
                playlistImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0.17 * screenHeight,
            left: 0.02 * screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  playlistName,
                  style: const TextStyle(
                      color: kWhite, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  '${songList.length} Songs ',
                  style: const TextStyle(color: kWhite, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
