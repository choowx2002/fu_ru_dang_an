import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/services/deck_builder_service.dart';
import 'package:provider/provider.dart';

class DeckBuilderPanel extends StatefulWidget {
  const DeckBuilderPanel({super.key});

  @override
  State<DeckBuilderPanel> createState() => _DeckBuilderPanelState();
}

class _DeckBuilderPanelState extends State<DeckBuilderPanel> {
  String deckName = "我的卡组";

  @override
  Widget build(BuildContext context) {
    final deckService = context.watch<DeckBuilderService>();
    final deck = deckService.deck;

    return Scaffold(
      appBar: AppBar(
        title: Text(deckName),
        actions: [
          IconButton(
            tooltip: "更换构筑名称",
            icon: Icon(Icons.edit),
            onPressed: () {
              var name = deckName;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("更换卡组名称"),
                  content: TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: InputDecoration(hintText: "输入新的卡组名称"),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("取消"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          deckName = name;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("确定"),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deckService.clearDeck();
            },
          ),
        ],
      ),
      // ignore: unnecessary_null_comparison
      body: deck == null
          ? Center(child: CircularProgressIndicator()) // 或 Loading
          : deck.isEmpty
          ? Center(child: Text("卡组为空"))
          : ListView.builder(
              itemCount: deck.length,
              itemBuilder: (context, index) {
                final card = deck[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(card.card.frontImage, width: 60),
                    title: Text(card.card.cardName),
                    subtitle: Text(card.card.cardCategoryName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 减号按钮
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            deckService.removeCard(card.card);
                          },
                          tooltip: "减少数量",
                        ),

                        // 数量文本
                        Text(
                          '${card.count}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // 加号按钮
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            deckService.addCard(card.card);
                          },
                          tooltip: "增加数量",
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(card.card.cardName),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(card.card.frontImage),
                              SizedBox(height: 8),
                              Text("效果：${card.card.cardEffect}"),
                              Text("稀有度：${card.count}"),
                              Text("战力：${card.card.power ?? '-'}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
