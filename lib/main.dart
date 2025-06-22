import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/notifiers.dart';
import 'package:fu_ru_dang_an/services/card_databse.dart';
import 'package:fu_ru_dang_an/services/deck_builder_service.dart';
import 'package:fu_ru_dang_an/views/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Centered Window');

    const windowWidth = 1024.0;
    const windowHeight = 800.0;

    getCurrentScreen().then((screen) {
      final screenFrame = screen?.frame ?? const Rect.fromLTWH(0, 0, 800, 600);

      final left = screenFrame.left + (screenFrame.width - windowWidth) / 2;
      final top = screenFrame.top + (screenFrame.height - windowHeight) / 2;

      final frame = Rect.fromLTWH(left, top, windowWidth, windowHeight);
      setWindowFrame(frame);
    });
    setWindowMinSize(Size.fromWidth(1024));
    setWindowMinSize(Size.fromHeight(800));    
  }
  await CardDatabase().loadCards();

  // testing purpose clear shared data
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => DeckBuilderService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDark,
      builder: (context, darkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'NotoSansSC',
            colorScheme: darkMode
                ? ColorScheme.fromSeed(
                    seedColor: Colors.teal,
                    brightness: Brightness.dark,
                  )
                : ColorScheme.fromSeed(
                    seedColor: Colors.teal,
                    brightness: Brightness.light,
                  ),
            useMaterial3: true,
          ),

          home: const SafeArea(child: WidgetTree()),
        );
      },
    );
  }
}
