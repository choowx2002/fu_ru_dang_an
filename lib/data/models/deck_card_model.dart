import 'card_model.dart';

class DeckCard {
  final CardModel card;
  int count;

  DeckCard(this.card, {this.count = 1});

  // 可选：getter，方便调用
  String get name => card.cardName;
  String get type => card.cardCategoryName;
  int? get energy => card.energy;
  String get cardNo => card.cardNo;


  // JSON 序列化方法
  Map<String, dynamic> toJson() {
    return {
      'card': card.toJson(),
      'count': count,
    };
  }

  // JSON 反序列化方法
  factory DeckCard.fromJson(Map<String, dynamic> json) {
    return DeckCard(
      CardModel.fromJson(json['card']),
      count: json['count'] ?? 1,
    );
  }

}
