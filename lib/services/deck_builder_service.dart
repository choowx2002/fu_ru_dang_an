import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/card_model.dart';
import '../data/models/deck_card_model.dart';

class DeckBuilderService extends ChangeNotifier {
  static const _storageKey = 'saved_deck';

  List<DeckCard> _deck = [];
  List<DeckCard> get deck => _deck;

  /// 各卡片类型的最大允许数量
  static const Map<String, int> _typeLimits = {
    '传奇': 1,
    '专属法术': 3,
    '英雄单位': 3,
    '法术': 3,
    '装备': 3,
    '符文': 12,
    '单位': 3,
    '战场': 1,
  };

  DeckBuilderService() {
    loadDeck();
  }

  /// 获取总卡片数量（包含重复）
  int get totalCardCount => _deck.fold(0, (sum, c) => sum + c.count);

  /// 添加卡片到卡组（根据类型数量限制）
  bool addCard(CardModel card) {
    final type = card.cardCategoryName;
    final maxCount = _typeLimits[type] ?? 3;

    DeckCard? existing = _deck.cast<DeckCard?>().firstWhere(
      (c) => c?.cardNo == card.cardNo,
      orElse: () => null,
    );

    if (existing == null) {
      _deck.add(DeckCard(card, count: 1));
      _persistAndNotify();
      return true;
    } else if (existing.count < maxCount) {
      existing.count += 1;
      _persistAndNotify();
      return true;
    }

    return false; // 超过限制
  }

  /// 移除卡片（减少计数或删除）
  void removeCard(CardModel card) {
    DeckCard? existing = _deck.cast<DeckCard?>().firstWhere(
      (c) => c?.cardNo == card.cardNo,
      orElse: () => null,
    );

    if (existing != null) {
      if (existing.count <= 1) {
        _deck.remove(existing);
      } else {
        existing.count -= 1;
      }
      _persistAndNotify();
    }
  }

  /// 清空卡组
  void clearDeck() {
    _deck.clear();
    _persistAndNotify();
  }

  /// 保存卡组到本地存储
  Future<void> saveDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final deckJson = jsonEncode(_deck.map((card) => card.toJson()).toList());
    await prefs.setString(_storageKey, deckJson);
  }

  /// 加载卡组
  Future<void> loadDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final deckJson = prefs.getString(_storageKey);
    if (deckJson != null) {
      final List<dynamic> decoded = jsonDecode(deckJson);
      _deck = decoded.map((item) => DeckCard.fromJson(item)).toList();
      notifyListeners();
    }
  }

  /// 封装：保存并通知刷新
  void _persistAndNotify() {
    saveDeck();
    notifyListeners();
  }
}
