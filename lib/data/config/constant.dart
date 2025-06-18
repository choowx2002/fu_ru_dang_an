import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/models/range_slider_model.dart';

/// 卡牌分类（稀有度）
const List<String> cardRarityOptions = ['全部', '普通', '不凡', '稀有', '史诗', '异画'];

/// 稀有度对应图标路径
const Map<String, String> cardRarityIconMap = {
  '普通': "assets/icons/common.png",
  '不凡': "assets/icons/uncommon.png",
  '稀有': "assets/icons/rare.png",
  '史诗': "assets/icons/epic.png",
  '异画': "assets/icons/overnumbered.png",
};

// 颜色分类
const List<String> cardColorOptions = [
  'red',
  'green',
  'blue',
  'orange',
  'purple',
  'yellow',
];

/// 颜色图标路径
const Map<String, String> cardColorIconMap = {
  'red': "assets/icons/Fury.png",
  'green': "assets/icons/Calm.png",
  'blue': "assets/icons/Mind.png",
  'orange': "assets/icons/Body.png",
  'purple': "assets/icons/Chaos.png",
  'yellow': "assets/icons/Order.png",
};

/// 背景颜色映射
final Map<String, Color> colorBackgrounds = {
  'red': Colors.red.shade200,
  'green': Colors.green.shade200,
  'blue': Colors.blue.shade200,
  'orange': Colors.orange.shade200,
  'purple': Colors.purple.shade200,
  'yellow': Colors.yellow.shade200,
};

/// 卡牌分类（类型）
const List<String> cardCategoryOptions = [
  '全部',
  '传奇',
  '专属法术',
  '英雄单位',
  '法术',
  '装备',
  '指示物单位',
  '符文',
  '单位',
  '战场',
];

const energyConfig = RangeSliderModel(
  minMax: RangeValues(0, 12),
  defaultRange: RangeValues(0, 12),
  title: "法力费用",
);

const powerConfig = RangeSliderModel(
  minMax: RangeValues(0, 4),
  defaultRange: RangeValues(0, 4),
  title: "符能费用",
);

const mightConfig = RangeSliderModel(
  minMax: RangeValues(0, 12),
  defaultRange: RangeValues(0, 12),
  title: "战力",
);

class SortOption {
  final String label;
  final String value;

  const SortOption({required this.label, required this.value});
}

final List<SortOption> sortByOptions = [
  SortOption(label: "ID", value: "id"),
  SortOption(label: "法力", value: "energy"),
  SortOption(label: "符能", value: "power"),
  SortOption(label: "战力", value: "might"),
];