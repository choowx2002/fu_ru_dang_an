import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart';

Widget cardImage(DBCardModel card) {
  final imageWidget = ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: card.frontImage!,
      fit: BoxFit.cover,
      imageErrorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
    ),
  );

  final imageCard = ConstrainedBox(
    constraints: const BoxConstraints(
      maxWidth: 180, // 自定义
    ),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4.0,
      child: imageWidget,
    ),
  );

  return card.cardCategoryName == "战场"
      ? RotatedBox(quarterTurns: 3, child: imageCard)
      : imageCard;
}
