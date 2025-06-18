import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fu_ru_dang_an/data/config/constant.dart';
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
  late Future<List<CardModel>> _futureCards;
  String _searchText = '';
  int count = 0;
  bool isFilter = false;
  Set<String> selectedColors = {};
  String? selectedCardCategory = "全部";
  String? selectedRarity = "全部";
  RangeValues _energyRangeValues = const RangeValues(0, 12);
  RangeValues _returnEnergyRangeValues = const RangeValues(0, 4);
  RangeValues _powerRangeValues = const RangeValues(0, 12);
  String sortBy = "id";
  bool isAscOrder = true;

  @override
  void initState() {
    super.initState();
    _futureCards = loadCardsFromAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500.0),
          child: Padding(
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
            children: [
              Text("搜索到$count张卡牌"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      focusColor: Colors.transparent,
                      isDense: true,
                      value: sortBy,
                      hint: const Text("选择排序"),
                      items: sortByOptions.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.value,
                          child: Text(e.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sortBy = value!;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    iconSize: 18.0,
                    onPressed: () {
                      setState(() {
                        isAscOrder = !isAscOrder;
                      });
                    },
                    icon: Icon(
                      isAscOrder
                          ? Icons.arrow_upward_sharp
                          : Icons.arrow_downward_sharp,
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    tooltip: isAscOrder ? "Ascending" : "Descending",
                  ),
                ],
              ),
            ],
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

                filtered.sort((a, b) {
                  dynamic aValue;
                  dynamic bValue;

                  switch (sortBy) {
                    case "id":
                      aValue = a.cardNo;
                      bValue = b.cardNo;
                      break;
                    case "energy":
                      aValue = a.energy ?? 0;
                      bValue = b.energy ?? 0;
                      break;
                    case "power":
                      aValue = a.returnEnergy ?? 0;
                      bValue = b.returnEnergy ?? 0;
                      break;
                    case "might":
                      aValue = a.power ?? 0;
                      bValue = b.power ?? 0;
                  }

                  if (isAscOrder) {
                    return Comparable.compare(aValue, bValue);
                  } else {
                    return Comparable.compare(bValue, aValue);
                  }
                });

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
