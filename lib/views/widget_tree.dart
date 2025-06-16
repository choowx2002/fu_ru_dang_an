import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/notifiers.dart';
import 'package:fu_ru_dang_an/views/drawer/drawer_footer_section.dart';
import 'package:fu_ru_dang_an/views/drawer/drawer_header_section.dart';
import 'package:fu_ru_dang_an/views/drawer/drawer_menu_section.dart';

import 'pages/card_list_page.dart';
import 'pages/home_page.dart';
import 'pages/setting_page.dart';

List<Widget> pages = [HomePage(), CardListPage(), SettingPage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTree();
}

class _WidgetTree extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
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
