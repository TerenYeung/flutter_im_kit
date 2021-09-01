
import 'package:extended_text/extended_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/im_emoji/emoji_text.dart';

class ImSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  TextSpan build(String data, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }

    return super.build(data, textStyle: textStyle, onTap: onTap);
  }

  @override
  SpecialText? createSpecialText(String? flag, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, required int index}) {
    if (flag == null || flag == "") return null;

    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle!, start: index - (EmojiText.flag.length - 1));
    }

    return null;
  }
}