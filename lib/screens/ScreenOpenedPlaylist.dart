import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musica/palettes/ColorPalettes.dart';

class PlaylistOpen extends StatelessWidget {
  const PlaylistOpen({required this.playlistName, super.key});

  final String playlistName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text('$playlistName',style: TextStyle(color: kWhite),),
        leading: Icon(Icons.arrow_back,color: kWhite,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: kWhite,),),
          IconButton(onPressed: (){}, icon: Icon(Icons.add,color: kWhite,),),
        ],
      ),
    );
  }
}
