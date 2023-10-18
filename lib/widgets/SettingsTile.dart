import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musica/palettes/ColorPalettes.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    Key? key,
    required this.text,
    required this.ic,
    required this.onpressed,
  }) : super(key: key);

  final String text;
  final IconData ic;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    final textscale = MediaQuery.of(context).textScaleFactor;
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        IconButton(
          icon: Icon(
            ic,
            color: kPink,
            size: 22 * textscale, 
          ),
          onPressed: onpressed,
        ), 
        // SizedBox(
        //   width: 0.01 * screenWidth,  
        // ),
        TextButton(
          onPressed: onpressed,
          child: Text(
            text,
            style: TextStyle(color: kWhite, fontSize: 18 * textscale), 
          ),
        ),
      ],
    );
  }
}
