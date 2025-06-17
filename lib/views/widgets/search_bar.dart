import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "搜索卡牌名称",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      onChanged: onChanged,
    );
  }
}
