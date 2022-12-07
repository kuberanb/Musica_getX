import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/mini_player_controller.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/views/ScreenNowPlaying.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer(
      {required this.songList,
      required this.index,
      required this.audioPlayer,
      super.key});

  final List<Songs> songList;
  final int index;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  List<Audio> songAudio = [];

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

   final miniPlayerController = Get.put(MiniPlayerController());

  void convertSong() {
    for (final song in widget.songList) {
      songAudio.add(
        Audio.file(
          song.uri,
          metas: Metas(
            id: song.id.toString(),
            title: song.title,
            artist: song.artist,
          ),
        ),
      );
    }
  }

  Future<void> openAudioPlayer() async {
    convertSong();

    await widget.audioPlayer.open(
      Playlist(audios: songAudio, startIndex: widget.index),
      autoStart: true,
      showNotification: true,
      loopMode: LoopMode.playlist,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
    );
  }

  @override
  void initState() {
    openAudioPlayer();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // widget.audioPlayer.stop();
    super.dispose();
  }


    void playorPauseButtonPressed()  {
      if (miniPlayerController.isPlaying == true) {
        //  setState(() async {
         widget.audioPlayer.pause();
        
          miniPlayerController.isPlaying = false;
        
      } else if (miniPlayerController.isPlaying == false) {
        //
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




  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;


    // void shuffleButtonPressed() {
    //   // isShuffle = !isShuffle;
    //   if (isShuffle == true) {
    //     setState(
    //       () {
    //         //  sh =kPink;
    //         widget.audioPlayer.toggleShuffle();
    //         isShuffle = !isShuffle;
    //       },
    //     );
    //   } else if (isShuffle == false) {
    //     setState(() {
    //       isShuffle = !isShuffle;
    //       //   sh =kWhite;
    //     });
    //   }
    // }

 

    return widget.audioPlayer.builderCurrent(
      builder: ((context, playing) {
        
        final myAudio = find(songAudio, playing.audio.assetAudioPath);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 0.22 * Screenheight,
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.circular(30
                // topLeft:  Radius.circular(20),
                // topRight: Radius.circular(20),

                ),
            border: Border.all(
              color: kWhite,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // SizedBox(height: 0.02*Screenheight,),
              SizedBox(
                height: 0.02 * Screenheight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => ScreenNowPlaying(
                              songList: songAudio,
                              index: widget.index,
                              audioPlayer: widget.audioPlayer,
                              id: myAudio.metas.id!)),
                        ),
                      );
                    }),
                    child: QueryArtworkWidget(
                      type: ArtworkType.AUDIO,
                      id: int.parse(widget.songList[widget.index].id),
                      nullArtworkWidget: ClipOval(
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/images/music.jpg',
                          fit: BoxFit.cover,
                          height: 51,
                          width: 51,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text(
                        myAudio.metas.title.toString(),
                        style:const TextStyle(color: kWhite, fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => ScreenNowPlaying(
                                songList: songAudio,
                                index: widget.index,
                                audioPlayer: widget.audioPlayer,
                                id: myAudio.metas.id!)),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.audioPlayer.stop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: kWhite,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 0.01 * Screenheight,
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  GetBuilder(
                    init: miniPlayerController,
                    builder: ((controller) => IconButton(
                    onPressed: () async {
                      shuffleButtonPressed();
                      miniPlayerController.update();
                    },
                    icon: (miniPlayerController.isShuffle == true)
                        ? const Icon(Icons.shuffle, color: kWhite, size: 32)
                        : const Icon(Icons.shuffle, color: kPink, size: 32),
                  )),),

                      
                  



                  IconButton(
                      disabledColor: kWhite,
                      focusColor: kPink,
                      onPressed: () {
                        widget.audioPlayer.previous();
                      },
                      icon:const Icon(Icons.skip_previous_rounded,
                          color: Colors.white, size: 32),
                          ),


                      GetBuilder(
                        init: miniPlayerController,
                        builder: ((controller) =>IconButton(
                    disabledColor: kWhite,
                    focusColor: kPink,
                    icon: Icon(
                      (miniPlayerController.isPlaying == true) ? Icons.pause : Icons.play_arrow,
                      color: kWhite,
                      size: 32,
                    ),
                    onPressed: () {
                      playorPauseButtonPressed();
                      miniPlayerController.update();
                    },
                  ) ),),

                  



                  IconButton(
                      disabledColor: kWhite,
                      focusColor: kPink,
                      onPressed: () {
                        widget.audioPlayer.next();
                      },
                      icon:
                         const Icon(Icons.skip_next, color: Colors.white, size: 32),
                         ),

                  GetBuilder(
                    init: miniPlayerController,
                    builder: ((controller) => IconButton(
                    disabledColor: kWhite,
                    focusColor: kPink,
                    icon: (miniPlayerController.isLoop == true)
                        ? const Icon(Icons.repeat, color: Colors.white, size: 32)
                        : const Icon(Icons.repeat_one, color: Colors.white, size: 32),
                    onPressed: () {
                      repeatButtonPressed();
                      miniPlayerController.update();
                    },
                  ))),

      
                  



                ],
              ),
              // SizedBox(height: Screenheight * 0.09),
            ],
          ),
        );
      }),
    );
  }
}
