import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart';

class CardTile extends StatelessWidget {
  final DBCardModel card;
  final VoidCallback onTap;

  const CardTile({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4.0,
            child: AspectRatio(
              aspectRatio: 0.72,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage, // 透明占位图
                  image: card.frontImage!,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (_, _, _) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
          Text(
            card.cardName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
