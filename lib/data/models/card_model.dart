class CardModel {
  final int id;
  final String cardCategory;
  final String cardCategoryName;
  final String cardNo;
  final String cardName;
  final String subTitle;
  final String? extendType;
  final String extendTypeName;
  final List<String> cardColorList;
  final String region;
  final String tag;
  final String artist;
  final String cardEffect;
  final String flavorText;
  final int? energy;
  final int? returnEnergy;
  final int? power;
  final List<String> productCodeList;
  final List<String> productNameList;
  final dynamic cardQaList;
  final int craftLevel;
  final String rarity;
  final String rarityName;
  final String extendRarity;
  final String extendRarityName;
  final String frontImage;
  final String backImage;

  CardModel({
    required this.id,
    required this.cardCategory,
    required this.cardCategoryName,
    required this.cardNo,
    required this.cardName,
    required this.subTitle,
    required this.extendType,
    required this.extendTypeName,
    required this.cardColorList,
    required this.region,
    required this.tag,
    required this.artist,
    required this.cardEffect,
    required this.flavorText,
    required this.energy,
    required this.returnEnergy,
    required this.power,
    required this.productCodeList,
    required this.productNameList,
    required this.cardQaList,
    required this.craftLevel,
    required this.rarity,
    required this.rarityName,
    required this.extendRarity,
    required this.extendRarityName,
    required this.frontImage,
    required this.backImage,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      cardCategory: json['cardCategory'],
      cardCategoryName: json['cardCategoryName'],
      cardNo: json['cardNo'],
      cardName: json['cardName'],
      subTitle: json['subTitle'],
      extendType: json['extendType'],
      extendTypeName: json['extendTypeName'],
      cardColorList: List<String>.from(json['cardColorList'] ?? []),
      region: json['region'],
      tag: json['tag'],
      artist: json['artist'],
      cardEffect: json['cardEffect'],
      flavorText: json['flavorText'],
      energy: json['energy'],
      returnEnergy: json['returnEnergy'],
      power: json['power'],
      productCodeList: List<String>.from(json['productCodeList'] ?? []),
      productNameList: List<String>.from(json['productNameList'] ?? []),
      cardQaList: json['cardQaList'],
      craftLevel: json['craftLevel'],
      rarity: json['rarity'],
      rarityName: json['rarityName'],
      extendRarity: json['extendRarity'],
      extendRarityName: json['extendRarityName'],
      frontImage: json['frontImage'],
      backImage: json['backImage'],
    );
  }
}
