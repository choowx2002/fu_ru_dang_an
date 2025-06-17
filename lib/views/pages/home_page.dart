import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fu_ru_dang_an/data/models/card_model.dart';

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
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(),
                    hintText: '输入卡牌名称搜索',
                  ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      // 符文
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "符文",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children: allColors.entries.map((entry) {
                              final colorKey = entry.key;
                              final iconPath = entry.value;
                              final isSelected = selectedColors.contains(
                                colorKey,
                              );

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedColors.remove(colorKey);
                                    } else {
                                      selectedColors.add(colorKey);
                                    }
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorBackgrounds[colorKey]
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(iconPath),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      // 卡牌类型
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "卡牌类型",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: selectedCardCategory,
                            hint: const Text("选择卡牌分类"),
                            items: cardCategories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCardCategory = value;
                              });
                            },
                          ),
                        ],
                      ),

                      // 稀有度
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "稀有度",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: selectedRarity,
                            hint: const Text("选择稀有度"),
                            items: cardRarities.map((rarity) {
                              final iconPath = cardRarityIconMap[rarity];
                              return DropdownMenuItem<String>(
                                value: rarity,
                                child: iconPath != null
                                    ? Row(
                                        children: [
                                          Image.asset(
                                            iconPath,
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(rarity),
                                        ],
                                      )
                                    : Text(rarity),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRarity = value;
                              });
                            },
                          ),
                        ],
                      ),

                      // 法力费用
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "法力费用",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (_energyRangeValues ==
                                    const RangeValues(0, 12))
                                  const Text(
                                    "全部",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                else
                                  Text(
                                    "${_energyRangeValues.start.round()}-${_energyRangeValues.end.round()}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            RangeSlider(
                              values: _energyRangeValues,
                              min: 0,
                              max: 12,
                              divisions: 12,
                              labels: RangeLabels(
                                _energyRangeValues.start.round().toString(),
                                _energyRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _energyRangeValues = values;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // 符能费用
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "符能费用",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _returnEnergyRangeValues ==
                                          const RangeValues(0, 4)
                                      ? "全部"
                                      : "${_returnEnergyRangeValues.start.round()}-${_returnEnergyRangeValues.end.round()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: _returnEnergyRangeValues,
                              min: 0,
                              max: 4,
                              divisions: 4,
                              labels: RangeLabels(
                                _returnEnergyRangeValues.start
                                    .round()
                                    .toString(),
                                _returnEnergyRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _returnEnergyRangeValues = values;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // 战力
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "战力",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _powerRangeValues == const RangeValues(0, 12)
                                      ? "全部"
                                      : "${_powerRangeValues.start.round()}-${_powerRangeValues.end.round()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: _powerRangeValues,
                              min: 0,
                              max: 12,
                              divisions: 12,
                              labels: RangeLabels(
                                _powerRangeValues.start.round().toString(),
                                _powerRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _powerRangeValues = values;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("搜索到$count张卡牌")],
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
                    return Column(
                      children: [
                        Image.network(
                          card.frontImage,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(color: Colors.grey.shade300);
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.cardName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
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
