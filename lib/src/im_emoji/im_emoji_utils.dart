import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_im_kit/src/im_emoji/emoji_text_span_builder.dart';

class ImEmojiUtils {

  static void insertText(TextEditingController controller, String text) {
    final TextEditingValue value = controller.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    print('EmojiUtils#insertText: $controller');
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      controller.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      controller.value = TextEditingValue(
          text: text,
          selection:
          TextSelection.fromPosition(TextPosition(offset: text.length)));
    }
  }

  static void manualDelete(TextEditingController controller, EmojiTextSpanBuilder textSpanBuilder) {
    //delete by code
    print('EmojiUtils#manualDelete: $controller');
    final _value = controller.value;
    final selection = _value.selection;
    if (!selection.isValid) return;

    TextEditingValue value;
    final actualText = _value.text;
    if (selection.isCollapsed && selection.start == 0) return;
    final int start =
    selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;

    value = TextEditingValue(
      text: actualText.replaceRange(start, end, ""),
      selection: TextSelection.collapsed(offset: start),
    );

    final oldTextSpan = textSpanBuilder.build(_value.text);

    value = handleSpecialTextSpanDelete(value, _value, oldTextSpan, null);

    controller.value = value;
  }
}
