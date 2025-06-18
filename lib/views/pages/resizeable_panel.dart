import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/views/pages/card_list_page.dart';
import 'package:fu_ru_dang_an/views/pages/create_page.dart';

class ResizablePanel extends StatefulWidget {
  const ResizablePanel({super.key});

  @override
  State<ResizablePanel> createState() => _ResizablePanelState();
}

class _ResizablePanelState extends State<ResizablePanel> {
  bool showDeckBuilder = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: CardListPage(), // 左侧卡牌浏览
            ),
            Center(
              child: Tooltip(
                message: showDeckBuilder ? "隐藏卡组构筑器" : "展开卡组构筑器",
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showDeckBuilder = !showDeckBuilder;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      showDeckBuilder ? Icons.arrow_right : Icons.arrow_left,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
            if (showDeckBuilder)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                width: 400,
                child: DeckBuilderPanel(), // 右侧卡组构筑界面
              ),
          ],
        );
      },
    );
  }
}
