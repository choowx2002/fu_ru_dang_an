import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/notifiers.dart';
import 'package:fu_ru_dang_an/views/drawer/drawer_footer_section.dart';
import 'package:fu_ru_dang_an/views/drawer/drawer_header_section.dart';
import 'package:fu_ru_dang_an/views/drawer/drawer_menu_section.dart';

import 'pages/deck_list_page.dart';
import 'pages/resizeable_panel.dart';
import 'pages/setting_page.dart';

List<Widget> pages = [ResizablePanel(), DeckListPage(), SettingPage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTree();
}

class _WidgetTree extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Builder(
      //   builder: (context) => FloatingActionButton(
      //     child: const Icon(Icons.menu),
      //     onPressed: () {
      //       Scaffold.of(context).openDrawer();
      //     },
      //   ),
      // ),
      appBar: AppBar(
        title: Text("符文档案"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 24,
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            DrawerHeaderSection(),
            DrawerMenuSection(),
            DrawerFooterSection(),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
    );
  }
}
