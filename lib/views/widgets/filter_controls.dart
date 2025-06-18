import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/config/constant.dart';
import 'package:fu_ru_dang_an/views/widgets/range_slider.dart';

class FilterControlsWidget extends StatelessWidget {
  // rarity
  final String? selectedRarity;
  final List<String> rarities = cardRarityOptions;
  final ValueChanged<String?> onRarityChanged;

  // category
  final String? selectedCategory;
  final List<String> categories = cardCategoryOptions;
  final ValueChanged<String?> onCategoryChanged;

  // color
  final Set<String> selectedColors;
  final List<String> colorOptions = cardColorOptions;
  final ValueChanged<Set<String>> onColorChanged;

  // rangeSlider
  final RangeValues energyRangeValues;
  final RangeValues powerRangeValues;
  final RangeValues mightRangeValues;

  final ValueChanged<RangeValues> onEnergyRangeChanged;
  final ValueChanged<RangeValues> onPowerRangeChanged;
  final ValueChanged<RangeValues> onMightRangeChanged;

  const FilterControlsWidget({
    super.key,
    this.selectedRarity,
    required this.onRarityChanged,
    required this.selectedColors,
    required this.onColorChanged,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.energyRangeValues,
    required this.powerRangeValues,
    required this.mightRangeValues,
    required this.onEnergyRangeChanged,
    required this.onPowerRangeChanged,
    required this.onMightRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        children: [
          // 符文
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("符文", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: cardColorOptions.map((color) {
                  final iconPath = cardColorIconMap[color];
                  final isSelected = selectedColors.contains(color);

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        selectedColors.remove(color);
                      } else {
                        selectedColors.add(color);
                      }
                      onColorChanged(selectedColors);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: isSelected
                            ? colorBackgrounds[color]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(iconPath!),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 类型
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("类型", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                isDense: true,
                focusColor: Colors.transparent,
                value: selectedCategory,
                hint: const Text("选择卡牌分类"),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: onCategoryChanged,
              ),
            ],
          ),

          // 稀有度
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("稀有度", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                isDense: true,
                focusColor: Colors.transparent,
                value: selectedRarity,
                hint: const Text("选择稀有度"),
                items: rarities.map((rarity) {
                  final iconPath = cardRarityIconMap[rarity];
                  return DropdownMenuItem<String>(
                    value: rarity,
                    child: iconPath != null
                        ? Row(
                            children: [
                              Image.asset(iconPath, width: 20, height: 20),
                              const SizedBox(width: 8),
                              Text(rarity),
                            ],
                          )
                        : Text(rarity),
                  );
                }).toList(),
                onChanged: onRarityChanged,
              ),
            ],
          ),

          // energy range slider
          RangeSliderWidget(
            minMaxRange: energyConfig.minMax,
            rangeValue: energyRangeValues,
            onValueChanged: onEnergyRangeChanged,
            title: energyConfig.title,
          ),

          // power range slider
          RangeSliderWidget(
            minMaxRange: powerConfig.minMax,
            rangeValue: powerRangeValues,
            onValueChanged: onPowerRangeChanged,
            title: powerConfig.title,
          ),

          // might range slider
          RangeSliderWidget(
            minMaxRange: mightConfig.minMax,
            rangeValue: mightRangeValues,
            onValueChanged: onMightRangeChanged,
            title: mightConfig.title,
          ),
        ],
      ),
    );
  }
}
