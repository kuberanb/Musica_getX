import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/widgets/Song_List_Tile.dart';

import '../functions/MiscellaneousFunctions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({required this.audioPlayer, super.key});

  final AssetsAudioPlayer audioPlayer;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _SearchController = TextEditingController();

  // AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  Box<Songs> songBox = Hive.box<Songs>('Songs');

  List<Songs>? dbSongs;
//songBox.values.toList().cast<Songs>();

  List<Songs>? searchedSongs;

  @override
  void initState() {
    dbSongs = songBox.values.toList().cast<Songs>();
    searchedSongs = List<Songs>.from(dbSongs!).toList().cast<Songs>();
    // TODO: implement initState
    super.initState();
  }

  searchSongFromDb(String name) {
    setState(() {
      searchedSongs = dbSongs!
          .where(
              (song) => song.title.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: kBackgroundColor,
        title: const Text(
          'Search Songs',
          style: TextStyle(color: kWhite),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 0.01 * screenHeight,
              ),
              TextFormField(
                controller: _SearchController,
                validator: (value) {
                  return null;
                },
                style: const TextStyle(color: kWhite, fontSize: 18),
                maxLines: 1,
                decoration: InputDecoration(
                  fillColor: kWhite,
                  focusColor: kWhite,
                  hintText: 'Search Songs',
                  labelText: 'Search',
                  labelStyle: const TextStyle(color: kWhite),
                  hintStyle: const TextStyle(color: kWhite),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: kWhite,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 2, color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 2,
                      color: kWhite,
                    ),
                  ),
                ),
                onChanged: ((value) {
                  searchSongFromDb(value);
                }),
              ),
              SizedBox(
                height: 0.02 * screenHeight,
              ),
              Expanded(
                child: (searchedSongs!.isEmpty)
                    ? const Center(
                        child: Text('No Songs Found',style: TextStyle(color: kWhite),),
                      )
                    : ListView.builder(
                        itemCount: searchedSongs?.length,
                        itemBuilder: ((context, index) {
                          return SongListTile(
                              onpressed: () {
                                showPlaylistbottomSheet(
                                  context: context,
                                  screenHeight: screenHeight,
                                  song: dbSongs![index],
                                );
                              },
                              index: index,
                              audioPlayer: widget.audioPlayer,
                              songList: searchedSongs!);
                        }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
