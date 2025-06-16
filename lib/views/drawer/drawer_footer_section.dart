import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/notifiers.dart';

class DrawerFooterSection extends StatelessWidget {
  const DrawerFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('设置'),
                onTap: () {
                  selectedPageNotifier.value = 2;
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
