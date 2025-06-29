import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/config/constant.dart'
    show
        cardCategoryOptions,
        cardColorIconMap,
        cardColorOptions,
        cardRarityIconMap,
        cardRarityOptions,
        colorBackgrounds,
        energyConfig,
        mightConfig,
        powerConfig;
import 'package:fu_ru_dang_an/data/models/search_model.dart';
import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart'
    show DBCardModel;
import 'package:fu_ru_dang_an/views/widgets/card_details_dialog.dart';
import 'package:fu_ru_dang_an/views/widgets/card_tile.dart';
import 'package:fu_ru_dang_an/views/widgets/cards_filter_bar.dart';
import 'package:fu_ru_dang_an/views/widgets/range_slider.dart';
import 'package:provider/provider.dart';

class ViewCardsPage extends StatefulWidget {
  const ViewCardsPage({super.key});

  @override
  State<ViewCardsPage> createState() => _ViewCardsPageState();
}

class _ViewCardsPageState extends State<ViewCardsPage> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    final model = context.read<SearchModel>();
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 10) {
          model.loadNextPage();
        }
      });
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.resetPage();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted() {
    final model = Provider.of<SearchModel>(context, listen: false);
    final rawQuery = _searchController.text.trim().toLowerCase();
    model.updateQuery(rawQuery);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SearchModel>(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1280.0),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.only(top: 20),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardsFilterBar(
                    searchController: _searchController,
                    onSearchPressed: _onSearchSubmitted,
                    onOpenFilterPressed: _showFilterDialog,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 12,
                    ),
                    child: Wrap(
                      spacing: 3.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('搜索到${model.count.toString()}张'),
                        if (model.query.trim().isNotEmpty)
                          Chip(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 0,
                            ),
                            label: Text('搜索词：${model.query}'),
                            onDeleted: () {
                              model.updateQuery('');
                              _searchController.clear();
                            }, // (x) 删除按钮的回调
                            deleteIcon: Icon(Icons.close),
                          ),
                        if (model.color.isNotEmpty)
                          Wrap(
                            spacing: 3.0,
                            children: model.color.map((c) {
                              return Chip(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 0,
                                ),
                                label: Image.asset(
                                  cardColorIconMap[c]!,
                                  width: 20,
                                  height: 20,
                                ),
                                onDeleted: () {
                                  model.removeSingleValueFilter('color', c);
                                }, // (x) 删除按钮的回调
                                deleteIcon: Icon(Icons.close),
                              );
                            }).toList(),
                          ),

                        if (model.rarity.isNotEmpty)
                          Wrap(
                            spacing: 3.0,
                            children: model.rarity.map((c) {
                              return Chip(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 0,
                                ),
                                label: Wrap(
                                  children: [
                                    Image.asset(
                                      cardRarityIconMap[c]!,
                                      width: 20,
                                      height: 20,
                                    ),
                                    Text(c),
                                  ],
                                ),
                                onDeleted: () {
                                  model.removeSingleValueFilter('rarity', c);
                                }, // (x) 删除按钮的回调
                                deleteIcon: Icon(Icons.close),
                              );
                            }).toList(),
                          ),

                        if (model.type.isNotEmpty)
                          Wrap(
                            spacing: 3.0,
                            children: model.type.map((c) {
                              return Chip(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 0,
                                ),
                                label: Text(c),
                                onDeleted: () {
                                  model.removeSingleValueFilter('type', c);
                                }, // (x) 删除按钮的回调
                                deleteIcon: Icon(Icons.close),
                              );
                            }).toList(),
                          ),

                        if (model.energy != energyConfig.defaultRange)
                          Chip(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 0,
                            ),
                            label: Text(
                              model.energy.start == model.energy.end
                                  ? '法力费用：${model.energy.start}'
                                  : '法力费用：${model.energy.start} - ${model.energy.end}',
                            ),
                            onDeleted: () {
                              model.setDefaultRangeValueFilter('energy');
                            }, // (x) 删除按钮的回调
                            deleteIcon: Icon(Icons.close),
                          ),

                        if (model.power != powerConfig.defaultRange)
                          Chip(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 0,
                            ),
                            label: Text(
                              model.power.start == model.power.end
                                  ? '法力费用：${model.power.start}'
                                  : '法力费用：${model.power.start} - ${model.power.end}',
                            ),
                            onDeleted: () {
                              model.setDefaultRangeValueFilter('power');
                            }, // (x) 删除按钮的回调
                            deleteIcon: Icon(Icons.close),
                          ),

                        if (model.might != mightConfig.defaultRange)
                          Chip(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 0,
                            ),
                            label: Text(
                              model.might.start == model.might.end
                                  ? '法力费用：${model.might.start}'
                                  : '法力费用：${model.might.start} - ${model.might.end}',
                            ),
                            onDeleted: () {
                              model.setDefaultRangeValueFilter('might');
                            }, // (x) 删除按钮的回调
                            deleteIcon: Icon(Icons.close),
                          ),

                        if (model.hasFilter)
                          Chip(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 0,
                            ),
                            label: Text('清除筛选'),
                            onDeleted: () {
                              model.clearAll();
                              model.resetPage();
                            }, // (x) 删除按钮的回调
                            deleteIcon: Icon(Icons.close),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 210,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: model.searchResult.length,
                itemBuilder: (context, index) {
                  final card = model.searchResult[index];
                  return CardTile(
                    card: card,
                    onTap: () => showCardDetailsDialog(context, card),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    List<String> rarities = [...cardRarityOptions];
    rarities.removeAt(0);

    List<String> categories = [...cardCategoryOptions];
    categories.removeAt(0);

    final model = context.read<SearchModel>();
    List<String> selectedRarities = [...model.rarity];
    List<String> selectedCardCategories = [...model.type];
    List<String> selectedColors = [...model.color];
    RangeValues selectedEnergy = model.energy;
    RangeValues selectedMight = model.might;
    RangeValues selectedPower = model.power;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog.adaptive(
              // title: Text("过滤", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Padding(
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //符文特性
                        const Text(
                          "符文特性",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: cardColorOptions.map((color) {
                            final iconPath = cardColorIconMap[color];
                            final isSelected = selectedColors.contains(color);

                            return GestureDetector(
                              onTap: () {
                                setStateDialog(() {
                                  if (isSelected) {
                                    selectedColors.remove(color);
                                  } else {
                                    selectedColors.add(color);
                                  }
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  // border: Border.all(),
                                  color: isSelected
                                      ? colorBackgrounds[color]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Image.asset(iconPath!),
                              ),
                            );
                          }).toList(),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(thickness: 1),
                        ),

                        // 稀有度
                        Text(
                          "稀有度",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: rarities.map((rarity) {
                            final iconPath = cardRarityIconMap[rarity];
                            final isSelected = selectedRarities.contains(
                              rarity,
                            );
                            return GestureDetector(
                              onTap: () {
                                setStateDialog(() {
                                  if (isSelected) {
                                    selectedRarities.remove(rarity);
                                  } else {
                                    selectedRarities.add(rarity);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Wrap(
                                  children: [
                                    Image.asset(
                                      iconPath!,
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      rarity,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(thickness: 1),
                        ),

                        // 卡牌类型
                        Text(
                          "卡牌类型",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: categories.map((cat) {
                            // final iconPath = cardRarityIconMap[rarity];
                            final isSelected = selectedCardCategories.contains(
                              cat,
                            );
                            return GestureDetector(
                              onTap: () {
                                setStateDialog(() {
                                  if (isSelected) {
                                    selectedCardCategories.remove(cat);
                                  } else {
                                    selectedCardCategories.add(cat);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(thickness: 1),
                        ),

                        RangeSliderWidget(
                          minMaxRange: energyConfig.minMax,
                          rangeValue: selectedEnergy,
                          onValueChanged: (value) {
                            setStateDialog(() {
                              selectedEnergy = value;
                            });
                          },
                          title: energyConfig.title,
                        ),

                        RangeSliderWidget(
                          minMaxRange: powerConfig.minMax,
                          rangeValue: selectedPower,
                          onValueChanged: (value) {
                            setStateDialog(() {
                              selectedPower = value;
                            });
                          },
                          title: powerConfig.title,
                        ),

                        RangeSliderWidget(
                          minMaxRange: mightConfig.minMax,
                          rangeValue: selectedMight,
                          onValueChanged: (value) {
                            setStateDialog(() {
                              selectedMight = value;
                            });
                          },
                          title: mightConfig.title,
                        ),
                      ],
                    ),
                  ),
                ),
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
                    Navigator.of(context).pop();
                    final model = Provider.of<SearchModel>(
                      context,
                      listen: false,
                    );
                    model.updateFilter(
                      color: selectedColors,
                      energy: selectedEnergy,
                      might: selectedMight,
                      type: selectedCardCategories,
                      power: selectedPower,
                      rarity: selectedRarities,
                    );
                  },
                  child: Text("确定"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Future<dynamic> showCardDetailsDialog(BuildContext context, DBCardModel card) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isWide = screenWidth > 600;

  return showDialog(
    context: context,
    builder: (context) => CardDetailsDialog(card: card, isWide: isWide),
  );
}
