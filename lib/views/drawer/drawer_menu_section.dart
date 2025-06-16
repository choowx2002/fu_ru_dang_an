import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/notifiers.dart';

class DrawerMenuSection extends StatelessWidget {
  const DrawerMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: const Text('卡牌预览'),
            onTap: () {
              selectedPageNotifier.value = 0;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('卡牌构筑'),
            onTap: () {
              selectedPageNotifier.value = 1;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
