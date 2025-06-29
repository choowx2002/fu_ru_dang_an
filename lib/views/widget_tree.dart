import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/views/pages/view_cards_page.dart';
import 'package:fu_ru_dang_an/views/widgets/build_deck.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});
  static final ValueNotifier<bool> showPanelNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ViewCardsPage(),

          ValueListenableBuilder<bool>(
            valueListenable: showPanelNotifier,
            builder: (context, show, _) {
              return show ? const BuildDeckPanel() : const SizedBox.shrink();
            },
          ),
        ],
      ),

      // floatingActionButton: Column(
      //   children: [
      //     FloatingActionButton(
      //       elevation: 4,
      //       onPressed: () {
      //         showPanelNotifier.value = !showPanelNotifier.value;
      //       },
      //       shape: const CircleBorder(),
      //       mouseCursor: SystemMouseCursors.click,
      //       backgroundColor: Theme.of(context).primaryColor,
      //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
      //       tooltip: "构筑栏",
      //       child: const Icon(Icons.book_online),
      //     ),
      //      FloatingActionButton(
      //       elevation: 4,
      //       onPressed: () {
      //         showPanelNotifier.value = !showPanelNotifier.value;
      //       },
      //       shape: const CircleBorder(),
      //       mouseCursor: SystemMouseCursors.click,
      //       backgroundColor: Theme.of(context).primaryColor,
      //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
      //       tooltip: "构筑栏",
      //       child: const Icon(Icons.book_online),
      //     ),
      //   ],
      // ),
    );
  }
}
