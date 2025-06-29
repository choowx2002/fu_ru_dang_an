// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/search_model.dart';
import 'package:fu_ru_dang_an/views/widget_tree.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:window_size/window_size.dart';
// import 'package:flutter/foundation.dart';

const supabaseUrl = 'https://nibzqrneyjrvvzffschp.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pYnpxcm5leWpydnZ6ZmZzY2hwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3NDQyNzMsImV4cCI6MjA2NjMyMDI3M30.bAGzdYqa1eyvQzSRTxtvzNQVfag44rqybs0JN7RHEjg';

// void setupWindow() {
//   if (kIsWeb) return; // 在 Web 上跳过

//   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//     setWindowTitle('Centered Window');

//     const windowWidth = 1024.0;
//     const windowHeight = 800.0;

//     getCurrentScreen().then((screen) {
//       final screenFrame = screen?.frame ?? const Rect.fromLTWH(0, 0, 800, 600);

//       final left = screenFrame.left + (screenFrame.width - windowWidth) / 2;
//       final top = screenFrame.top + (screenFrame.height - windowHeight) / 2;

//       final frame = Rect.fromLTWH(left, top, windowWidth, windowHeight);
//       setWindowFrame(frame);
//     });

//     setWindowMinSize(Size(windowWidth, windowHeight));
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setupWindow();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  // testing purpose clear shared data
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SearchModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '符文档案',
      theme: ThemeData(
        fontFamily: 'NotoSansSC',
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Color.fromARGB(255, 26, 38, 59),
        ),
        useMaterial3: true,
      ),

      home: const SafeArea(child: WidgetTree()),
    );
  }
}
