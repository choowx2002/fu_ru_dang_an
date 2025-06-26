class DBCardModel {
  final int id;
  final String cardNo;
  final String cardCategory;
  final String cardCategoryName;
  final String cardName;
  final String? subTitle;
  final List<String> cardColorList;
  final List<String> productCodeList;
  final List<String> productNameList;
  final dynamic cardQaList; // JSON 对象，格式不确定时可设为 dynamic
  final String? region;
  final String? tag;
  final String? artist;
  final String? cardEffect;
  final String? flavorText;
  final int? energy;
  final int? returnEnergy;
  final int? power;
  final int? craftLevel;
  final String? rarity;
  final String? rarityName;
  final String? extendType;
  final String? extendTypeName;
  final String? extendRarity;
  final String? extendRarityName;
  final String? frontImage;
  final String? backImage;
  final String? championTag;
  final List<String> keywords;
  final String? seriesName;

  DBCardModel({
    required this.id,
    required this.cardNo,
    required this.cardCategory,
    required this.cardCategoryName,
    required this.cardName,
    this.subTitle,
    required this.cardColorList,
    required this.productCodeList,
    required this.productNameList,
    this.cardQaList,
    this.region,
    this.tag,
    this.artist,
    this.cardEffect,
    this.flavorText,
    this.energy,
    this.returnEnergy,
    this.power,
    this.craftLevel,
    this.rarity,
    this.rarityName,
    this.extendType,
    this.extendTypeName,
    this.extendRarity,
    this.extendRarityName,
    this.frontImage,
    this.backImage,
    this.championTag,
    required this.keywords,
    this.seriesName,
  });

  factory DBCardModel.fromJson(Map<String, dynamic> json) {
    return DBCardModel(
      id: json['id'],
      cardNo: json['card_no'],
      cardCategory: json['card_category'],
      cardCategoryName: json['card_category_name'],
      cardName: json['card_name'],
      subTitle: json['sub_title'],
      cardColorList: List<String>.from(json['card_color_list'] ?? []),
      productCodeList: List<String>.from(json['product_code_list'] ?? []),
      productNameList: List<String>.from(json['product_name_list'] ?? []),
      cardQaList: json['card_qa_list'], // 可进一步解析成对象
      region: json['region'],
      tag: json['tag'],
      artist: json['artist'],
      cardEffect: json['card_effect'],
      flavorText: json['flavor_text'],
      energy: json['energy'],
      returnEnergy: json['return_energy'],
      power: json['power'],
      craftLevel: json['craft_level'],
      rarity: json['rarity'],
      rarityName: json['rarity_name'],
      extendType: json['extend_type'],
      extendTypeName: json['extend_type_name'],
      extendRarity: json['extend_rarity'],
      extendRarityName: json['extend_rarity_name'],
      frontImage: json['front_image'],
      backImage: json['back_image'],
      championTag: json['champion_tag'],
      keywords: List<String>.from(json['keywords'] ?? []),
      seriesName: json['series_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_no': cardNo,
      'card_category': cardCategory,
      'card_category_name': cardCategoryName,
      'card_name': cardName,
      'sub_title': subTitle,
      'card_color_list': cardColorList,
      'product_code_list': productCodeList,
      'product_name_list': productNameList,
      'card_qa_list': cardQaList,
      'region': region,
      'tag': tag,
      'artist': artist,
      'card_effect': cardEffect,
      'flavor_text': flavorText,
      'energy': energy,
      'return_energy': returnEnergy,
      'power': power,
      'craft_level': craftLevel,
      'rarity': rarity,
      'rarity_name': rarityName,
      'extend_type': extendType,
      'extend_type_name': extendTypeName,
      'extend_rarity': extendRarity,
      'extend_rarity_name': extendRarityName,
      'front_image': frontImage,
      'back_image': backImage,
      'champion_tag': championTag,
      'keywords': keywords,
      'series_name': seriesName,
    };
  }
}
