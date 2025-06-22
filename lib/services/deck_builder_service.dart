import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/deck_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/card_model.dart';

class DeckBuilderService extends ChangeNotifier {
  static const _storageKey = 'saved_deck';

  late DeckModel _deck;
  DeckModel get deck => _deck;

  DeckBuilderService() {
    _deck = DeckModel(
      name: '未命名卡组',
      author: '匿名',
      legend: '',
      mainDeck: {},
      runeDeck: {},
      battlefields: {},
    );
    loadDeck();
  }

  /// 添加卡片到卡组（根据类型数量限制）
  bool addCard(CardModel card) {
    final type = card.cardCategoryName;
    final maxCount = DeckModel.typeLimitFor(type);

    if (type == '传奇') {
      _deck.legend = card.cardNo;
    } else {
      Map<String, int>? targetMap;

      switch (type) {
        case '符文':
          targetMap = _deck.runeDeck;
          break;
        case '战场':
          targetMap = _deck.battlefields;
          if (targetMap.length >= 3) return false; // 限3个战场
          break;
        default:
          targetMap = _deck.mainDeck;
          break;
      }

      final count = targetMap[card.cardNo] ?? 0;
      if (count >= maxCount) return false;

      targetMap[card.cardNo] = count + 1;
    }

    _persistAndNotify();
    return true;
  }

  void removeCard(CardModel card) {
    final type = card.cardCategoryName;

    Object? targetMap;
    switch (type) {
      case '传奇':
        targetMap = _deck.legend;
        break;
      case '符文':
        targetMap = _deck.runeDeck;
        break;
      case '战场':
        targetMap = _deck.battlefields;
        break;
      default:
        targetMap = _deck.mainDeck;
        break;
    }

    if (targetMap is Map<String, int>) {
      if (targetMap.containsKey(card.cardNo)) {
        if (targetMap[card.cardNo]! <= 1) {
          targetMap.remove(card.cardNo);
        } else {
          targetMap[card.cardNo] = targetMap[card.cardNo]! - 1;
        }
        _persistAndNotify();
      }
    } else if (targetMap is String) {
      // 处理 String 情况
    }
  }

  /// 清空卡组
  void clearDeck() {
    _deck.legend = '';
    _deck.mainDeck.clear();
    _deck.runeDeck.clear();
    _deck.battlefields.clear();
    _persistAndNotify();
  }

  Future<void> saveDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_deck.toJson());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> loadDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      _deck = DeckModel.fromJson(jsonDecode(jsonString));
      notifyListeners();
    }
  }

  /// 封装：保存并通知刷新
  void _persistAndNotify() {
    saveDeck();
    notifyListeners();
  }

  int get totalCards {
    final legendCount = _deck.legend.isEmpty ? 0 : 1;
    final mainCount = _deck.mainDeck.values.fold<int>(0, (a, b) => a + b);
    final runeCount = _deck.runeDeck.values.fold<int>(0, (a, b) => a + b);
    final bfCount = _deck.battlefields.values.fold<int>(0, (a, b) => a + b);
    return legendCount + mainCount + runeCount + bfCount;
  }
}
