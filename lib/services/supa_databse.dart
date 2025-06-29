import 'package:flutter/material.dart';
import 'package:fu_ru_dang_an/data/config/constant.dart';
// import 'package:fu_ru_dang_an/data/models/supabase_card_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaDatabse {
  static Future<PostgrestResponse<List<Map<String, dynamic>>>> searchCards({
    required String query,
    required int page,
    List<String>? color,
    List<String>? type,
    List<String>? rarity,
    RangeValues? power,
    RangeValues? energy,
    RangeValues? might,
    int pageSize = 25,
  }) async {
    // print(query);
    int offset = (page - 1) * pageSize;
    var builder = Supabase.instance.client.from('cards').select();

     if (query.isNotEmpty) {
      builder = builder.or(
        'card_name.ilike.%$query%,card_effect.ilike.%$query%',
      );
    }

    if (color != null && color.isNotEmpty) {
      builder = builder.overlaps('card_color_list', color);
    }
    if (type != null && type.isNotEmpty) {
      builder = builder.inFilter('card_category_name', type);
    }
    if (rarity != null && rarity.isNotEmpty) {
      builder = builder.inFilter('rarity_name', rarity);
    }

    if (power != null && power != powerConfig.defaultRange) {
      builder = builder
          .gte('return_energy', power.start.round())
          .lte('return_energy', power.end.round());
    }

    if (energy != null && energy != energyConfig.defaultRange) {
      builder = builder
          .gte('energy', energy.start.round())
          .lte('energy', energy.end.round());
    }

    if (might != null && might != mightConfig.defaultRange) {
      builder = builder
          .gte('power', might.start.round())
          .lte('power', might.end.round());
    }

    final result = await builder
        .range(offset, offset + pageSize - 1)
        .order('card_no', ascending: true)
        .count(CountOption.exact);
    
    // return (result.data as List).map((e) => DBCardModel.fromJson(e)).toList();
    return result;
  }
}
