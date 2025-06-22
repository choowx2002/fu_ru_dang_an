import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RichTextWithIcons extends StatelessWidget {
  final String text;
  final double fontSize;

  const RichTextWithIcons({
    super.key,
    required this.text,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        showOverlayMessage(context, '复制成功！');
      },
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(
            context,
          ).style.copyWith(fontSize: fontSize),
          children: _parseTextWithIcons(text),
        ),
      ),
    );
  }

  List<InlineSpan> _parseTextWithIcons(String source) {
    final regex = RegExp(r'{{(.*?)}}');
    final matches = regex.allMatches(source);

    List<InlineSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      // 添加匹配前的文字
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: source.substring(currentIndex, match.start)));
      }

      final key = match.group(1); // 提取 key，如 "S"
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Image.asset('assets/text_icons/$key.png', height: fontSize),
        ),
      );

      currentIndex = match.end;
    }

    // 添加剩余的文本
    if (currentIndex < source.length) {
      spans.add(TextSpan(text: source.substring(currentIndex)));
    }

    return spans;
  }
}

void showOverlayMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (_) => Positioned(
      bottom: 10,
      left: 10,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryFixed,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(Duration(seconds: 2), () => entry.remove());
}
