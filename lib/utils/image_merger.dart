import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// 卡图合并工具（适用于 Flutter Web）
class ImageMergerWebService {
  /// 下载 URL 列表并合并为单张卡表图像（返回 PNG 的 bytes）
  static Future<Uint8List> merge({
    required List<String> imageUrls,
    int cardWidth = 375,
    int cardHeight = 525,
    int columns = 10,
    int maxCards = 69,
  }) async {
    final images = <ui.Image>[];

    for (final url in imageUrls.take(maxCards)) {
      final image = await _loadImageFromUrl(url);
      images.add(image);
    }

    final rows = (images.length / columns).ceil();
    final sheetWidth = columns * cardWidth;
    final sheetHeight = rows * cardHeight;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, sheetWidth.toDouble(), sheetHeight.toDouble()),
    );
    final paint = Paint();

    for (int i = 0; i < images.length; i++) {
      final x = (i % columns) * cardWidth;
      final y = (i ~/ columns) * cardHeight;
      final image = images[i];
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(x.toDouble(), y.toDouble(), cardWidth.toDouble(), cardHeight.toDouble()),
        paint,
      );
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(sheetWidth, sheetHeight);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// 导出 PNG bytes 为可下载文件
  static void download(Uint8List bytes, String fileName) {
    final jsArray = bytes.toJSArrayBuffer();
    final blob = web.Blob(
      jsArray,
      web.BlobPropertyBag(type: 'image/png'),
    );

    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = fileName;
    anchor.click();
    web.URL.revokeObjectURL(url);
  }

  /// 内部函数：从 URL 加载图像
  static Future<ui.Image> _loadImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final codec = await ui.instantiateImageCodec(response.bodyBytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

extension on Uint8List {
  JSArray<JSUint8Array> toJSArrayBuffer() {
    final array = toJS;
    return [array].toJS;
  }
}
