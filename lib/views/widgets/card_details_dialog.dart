import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart';
import 'package:fu_ru_dang_an/views/widgets/rich_text_icons.dart';

class CardDetailsDialog extends StatelessWidget {
  final DBCardModel card;
  const CardDetailsDialog({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(card.cardName),
          Text(card.cardNo, style: const TextStyle(fontSize: 14)),
        ],
      ),
      content: SizedBox(
        width: 750,
        child: Row(
          children: [
            cardImage(card),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (card.energy != null)
                        Text("法力费用: ${card.energy}"),
                      if (card.returnEnergy != null)
                        Text("符能费用: ${card.returnEnergy}"),
                      if (card.power != null)
                        Text("战力: ${card.power}"),
                      Text("稀有度: ${card.rarityName}（${card.extendRarityName}）"),
                      Text("类别: ${card.cardCategoryName}"),
                      const SizedBox(height: 8),
                      RichTextWithIcons(text: card.cardEffect ?? ""),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("关闭"),
        ),
      ],
    );
  }
}

Widget cardImage(DBCardModel card) {
  final image = Image.network(card.frontImage!, fit: BoxFit.contain);

  if (card.cardCategoryName == "战场") {
    return RotatedBox(quarterTurns: 3, child: image);
  } else {
    return image;
  }
}
