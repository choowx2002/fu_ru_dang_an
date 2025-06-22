import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/card_model.dart';

class CardDatabase {
  static final CardDatabase _instance = CardDatabase._internal();

  factory CardDatabase() => _instance;

  CardDatabase._internal();

  final Map<String, CardModel> _cardMap = {};

  Future<void> loadCards() async {
    if (_cardMap.isNotEmpty) return; // 避免重复加载

    final String jsonStr = await rootBundle.loadString('assets/data/cards.json');
    final List<dynamic> data = jsonDecode(jsonStr);

    for (final item in data) {
      final card = CardModel.fromJson(item);
      _cardMap[card.cardNo] = card;
    }
  }

  CardModel? getCardByNo(String cardNo) => _cardMap[cardNo];

  List<CardModel> get allCards => _cardMap.values.toList();
}
