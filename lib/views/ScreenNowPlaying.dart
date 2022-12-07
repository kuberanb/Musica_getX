import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/Favourite_controller.dart';
import 'package:musica/controllers/mini_player_controller.dart';
import 'package:musica/palettes/ColorPalettes.dart';

import 'package:on_audio_query/on_audio_query.dart';

class ScreenNowPlaying extends StatefulWidget {
  const ScreenNowPlaying({
    super.key,
    required this.songList,
    required this.index,
    required this.audioPlayer,
    required this.id,
  });

  final List<Audio> songList;
  final int index;
  final String id;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  IconData? favIcon;

  final favouritesController = Get.find<FavouriteController>();
  final miniPlayerController = Get.find<MiniPlayerController>();

  @override
  void initState() {
    favIcon = favouritesController.isThisFavourite(
      id: widget.id,
    );

    super.initState();
  }

  // bool isPlaying = true;
  // bool isLoop = true;
  // bool isShuffle = true;

  void playOrPauseButtonPressed() {
    if (miniPlayerController.isPlaying == true) {
      widget.audioPlayer.pause();

      miniPlayerController.isPlaying = false;
    } else if (miniPlayerController.isPlaying == false) {
      widget.audioPlayer.play();

      miniPlayerController.isPlaying = true;
    }
  }

  void shuffleButtonPressed() {
    widget.audioPlayer.toggleShuffle();
    miniPlayerController.isShuffle = !miniPlayerController.isShuffle;
  }

  void repeatButtonPressed() {
    if (miniPlayerController.isLoop == true) {
      widget.audioPlayer.setLoopMode(LoopMode.single);
    } else {
      widget.audioPlayer.setLoopMode(LoopMode.playlist);
    }

    miniPlayerController.isLoop = !miniPlayerController.isLoop;
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) {
      return element.path == fromPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            miniPlayerController.update();
          },
        ),
        // centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Now Playing',
          style: TextStyle(
              fontSize: 21, fontWeight: FontWeight.w600, color: kWhite),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(0.05 * screenWidth),
          child: widget.audioPlayer.builderCurrent(
            builder: (context, playing) {
              final myAudio =
                  find(widget.songList, playing.audio.assetAudioPath);
              return Column(
                children: [
                  SizedBox(
                    height: 0.02 * screenHeight,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5 * screenHeight,
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.circular(5
                          // topLeft:  Radius.circular(20),
                          // topRight: Radius.circular(20),

                          ),
                      border: Border.all(
                        color: kBottomIconColor,
                        width: 5,
                      ),
                    ),
                    child: QueryArtworkWidget(
                      artworkBorder: const BorderRadius.all(Radius.zero),
                      type: ArtworkType.AUDIO,
                      id: int.parse(myAudio.metas.id!),
                      nullArtworkWidget: ClipRect(
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/images/music.jpg',
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        widget.audioPlayer.getCurrentAudioTitle,
                        style: const TextStyle(color: kWhite, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      // SizedBox(width: 0.2*screenWidth,),

                      GetBuilder(
                        init: favouritesController,
                        builder: ((controller) => IconButton(
                              onPressed: () {
                                favouritesController.addSongToFavourites(
                                  context: context,
                                  id: myAudio.metas.id!,
                                );
                                favouritesController.update();
                              },
                              icon: Icon(
                                favouritesController.isThisFavourite(
                                    id: myAudio.metas.id!),
                                color: kWhite,
                                size: 25,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (widget.audioPlayer.getCurrentAudioArtist) ==
                                  '<unknown>'
                              ? 'Unknown'
                              : widget.audioPlayer.getCurrentAudioArtist,
                          style: const TextStyle(color: kWhite, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 0.35 * screenWidth,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  widget.audioPlayer.builderRealtimePlayingInfos(
                    builder: (context, info) {
                      //  print( info.current);
                      //  final k =info.current??"";

                      // final t = info.current!.audio.duration;
                      final _duration = info.current!.audio.duration;
                      final _position = info.currentPosition;

                      return ProgressBar(
                        progress: _position,
                        total: _duration,
                        progressBarColor: kPink,
                        baseBarColor: kWhite,
                        thumbColor: kPink,
                        bufferedBarColor: Colors.white.withOpacity(0.24),
                        barHeight: 7.0,
                        thumbRadius: 9.0,
                        onSeek: (duration) {
                          widget.audioPlayer.seek(duration);
                        },
                        timeLabelPadding: 10,
                        timeLabelTextStyle: const TextStyle(
                          color: kBottomIconColor,
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 0.03 * screenHeight,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GetBuilder(
                          init: miniPlayerController,
                          builder: ((controller) => IconButton(
                                onPressed: () {
                                  shuffleButtonPressed();
                                  miniPlayerController.update();
                                },
                                icon: (miniPlayerController.isShuffle == true)
                                    ? const Icon(Icons.shuffle,
                                        color: kWhite, size: 32)
                                    : const Icon(Icons.shuffle,
                                        color: kPink, size: 32),
                              ))),
                      IconButton(
                          disabledColor: kWhite,
                          focusColor: kPink,
                          onPressed: () {
                            widget.audioPlayer.previous();
                          },
                          icon: const Icon(Icons.skip_previous_rounded,
                              color: Colors.white, size: 32)),
                      GetBuilder(
                        init: miniPlayerController,
                        builder: ((controller) => IconButton(
                              disabledColor: kWhite,
                              focusColor: kPink,
                              icon: Icon(
                                (miniPlayerController.isPlaying == true)
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: kWhite,
                                size: 35,
                              ),
                              onPressed: () {
                                playOrPauseButtonPressed();
                                miniPlayerController.update();
                              },
                            )),
                      ),
                      IconButton(
                        disabledColor: kWhite,
                        focusColor: kPink,
                        onPressed: () {
                          widget.audioPlayer.next();
                        },
                        icon: const Icon(Icons.skip_next,
                            color: Colors.white, size: 32),
                      ),
                      GetBuilder(
                          init: miniPlayerController,
                          builder: ((controller) => IconButton(
                                disabledColor: kWhite,
                                focusColor: kPink,
                                icon: (miniPlayerController.isLoop == true)
                                    ? const Icon(Icons.repeat,
                                        color: Colors.white, size: 32)
                                    : const Icon(Icons.repeat_one,
                                        color: Colors.white, size: 32),
                                onPressed: () {
                                  repeatButtonPressed();
                                  miniPlayerController.update();
                                },
                              ))),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
