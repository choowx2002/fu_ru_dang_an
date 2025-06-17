import 'package:flutter/material.dart';

class RangeSliderModel {
  final RangeValues minMax;
  final RangeValues defaultRange;
  final String title;

  const RangeSliderModel({
    required this.minMax,
    required this.defaultRange,
    required this.title,
  });
}
