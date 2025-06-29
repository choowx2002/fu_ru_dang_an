import 'package:flutter/material.dart';

class RangeSliderWidget extends StatelessWidget {
  final RangeValues rangeValue;
  final RangeValues minMaxRange;
  final ValueChanged<RangeValues> onValueChanged;
  final String title;

  const RangeSliderWidget({
    super.key,
    required this.rangeValue,
    required this.onValueChanged,
    required this.minMaxRange,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final division = (minMaxRange.end - minMaxRange.start).round().clamp(
      1,
      100,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            if (rangeValue == minMaxRange)
              const Text("全部", style: TextStyle(fontWeight: FontWeight.bold))
            else
              Text(
                "${rangeValue.start.round()}-${rangeValue.end.round()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        RangeSlider(
          values: rangeValue,
          min: minMaxRange.start,
          max: minMaxRange.end,
          divisions: division,
          labels: RangeLabels(
            rangeValue.start.round().toString(),
            rangeValue.end.round().toString(),
          ),
          onChanged: onValueChanged,
        ),
      ],
    );
  }
}
