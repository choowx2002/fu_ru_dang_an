import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/deck_model.dart';

class DeckStorageService {
  static const String _prefix = 'deck_';
  static const String _deckListKey = 'deck_names';

  /// 保存卡组（会自动添加到列表中）
  static Future<void> saveDeck(DeckModel deck) async {
    final prefs = await SharedPreferences.getInstance();
    final name = deck.name;
    final jsonString = jsonEncode(deck.toJson());

    await prefs.setString('$_prefix$name', jsonString);

    List<String> names = prefs.getStringList(_deckListKey) ?? [];
    if (!names.contains(name)) {
      names.add(name);
      await prefs.setStringList(_deckListKey, names);
    }
  }

  /// 加载指定名称的卡组
  static Future<DeckModel?> loadDeck(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_prefix$name');
    if (jsonString == null) return null;
    return DeckModel.fromJson(jsonDecode(jsonString));
  }

  /// 获取所有已保存的卡组名
  static Future<List<String>> getDeckNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_deckListKey) ?? [];
  }

  /// 删除指定名称的卡组
  static Future<void> deleteDeck(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$name');

    List<String> names = prefs.getStringList(_deckListKey) ?? [];
    names.remove(name);
    await prefs.setStringList(_deckListKey, names);
  }

  /// 重命名卡组（保存为新名并删除旧名）
  static Future<bool> renameDeck(String oldName, String newName) async {
    final existing = await loadDeck(oldName);
    if (existing == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final newJsonKey = '$_prefix$newName';

    // 检查新名字是否已存在
    if (prefs.containsKey(newJsonKey)) return false;

    final updated = DeckModel(
      name: newName,
      author: existing.author,
      description: existing.description,
      legend: existing.legend,
      mainDeck: existing.mainDeck,
      runeDeck: existing.runeDeck,
      battlefields: existing.battlefields,
    );

    await saveDeck(updated);
    await deleteDeck(oldName);
    return true;
  }

  /// 导出卡组为 JSON 字符串
  static Future<String?> exportDeck(String name) async {
    final deck = await loadDeck(name);
    return deck == null ? null : jsonEncode(deck.toJson());
  }

  /// 导入 JSON 字符串为卡组（需自行传入目标名字）
  static Future<bool> importDeck(String name, String jsonStr) async {
    try {
      final map = jsonDecode(jsonStr);
      final deck = DeckModel.fromJson(map);
      final renamedDeck = DeckModel(
        name: name,
        author: deck.author,
        description: deck.description,
        legend: deck.legend,
        mainDeck: deck.mainDeck,
        runeDeck: deck.runeDeck,
        battlefields: deck.battlefields,
      );
      await saveDeck(renamedDeck);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 清除所有卡组（危险操作）
  static Future<void> clearAllDecks() async {
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getStringList(_deckListKey) ?? [];
    for (final name in names) {
      await prefs.remove('$_prefix$name');
    }
    await prefs.remove(_deckListKey);
  }
}
