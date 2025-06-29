import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/config/constant.dart';
import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart';
import 'package:fu_ru_dang_an/services/supa_databse.dart';

class SearchModel extends ChangeNotifier {
  String query = '';
  List<String> color = [];
  List<String> type = [];
  List<String> rarity = [];
  RangeValues power = powerConfig.defaultRange;
  RangeValues energy = energyConfig.defaultRange;
  RangeValues might = mightConfig.defaultRange;

  List<DBCardModel> searchResult = [];

  int page = 1;
  bool isBottom = false;
  bool isLoading = false;
  int pageSize = 25;
  int count = 0;

  void removeSingleValueFilter(String key, String value) {
    switch (key) {
      case 'color':
        color.remove(value);
        break;
      case 'type':
        type.remove(value);
        break;
      case 'rarity':
        rarity.remove(value);
        break;
      default:
        throw ArgumentError('Unknown filter key: $key');
    }
    resetPage();
  }

  void setDefaultRangeValueFilter(String key) {
    switch (key) {
      case 'power':
        power = powerConfig.defaultRange;
        break;
      case 'energy':
        energy = energyConfig.defaultRange;
        break;
      case 'might':
        might = mightConfig.defaultRange;
        break;
      default:
        throw ArgumentError('Unknown filter key: $key');
    }
    resetPage();
  }

  void updateQuery(String newQuery) {
    query = newQuery;
    page = 1;
    searchResult.clear();
    isBottom = false;
    notifyListeners();
    resetPage();
  }

  void resetPage() {
    page = 1;
    isBottom = false;
    searchResult.clear();
    notifyListeners();
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (isBottom || isLoading) return;
    isLoading = true;
    final result = await SupaDatabse.searchCards(
      query: query,
      page: page,
      color: color,
      type: type,
      rarity: rarity,
      power: power,
      energy: energy,
      might: might,
      pageSize: pageSize,
    );
    count = result.count;
    notifyListeners();
    searchResult.addAll(
      (result.data as List).map((e) => DBCardModel.fromJson(e)).toList(),
    );

    if (result.data.length < pageSize) {
      isBottom = true;
    } else {
      page++;
    }

    isLoading = false;
    notifyListeners();
  }

  void updateResult(List<DBCardModel> result) {
    searchResult.addAll(result);
    notifyListeners();
  }

  void clearResult() {
    searchResult.clear();
    notifyListeners();
  }

  void updateFilter({
    List<String>? color,
    List<String>? type,
    List<String>? rarity,
    RangeValues? power,
    RangeValues? energy,
    RangeValues? might,
  }) {
    if (color != null) this.color = color;
    if (type != null) this.type = type;
    if (rarity != null) this.rarity = rarity;
    if (power != null) this.power = power;
    if (energy != null) this.energy = energy;
    if (might != null) this.might = might;
    notifyListeners();
    resetPage();
  }

  void clearAll() {
    query = '';
    color = [];
    type = [];
    rarity = [];
    power = powerConfig.defaultRange;
    energy = energyConfig.defaultRange;
    might = mightConfig.defaultRange;
    notifyListeners();
  }

  bool get hasFilter {
    return query.trim().isNotEmpty ||
        color.isNotEmpty ||
        type.isNotEmpty ||
        rarity.isNotEmpty ||
        power != powerConfig.defaultRange ||
        energy != energyConfig.defaultRange ||
        might != mightConfig.defaultRange;
  }
}
