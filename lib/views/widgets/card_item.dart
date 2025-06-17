import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/card_model.dart';

class CardItem extends StatelessWidget {
  final CardModel card;
  const CardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          child: Column(
            children: [
              Image.network(
                card.frontImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error_outline_sharp),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 5),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          card.cardName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
