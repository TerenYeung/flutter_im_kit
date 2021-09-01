import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/flutter_excellent_bubble.dart';
import 'package:flutter_im_kit/src/im_emoji/emoji_text_span_builder.dart';
import 'package:flutter_im_kit/src/im_emoji/im_emoji_cache.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';

class ImTextMessage extends StatefulWidget {
  const ImTextMessage({
    Key? key,
    required this.content,
    required this.isMe,
    this.limit = 100,
    this.selfTextStyle = const TextStyle(
      fontSize: 16.0,
      color: Style.MSG_TEXT_SELF,
    ),
    this.otherTextStyle = const TextStyle(
      fontSize: 16.0,
      color: Style.MSG_TEXT_OTHER,
    ),
    this.arrowSize = 8.0,
    this.selfBackgroundColor = Style.MSG_BG_SELF,
    this.otherBackgroundColor = Style.MSG_BG_OTHER,
    this.bubbleType = BubbleType.Normal,
    this.expandBuilder,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.topLeft = 8.0,
    this.topRight = 8.0,
    this.bottomLeft = 8.0,
    this.bottomRight = 8.0
  }) : super(key: key);
  final int? limit;
  final String content;
  final bool isMe;
  final double? arrowSize;
  final Color? selfBackgroundColor;
  final Color? otherBackgroundColor;
  final TextStyle? selfTextStyle;
  final TextStyle? otherTextStyle;
  final BubbleType? bubbleType;
  final Function(BuildContext context, bool isExpanded)? expandBuilder;
  final EdgeInsets? padding;
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;

  @override
  _ImTextMessageState createState() => _ImTextMessageState();
}

class _ImTextMessageState extends State<ImTextMessage> {
  bool _isExpanded = false;
  EmojiTextSpanBuilder? emojiTextSpanBuilder;

  bool get isExceed {
    final int charNum = widget.content.characters.length;
    return charNum > widget.limit!;
  }

  String get computedContent {
    if (isExceed) {
      final int charNum = widget.content.characters.length;
      return widget.content.characters.skipLast(charNum - widget.limit!).toString() + '...';
    }

    return widget.content;
  }

  Widget get _textContent {
    final maxWidth = MediaQuery.of(context).size.width * .62;

    return DefaultTextStyle(
      style: widget.isMe ? widget.selfTextStyle! : widget.otherTextStyle!,
      // child: Text(widget.content),
      child: Container(
        // alignment: Alignment.center,
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Stack(
          // alignment: Alignment.center,
          children: [
            ExtendedText(
              _isExpanded ? widget.content : computedContent,
              specialTextSpanBuilder: emojiTextSpanBuilder ?? null,
              // style: widget.textStyle ?? TextStyle(),
            ),
            Visibility(
              visible: isExceed,
              child: Positioned(
                bottom: -8.0,
                right: -8.0,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 12.0),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(8, 8, 4, 0),
                      )
                  ),
                  child: widget.expandBuilder != null
                      ? widget.expandBuilder!(context, _isExpanded)
                      : Text(
                    _isExpanded ? '折叠' : '展开',
                    style: (widget.isMe ? widget.selfTextStyle! : widget.otherTextStyle!).merge(TextStyle(
                      fontSize: 12.0,
                    )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    ImEmojiCache.instance.getSystemEmojisAsync((emojis, isAsync) {
      emojiTextSpanBuilder = EmojiTextSpanBuilder(emojis);
      if (isAsync) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = MediaQuery.of(context).size.width * .62;
        final span = TextSpan(text: widget.content);
        final tp = TextPainter(text: span, maxLines: 1, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: maxWidth);

        BubblePosition position = BubblePosition.rightTop;
        if (tp.didExceedMaxLines) {
          position = widget.isMe ? BubblePosition.rightTop : BubblePosition.leftTop;
        } else {
          position = widget.isMe ? BubblePosition.rightCenter : BubblePosition.leftCenter;
        }

        return ExcellentBubble(
          arrowSize: widget.arrowSize,
          position: position,
          bubbleType: widget.bubbleType,
          backgroundColor: widget.isMe ? widget.selfBackgroundColor : widget.otherBackgroundColor,
          topLeft: widget.topLeft!,
          topRight: widget.topRight!,
          bottomLeft: widget.bottomLeft!,
          bottomRight: widget.bottomRight!,
          child: Padding(
            padding: widget.padding!,
            child: _textContent,
          ),
        );
      },
    );
  }
}
