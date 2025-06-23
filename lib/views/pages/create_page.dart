import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/config/constant.dart';
import 'package:fu_ru_dang_an/data/config/legend.dart';
import 'package:fu_ru_dang_an/services/card_databse.dart';
import 'package:fu_ru_dang_an/services/deck_builder_service.dart';
import 'package:fu_ru_dang_an/views/pages/card_list_page.dart';
import 'package:fu_ru_dang_an/views/widgets/card_image.dart';
import 'package:fu_ru_dang_an/views/widgets/rich_text_icons.dart';
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
      // appBar: AppBar(
      //   title: Text(deckName),
      //   actions: [
      //     IconButton(
      //       tooltip: "更换构筑名称",
      //       icon: Icon(Icons.edit),
      //       onPressed: () {
      //         var name = deckName;
      //         showDialog(
      //           context: context,
      //           builder: (_) => AlertDialog(
      //             title: Text("更换卡组名称"),
      //             content: TextField(
      //               onChanged: (value) {
      //                 name = value;
      //               },
      //               decoration: InputDecoration(hintText: "输入新的卡组名称"),
      //             ),
      //             actions: [
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: Text("取消"),
      //               ),
      //               TextButton(
      //                 onPressed: () {
      //                   setState(() {
      //                     deckName = name;
      //                   });
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: Text("确定"),
      //               ),
      //             ],
      //           ),
      //         );
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.delete),
      //       onPressed: () {
      //         deckService.clearDeck();
      //       },
      //     ),
      //   ],
      // ),
      // ignore: unnecessary_null_comparison
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          deck.legend.isEmpty
              ? SizedBox(width: 250, child: Center(child: Text("无传奇")))
              : SizedBox(
                  height: double.infinity,
                  width: 250,
                  child: Builder(
                    builder: (context) {
                      final card = CardDatabase().getCardByNo(deck.legend);
                      if (card == null) {
                        return Text("error");
                      } else {
                        final cardTags = legendaryCards[card.cardName]!;
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.5,
                              vertical: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 4.0,
                                  child: Image.network(
                                    card.frontImage,
                                    width: 225.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      card.cardName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: deck.runeDeck.entries.map((e) {
                                        final color = e.key;
                                        final count = e.value;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              deckService.modifiedRunes(color);
                                            },
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.asset(
                                                    cardColorIconMap[color]!,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                ),
                                                Text(count.toString()),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                Text(
                                  "英雄：${cardTags.champion.isNotEmpty ? cardTags.champion : '无'}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),

                                Text(
                                  "标签：${cardTags.tag.isNotEmpty ? cardTags.tag : '无'}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),

                                Text(
                                  "区域：${cardTags.region.isNotEmpty ? cardTags.region : '无'}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),

                                Divider(color: Colors.grey, thickness: 1),
                                RichTextWithIcons(
                                  text: card.cardEffect,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

          VerticalDivider(thickness: 2, indent: 8, endIndent: 8),

          Expanded(
            child: Column(
              children: [
                deck.mainDeck.isEmpty
                    ? Center(child: Text("卡组为空"))
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.593,
                                ),
                            itemCount: deck.mainDeck.length,
                            itemBuilder: (context, index) {
                              final entry = deck.mainDeck.entries
                                  .toList()[index];
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
                                          borderRadius:
                                              BorderRadiusGeometry.circular(12),
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
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 16.0,
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              GestureDetector(
                                                onTap: () {
                                                  deckService.addCard(card);
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  size: 16.0,
                                                ),
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
                        ),
                      ),

                Divider(thickness: 1),
                deck.battlefields.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: Center(child: Text("战地为空")),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.593,
                                ),
                            itemCount: deck.battlefields.length,
                            itemBuilder: (context, index) {
                              final battlefieldObj = deck.battlefields.entries
                                  .toList()[index];
                              final cardNo = battlefieldObj.key;
                              final card = CardDatabase().getCardByNo(cardNo);
                              return GestureDetector(
                                child: cardImage(card!),
                                onSecondaryTap: () =>
                                    showCardDetailsDialog(context, card),
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
