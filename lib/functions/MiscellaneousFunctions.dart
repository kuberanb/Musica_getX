import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica/functions/Playlist.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/views/ScreenHomeList.dart';
import 'package:musica/views/ScreenNavigation.dart';
import 'package:musica/widgets/MiniPlayer.dart';
import 'package:musica/widgets/playlistTileFullScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

showMiniPlayer({
  required BuildContext context,
  required int index,
  required List<Songs> songList,
  required AssetsAudioPlayer audioPlayer,
}) {
  return showBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: ((context) {
      return MiniPlayer(
          songList: songList, index: index, audioPlayer: audioPlayer);
    }),
  );
}

showPlaylistbottomSheet({
  required BuildContext context,
  required final screenHeight,
  required Songs song,
}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: ((context) {
      Box<List> playlistBox = Hive.box<List>('Playlist');
      return Container(
        width: double.infinity,
        height: 0.42 * screenHeight,
        //  color: kListTile,
        decoration: const BoxDecoration(
          color: kListTile,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showCreatingPlaylistDialoge(context: context);
              },
              icon: const Icon(
                Icons.playlist_add,
                color: kWhite,
                size: 18,
              ),
              label: const Text(
                'Create Playlist',
                style: TextStyle(color: kWhite),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: kListTile,
                shape: const StadiumBorder(),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: playlistBox.listenable(),
                builder: ((ctx, boxSongList, _) {
                  final List<dynamic> keys = playlistBox.keys.toList();

                  keys.removeWhere((Key) => Key == 'Playlist');
                  keys.removeWhere((Key) => Key == 'Recent');
                  keys.removeWhere((Key) => Key == 'Most Played');

                  return ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: ((context, index) {
                      final String PlaylistKey = keys[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () async {
                            UserPlaylist.addSongToPlaylist(
                                context: context,
                                songId: song.id,
                                playlistName: PlaylistKey);

                            Navigator.pop(context);
                            refreshUINavigationPage(context: context);
                          },
                          leading: const Text(
                            '🎧',
                            style: TextStyle(fontSize: 20),
                          ),
                          title: Text(
                            PlaylistKey,
                            style:const TextStyle(color: kWhite),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    }),
  );
}

showCreatingPlaylistDialoge({
  required BuildContext context,
}) {
  Box<List> playlistBox = Hive.box<List>('Playlist');
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final String playlistName = textEditingController.text;

  createPlaylist() async {
    List<Songs> songList = [];

    final String playlistName = textEditingController.text;

    if (playlistName.isEmpty) {
      return;
    }

    await playlistBox.put(playlistName, songList);
  }

  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        backgroundColor: kListTile,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Create Playlist',
          style: TextStyle(
              color: kWhite, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: textEditingController,
            style: const TextStyle(color: kWhite),
            keyboardType: TextInputType.text,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Playlist Name',
              hintStyle: TextStyle(color: kWhite),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, color: kWhite),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, color: kWhite),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  width: 1,
                  color: kWhite,
                ),
              ),
            ),
            validator: ((value) {
              final Keys = playlistBox.keys.toList();
              if (value == null || value.isEmpty) {
                return 'Enter Playlist Nmae';
              } else if (Keys.contains(value)) {
                return 'Playlist Name Already Exists';
              } else {
                return null;
              }
            }),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: kWhite),
              )),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await createPlaylist();
                Navigator.pop(context);
              }
            },
            child:const Text(
              'Confirm',
              style: TextStyle(color: kWhite),
            ),
          ),
        ],
      );
    }),
  );
}

showEditingPlaylistDialogue({
  required BuildContext context,
  required String playlistName,
}) {
  Box<List> playlistBox = Hive.box<List>('Playlist');
  final _formKey = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();
  textEditingController.text = playlistName;
  String textfirst = playlistName;

  createPlaylist() async {
    List<Songs> songList = [];

    // songList.add(playlistBox.get(playlistName)!.toList().cast<Songs>());

    final List<Songs> pl =
        playlistBox.get(playlistName)!.toList().cast<Songs>();

    for (final song in pl) {
      songList.add(song);
    }

    final String text = textEditingController.text;

    if (playlistName.isEmpty) {
      return;
    }

    await playlistBox.put(text, songList);
  }

  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        backgroundColor: kListTile,
        title: const Text(
          'Edit Playlist Name',
          style: TextStyle(color: kWhite),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: textEditingController,
            maxLines: 1,
            style: const TextStyle(color: kWhite),
            decoration: InputDecoration(
              //  hintText: 'Playlist Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, color: kWhite),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, color: kWhite),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  width: 2,
                  color: kWhite,
                ),
              ),
            ),
            validator: ((value) {
              final Keys = playlistBox.keys.toList();
              if (value == null || value.isEmpty) {
                return 'Values is Empty';
              } else if (Keys.contains(value)) {
                return 'Playlist Already Exists';
              } else {
                return null;
              }
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'CANCEL',
              style: TextStyle(color: kWhite),
            ),
          ),
          TextButton(
            onPressed: () async {
              _formKey.currentState!.validate();
              await createPlaylist();
              await playlistBox.delete(textfirst);

              Navigator.of(context).pop();
            },
            child: const Text(
              'CONFIRM',
              style: TextStyle(color: kWhite),
            ),
          ),
        ],
      );
    }),
  );
}

showSongModalSheet({
  required BuildContext context,
  required double screenHeight,
  required String playlistKey,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: ((ctx) {
      Box<Songs> songBox = Hive.box<Songs>('Songs');
      return Container(
        height: 0.55 * screenHeight,
        width: double.infinity,
        color: kListTile,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            const Text(
              'Add Song',
              style: TextStyle(color: kWhite, fontSize: 23),
            ),
            SizedBox(
              height: 0.01 * screenHeight,
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: songBox.listenable(),
                builder: ((BuildContext context, Box<Songs> boxSongs, _) {
                  return ListView.builder(
                    itemCount: boxSongs.values.length,
                    itemBuilder: ((ctx, index) {
                      final List<Songs> songList = boxSongs.values.toList();
                      // final playlistName = songList[index];
                      final Songs song = songList[index];
                      return ListTile(
                        onTap: () {
                          UserPlaylist.addSongToPlaylist(
                            context: context,
                            songId: song.id,
                            playlistName: playlistKey,
                          );

                          Navigator.pop(context);

                          refreshplaylistFullScreen(
                              playlistName: playlistKey, context: context);
                        },
                        leading: QueryArtworkWidget(
                          id: int.parse(song.id),
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.circular(10),
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/guitar.jpg',
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: kWhite),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    }),
  );
}

void refreshUINavigationPage({required BuildContext context}) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: ((context) => const ScreenNavigation())),
      (Route route) => false);
  // const ScreenHomeList();
}

void refreshplaylistFullScreen(
    {required String playlistName, required BuildContext context}) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: ((context) =>
            PlaylistTileFullScreen(playlistName: playlistName)),
      ),
      (route) => false);
}
