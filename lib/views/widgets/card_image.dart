import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/card_model.dart';

Widget cardImage(CardModel card) {
  final image = Image.network(
    card.frontImage,
    fit: BoxFit.contain,
  );

  if (card.cardCategoryName == "战场") {
    // 逆时针旋转 90°
    return RotatedBox(
      quarterTurns: 3, // 1 = 90°, 2 = 180°, 3 = 270°
      child: image,
    );
  } else {
    return image;
  }
}
