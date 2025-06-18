import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/notifiers.dart';
import 'package:fu_ru_dang_an/views/widget_tree.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('符文构筑小工具');
    setWindowFrame(const Rect.fromLTWH(100, 100, 1024, 700));
    setWindowMinSize(Size.fromWidth(800));
  }
  runApp(const MyApp());
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
