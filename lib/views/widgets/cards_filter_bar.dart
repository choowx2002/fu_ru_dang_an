import 'package:flutter/material.dart';

class CardsFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearchPressed;
  final VoidCallback onOpenFilterPressed;

  const CardsFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchPressed,
    required this.onOpenFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // 搜索框
          Expanded(
            child: TextField(
              controller: searchController,
              onSubmitted: (_) => onSearchPressed(),
              decoration: InputDecoration(
                hintText: '搜索卡牌名称',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onSearchPressed,
            child: const Text("搜索"),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: onOpenFilterPressed,
          ),
        ],
      ),
    );
  }
}
