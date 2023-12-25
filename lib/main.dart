import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../homepage/homepage.dart';
import '../dark_mode/theme_provider.dart';
import 'package:uas_pemweb/views/favorite_view.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Provider.of<ThemeProvider>(context).themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/favorite': (context) => const FavoriteView(),
        });
  }
}
