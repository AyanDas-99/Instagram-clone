// Convert any 0x???? or #F???? to Color
import 'package:flutter/material.dart' show Color;
import 'package:instagram_clone/extentions/string/remove_all.dart';

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() {
    return Color(int.parse(
      removeAll(['0x', '#']).padLeft(8, 'ff'),
      radix: 16,
    ));
  }
}
