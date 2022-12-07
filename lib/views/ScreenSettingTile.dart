import 'package:flutter/material.dart';
 import 'package:flutter_html/flutter_html.dart';
import 'package:musica/palettes/ColorPalettes.dart';
// import 'package:music_player/texts/privacy.dart';
// import 'package:music_player/texts/terms_and_conditions.dart';
import 'package:musica/text/PrivacyPolicy.dart';
import 'package:musica/text/TermsConditions.dart';

// ignore: must_be_immutable
class ScreenSettingTile extends StatelessWidget {
  ScreenSettingTile({super.key, required this.screenName});
  final String screenName;
  String? screenContent;

  @override
  Widget build(BuildContext context) {
    screenContent =
        screenName == 'Privacy Policy' ? privacyPolicy : termsAndConditions;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          screenName,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Html(data: screenContent),
        ),
      ),
    );
  }
}
