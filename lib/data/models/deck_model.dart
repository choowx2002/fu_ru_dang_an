class DeckModel {
  final String name;
  final String author;
  final String? description;

  String legend;
  final Map<String, int> mainDeck;
  final Map<String, int> runeDeck;
  final Map<String, int> battlefields;

  DeckModel({
    required this.name,
    required this.author,
    this.description,
    required this.legend,
    required this.mainDeck,
    required this.runeDeck,
    required this.battlefields,
  });

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

  static int typeLimitFor(String type) {
    return _typeLimits[type] ?? 3;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'author': author,
    'description': description,
    'legend': legend,
    'mainDeck': mainDeck,
    'runeDeck': runeDeck,
    'battlefields': battlefields,
  };

  factory DeckModel.fromJson(Map<String, dynamic> json) => DeckModel(
    name: json['name'],
    author: json['author'],
    description: json['description'],
    legend: json['legend'],
    mainDeck: Map<String, int>.from(json['mainDeck']),
    runeDeck: Map<String, int>.from(json['runeDeck']),
    battlefields: Map<String, int>.from(json['battlefields']),
  );

  int get mainDeckCount => mainDeck.values.fold(0, (a, b) => a + b);

  int get runeCards => runeDeck.values.fold(0, (a, b) => a + b);

  bool get isbattlefieldsReachLimit => battlefields.length == 3;
}
