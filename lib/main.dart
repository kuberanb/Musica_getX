import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/screens/ScreenSplash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SongsAdapter());
  }

  await Hive.openBox<Songs>("Songs");
  await Hive.openBox<List>("Playlist");

  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
