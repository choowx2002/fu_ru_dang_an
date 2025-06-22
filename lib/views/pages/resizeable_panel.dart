import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/views/pages/card_list_page.dart';
import 'package:fu_ru_dang_an/views/pages/create_page.dart';

class ResizablePanel extends StatefulWidget {
  const ResizablePanel({super.key});

  @override
  State<ResizablePanel> createState() => _ResizablePanelState();
}

class _ResizablePanelState extends State<ResizablePanel> {
  bool showCardList = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [

            // 构筑区
            Expanded(
              child: DeckBuilderPanel(),
            ),

            // 分割线
            Center(
              child: Tooltip(
                message: showCardList ? "隐藏" : "展开",
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showCardList = !showCardList;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      showCardList ? Icons.arrow_right : Icons.arrow_left,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),

            // 搜索区
            if (showCardList)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                width: 350,
                child: CardListPage(), // 右侧卡组构筑界面
              ),
          ],
        );
      },
    );
  }
}
