import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/config/constant.dart'
    show
        cardRarityOptions,
        cardRarityIconMap,
        cardCategoryOptions,
        colorBackgrounds,
        cardColorOptions,
        cardColorIconMap;
import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart'
    show DBCardModel;
import 'package:fu_ru_dang_an/views/widgets/card_details_dialog.dart';
import 'package:fu_ru_dang_an/views/widgets/card_tile.dart';
import 'package:fu_ru_dang_an/views/widgets/cards_filter_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewCardsPage extends StatefulWidget {
  const ViewCardsPage({super.key});

  @override
  State<ViewCardsPage> createState() => _ViewCardsPageState();
}

class _ViewCardsPageState extends State<ViewCardsPage> {
  List<DBCardModel> cards = [];
  List<DBCardModel> filteredCards = [];
  int page = 1;
  int pageSize = 30;
  int count = 0;
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  bool isLoading = false;
  bool isBottom = false;

  String searchQuery = "";
  List<String> selectedRarities = [];
  List<String> selectedCardCategories = [];
  List<String> selectedColors = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 10) {
          loadNextPage();
        }
      });
    _searchController = TextEditingController();
    loadNextPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadNextPage() async {
    if (isLoading | isBottom) return;
    isLoading = true;
    int offset = (page - 1) * pageSize;
    final client = Supabase.instance.client;

    var query = client.from('cards').select("*");

    if (searchQuery.isNotEmpty) {
      query = query.or(
        'card_name.ilike.%$searchQuery%,card_effect.ilike.%$searchQuery%',
      );
    }

    if (selectedRarities.isNotEmpty) {
      final values = selectedRarities.join(',');
      query = query.filter('rarity_name', 'in', '($values)');
    }

    if (selectedCardCategories.isNotEmpty) {
      final values = selectedCardCategories.join(',');
      query = query.filter('card_category_name', 'in', '($values)');
    }

    if (selectedColors.isNotEmpty) {
      final values = '{${selectedColors.join(',')}}';
      query = query.filter('card_color_list', 'ov', values); // can change to cs
    }

    final response = await query
        .range(offset, offset + pageSize - 1)
        .order('card_no', ascending: true)
        .count(CountOption.exact);

    final List data = response.data as List;

    if (page == 1) {
      setState(() => count = response.count);
    }

    // print(response);
    final newCards = data.map((e) => DBCardModel.fromJson(e)).toList();
    if (newCards.isEmpty) {
      setState(() {
        isBottom = true;
      });
    } else {
      setState(() {
        page++;
        cards.addAll(newCards);
        isBottom = offset + newCards.length >= response.count;
      });
    }
    isLoading = false;
  }

  void _onSearchSubmitted() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      page = 1;
      cards.clear();
      isBottom = false;
    });
    loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1280.0),
        child: Column(
          children: [
            CardsFilterBar(
              searchController: _searchController,
              onSearchPressed: _onSearchSubmitted,
              onOpenFilterPressed: _showFilterDialog,
            ),
            Text(count.toString()),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
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
                            final isSelected = selectedRarities.contains(rarity);
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
                                    Image.asset(iconPath!, width: 20, height: 20),
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
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
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
                    setState(() {
                      page = 1;
                      cards.clear();
                      isBottom = false;
                    });
                    loadNextPage();
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
