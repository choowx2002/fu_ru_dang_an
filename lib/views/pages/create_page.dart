import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/services/card_databse.dart';
import 'package:fu_ru_dang_an/services/deck_builder_service.dart';
import 'package:fu_ru_dang_an/views/pages/card_list_page.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            deck.legend.isEmpty
                ? Center(child: Text("无传奇"))
                : Builder(
                    builder: (context) {
                      final card = CardDatabase().getCardByNo(deck.legend);
                      if (card == null) {
                        return Text("error");
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 4.0,
                              child: Image.network(
                                card.frontImage,
                                width: 200.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              card.cardName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              card.subTitle,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             Text(
                              card.tag.splitMapJoin(""),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),

            deck.mainDeck.isEmpty
                ? Center(child: Text("卡组为空"))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.593,
                    ),
                    itemCount: deck.mainDeck.length,
                    itemBuilder: (context, index) {
                      final entry = deck.mainDeck.entries.toList()[index];
                      final cardNo = entry.key;
                      final count = entry.value;
                      final card = CardDatabase().getCardByNo(cardNo);
                      if (card == null) {
                        return Text("error");
                      } else {
                        return Column(
                          children: [
                            GestureDetector(
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    12,
                                  ),
                                ),
                                child: Image.network(
                                  card.frontImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onSecondaryTap: () {
                                showCardDetailsDialog(context, card);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '数量：$count',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  // 减号按钮
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          deckService.removeCard(card);
                                        },
                                        child: Icon(Icons.remove, size: 16.0),
                                      ),
                                      SizedBox(width: 5.0),
                                      GestureDetector(
                                        onTap: () {
                                          deckService.addCard(card);
                                        },
                                        child: Icon(Icons.add, size: 16.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
