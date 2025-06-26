import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart';
import 'package:fu_ru_dang_an/views/widgets/card_image.dart';
import 'package:fu_ru_dang_an/views/widgets/rich_text_icons.dart';

class CardDetailsDialog extends StatelessWidget {
  final DBCardModel card;
  final bool isWide;

  const CardDetailsDialog({
    super.key,
    required this.card,
    required this.isWide,
  });

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
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cardImage(card),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCardDetails()),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cardImage(card),
                  const SizedBox(height: 12),
                  _buildCardDetails(),
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

  Widget _buildCardDetails() {
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 400, // 最大高度，超出就滚动
          minHeight: 100, // 最小高度可选
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (card.energy != null) Text("法力费用: ${card.energy}"),
              if (card.returnEnergy != null) Text("符能费用: ${card.returnEnergy}"),
              if (card.power != null) Text("战力: ${card.power}"),
              Text("稀有度: ${card.rarityName}（${card.extendRarityName}）"),
              Text("类别: ${card.cardCategoryName}"),
              const SizedBox(height: 8),
              RichTextWithIcons(text: card.cardEffect ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
