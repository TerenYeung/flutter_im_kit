import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/common_widgets.dart';
import 'package:flutter_im_kit/src/flutter_excellent_badge.dart';
import 'package:characters/characters.dart';
import 'package:flutter_im_kit/src/utils.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef TimeFormatConvertor = String Function(int timestamp);

const double kHorizontalPadding = 16.0;
const double kVerticalPadding = 12.0;

class ImConversation extends StatefulWidget {
  const ImConversation({
    Key? key,
    // this.height = 68.0,
    this.avatarUrl,
    this.avatarSize = 44.0,
    this.avatarShape = BoxShape.circle,
    required this.title,
    this.titleStyle = const TextStyle(
        color: Style.TEXT_TITLE, fontWeight: FontWeight.bold, fontSize: 16.0),
    this.titleBuilder,
    required this.subTitle,
    this.subTitleStyle = const TextStyle(
      color: Style.TEXT_SUBTITLE,
      fontSize: 12.0,
    ),
    this.subTitleBuilder,
    required this.msgType,
    this.unreadCount,
    this.badgeStyle,
    this.timeFormatStyle = const TextStyle(
      color: Style.TEXT_SUBTITLE,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
    ),
    this.timestamp,
    this.timeFormatConvertor,
    this.showDivider = true,
    this.builder,
    this.onTap,
    this.onItemDelete,
    this.endActionsBuilder,
  })  : assert(avatarUrl == null || (avatarUrl != ""),
            "avatarUrl cannot be empty string."),
        super(key: key);
  // final double? height;

  /// 用户头像
  final String? avatarUrl;
  final double? avatarSize;
  final BoxShape? avatarShape;

  /// 一级标题
  final String title;
  final TextStyle titleStyle;
  final Widget Function(int msgType)? titleBuilder;

  /// 二级标题
  final String subTitle;
  final TextStyle subTitleStyle;

  /// 二级标题 builder
  final Widget Function(int msgType)? subTitleBuilder;

  /// 消息类型
  final int msgType;

  /// 未读消息数量
  final int? unreadCount;

  /// 红点样式
  final BadgeStyle? badgeStyle;

  /// 消息时间戳
  final int? timestamp;
  final TextStyle timeFormatStyle;
  final TimeFormatConvertor? timeFormatConvertor;
  final bool showDivider;
  final Widget Function(BuildContext context)? builder;
  final List<Widget> Function(BuildContext context)? endActionsBuilder;

  final Function()? onTap;
  final Function(BuildContext context)? onItemDelete;

  /// 表情文本 builder
  // final EmojiTextSpanBuilder emojiTextSpanBuilder;
  @override
  _ImConversationState createState() => _ImConversationState();
}

class _ImConversationState extends State<ImConversation> {
  Widget get avatarWidget {
    BadgeStyle badgeStyle = BadgeStyle().merge(
      widget.badgeStyle,
    );

    return ExcellentBadge(
      size: badgeStyle.size!,
      textStyle: badgeStyle.textStyle,
      position: badgeStyle.position,
      showBadge: widget.unreadCount != 0,
      count: widget.unreadCount ?? 0,
      child: ImAvatar(
        placeholderText: widget.title,
        avatarUrl: widget.avatarUrl,
        avatarSize: widget.avatarSize,
        avatarShape: widget.avatarShape,
        avatarBorderRadius: widget.avatarSize! / 8.0,
      ),
    );
  }

  Widget get titleWidget {
    if (widget.titleBuilder != null) {
      return widget.titleBuilder!(widget.msgType);
    }

    print(widget.titleStyle.color);

    return Text(
      widget.title,
      overflow: TextOverflow.ellipsis,
      style: widget.titleStyle,
    );
  }

  Widget get subTitleWidget {
    if (widget.subTitleBuilder != null) {
      return widget.subTitleBuilder!(widget.msgType);
    }

    Widget resWidget = Container();

    if (ImMessageType.Draft == widget.msgType) {
      /// @TODO 对齐存在问题
      resWidget = Text.rich(
        TextSpan(children: [
          TextSpan(
            text: "[草稿] ",
            style: widget.subTitleStyle.merge(TextStyle(
              color: Style.TEXT_HIGHLIGHT,
              fontWeight: FontWeight.w500,
            )),
          ),
          WidgetSpan(
              child: ExtendedText(
            widget.subTitle,
            style: widget.subTitleStyle,
            // specialTextSpanBuilder: emojiTextSpanBuilder,
          )),
        ]),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      String str = "";

      switch (widget.msgType) {
        case ImMessageType.Text:
          str = widget.subTitle;
          break;
        case ImMessageType.Voice:
          str = "[语音]";
          break;
        case ImMessageType.Image:
          str = "[图片]";
          break;
        case ImMessageType.Video:
          str = "[视频]";
          break;
        case ImMessageType.VoiceCall:
          str = "[语音通话]";
          break;
        case ImMessageType.VideoCall:
          str = "[视频通话]";
          break;
        case ImMessageType.UnKnown:
          str = "[暂不支持此消息类型]";
          break;
      }

      resWidget = ExtendedText(
        str,
        overflow: TextOverflow.ellipsis,
        style: widget.subTitleStyle,
      );
    }

    return Container(
      child: resWidget,
    );
  }

  String get _timeFormat {
    if (widget.timeFormatConvertor != null) {
      return widget.timeFormatConvertor!(widget.timestamp!);
    }

    if (widget.timestamp != null) {
      return Tool.getFormatTime(widget.timestamp!);
    }
    return "";
  }

  Widget get timeFormatWidget {
    return Text(
      _timeFormat,
      style: widget.timeFormatStyle,
    );
  }

  List<Widget> get _endActions {
    List<Widget> endActions = [];

    if (widget.endActionsBuilder != null) {
      return widget.endActionsBuilder!(context);
    }

    endActions = [
      IconSlideAction(
        caption: '删除',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => widget.onItemDelete!(context),
      ),
    ];

    return endActions;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context);
    }

    return InkWell(
      onTap: () {
        if (widget.onTap != null) widget.onTap!();
      },
      child: Ink(
        child: SafeArea(
            child: Slidable(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: kVerticalPadding, horizontal: kHorizontalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    avatarWidget,
                    Expanded(
                      flex: 6,
                      child: Container(
                        // height: widget.avatarSize,
                        constraints: BoxConstraints(
                          minHeight: widget.avatarSize!,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   border: Border.all(),
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              titleWidget,
                              subTitleWidget,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: timeFormatWidget),
                  ],
                ),
              ),
              Visibility(
                visible: widget.showDivider,
                child: Container(
                  padding: EdgeInsets.only(
                      left: widget.avatarSize! + kHorizontalPadding * 2,
                      right: kHorizontalPadding),
                  child: Divider(
                    color: Style.DIVIDER,
                    height: 3,
                  ),
                ),
              )
            ],
          ),
          actionPane: SlidableStrechActionPane(),
          secondaryActions: _endActions,
        )),
      ),
    );
  }
}
