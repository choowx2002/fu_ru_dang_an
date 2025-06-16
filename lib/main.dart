import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/notifiers.dart';
import 'package:fu_ru_dang_an/views/widget_tree.dart';

void main() {
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
            colorScheme: darkMode
                ? ColorScheme.fromSeed(
                    seedColor: Colors.lightBlue,
                    brightness: Brightness.dark,
                  )
                : ColorScheme.fromSeed(
                    seedColor: Colors.teal,
                    brightness: Brightness.light,
                  ),
            useMaterial3: true,
          ),

          home: const WidgetTree(),
        );
      },
    );
  }
}
