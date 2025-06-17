import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fu_ru_dang_an/data/models/card_model.dart';
import 'package:fu_ru_dang_an/views/widgets/card_item.dart';
import 'package:fu_ru_dang_an/views/widgets/filter_controls.dart';
import 'package:fu_ru_dang_an/views/widgets/search_bar.dart';

Future<List<CardModel>> loadCardsFromAsset() async {
  final jsonStr = await rootBundle.loadString('assets/data/cards.json');
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((e) => CardModel.fromJson(e)).toList();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardModel> _allCards = [];
  String _searchText = '';
  int count = 0;
  bool isFilter = false;
  late Future<List<CardModel>> _futureCards;
  Set<String> selectedColors = {};

  final Map<String, String> allColors = {
    'red': "assets/icons/Fury.png",
    'green': "assets/icons/Calm.png",
    'blue': "assets/icons/Mind.png",
    'orange': "assets/icons/Body.png",
    'purple': "assets/icons/Chaos.png",
    'yellow': "assets/icons/Order.png",
  };

  final Map<String, Color> colorBackgrounds = {
    'red': Colors.red.shade200,
    'green': Colors.green.shade200,
    'blue': Colors.blue.shade200,
    'orange': Colors.orange.shade200,
    'purple': Colors.purple.shade200,
    'yellow': Colors.yellow.shade200,
  };

  String? selectedCardCategory = "全部";
  String? selectedRarity = "全部";

  final List<String> cardCategories = [
    '全部',
    '传奇',
    '专属法术',
    '英雄单位',
    '法术',
    '装备',
    '指示物单位',
    '符文',
    '单位',
    '战场',
  ];

  final List<String> cardRarities = ['全部', '普通', '不凡', '稀有', '史诗', '异画'];

  final Map<String, String?> cardRarityIconMap = {
    '普通': "assets/icons/common.png",
    '不凡': "assets/icons/uncommon.png",
    '稀有': "assets/icons/rare.png",
    '史诗': "assets/icons/epic.png",
    '异画': "assets/icons/overnumbered.png",
    '全部': null,
  };

  RangeValues _energyRangeValues = const RangeValues(0, 12);
  RangeValues _returnEnergyRangeValues = const RangeValues(0, 4);
  RangeValues _powerRangeValues = const RangeValues(0, 12);

  @override
  void initState() {
    super.initState();
    _futureCards = loadCardsFromAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 搜索框
              Expanded(
                child: SearchBarWidget(
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.trim();
                    });
                  },
                  query: _searchText,
                ),
              ),
              const SizedBox(width: 8.0),
              // 筛选按钮
              IconButton(
                onPressed: () {
                  setState(() {
                    isFilter = !isFilter;
                  });
                },
                icon: Icon(
                  isFilter ? Icons.filter_alt_sharp : Icons.filter_alt_outlined,
                  size: 28.0,
                ),
                tooltip: '筛选',
              ),
            ],
          ),
        ),

        if (isFilter)
          FilterControlsWidget(
            selectedRarity: selectedRarity,
            onRarityChanged: (value) {
              setState(() {
                selectedRarity = value;
              });
            },
            selectedColors: selectedColors,
            onColorChanged: (Set<String> value) {
              setState(() {
                selectedColors = value;
              });
            },
            selectedCategory: selectedCardCategory,
            onCategoryChanged: (String? value) {
              setState(() {
                selectedCardCategory = value;
              });
            },
            energyRangeValues: _energyRangeValues,
            powerRangeValues: _returnEnergyRangeValues,
            mightRangeValues: _powerRangeValues,
            onEnergyRangeChanged: (RangeValues value) {
              setState(() {
                _energyRangeValues = value;
              });
            },
            onPowerRangeChanged: (RangeValues value) {
              setState(() {
                _returnEnergyRangeValues = value;
              });
            },
            onMightRangeChanged: (RangeValues value) {
              setState(() {
                _powerRangeValues = value;
              });
            },
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("搜索到$count张卡牌"), Text("搜索到$count张卡牌")],
          ),
        ),

        Expanded(
          child: FutureBuilder<List<CardModel>>(
            future: _futureCards,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("错误：${snapshot.error}"));
              } else {
                _allCards = snapshot.data!;
                final filtered = _allCards.where((card) {
                  final matchName = card.cardName.contains(_searchText);
                  final matchColor =
                      selectedColors.isEmpty ||
                      card.cardColorList.any(
                        (color) => selectedColors.contains(color),
                      );
                  final matchCardCategory =
                      selectedCardCategory == "全部" ||
                      card.cardCategoryName == selectedCardCategory;
                  final matchRarity =
                      selectedRarity == "全部" ||
                      card.rarityName == selectedRarity;
                  final matchEnergy =
                      (_energyRangeValues.start == 0 &&
                          _energyRangeValues.end == 12)
                      ? true
                      : (card.energy != null &&
                            card.energy! >= _energyRangeValues.start &&
                            card.energy! <= _energyRangeValues.end);

                  final matchReturnEnergy =
                      (_returnEnergyRangeValues.start == 0 &&
                          _returnEnergyRangeValues.end == 4)
                      ? true
                      : (card.returnEnergy != null &&
                            card.returnEnergy! >=
                                _returnEnergyRangeValues.start &&
                            card.returnEnergy! <= _returnEnergyRangeValues.end);

                  final matchPower =
                      (_powerRangeValues.start == 0 &&
                          _powerRangeValues.end == 12)
                      ? true
                      : (card.power != null &&
                            card.power! >= _powerRangeValues.start &&
                            card.power! <= _powerRangeValues.end);
                  return matchName &&
                      matchColor &&
                      matchCardCategory &&
                      matchRarity &&
                      matchEnergy &&
                      matchReturnEnergy &&
                      matchPower;
                }).toList();

                if (count != filtered.length) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      count = filtered.length;
                    });
                  });
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final card = filtered[index];
                    return CardItem(card: card);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
