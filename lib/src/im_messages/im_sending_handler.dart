import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/im_emoji/emoji.dart';
import 'package:flutter_im_kit/src/im_emoji/emoji_text_span_builder.dart';
import 'package:flutter_im_kit/src/im_emoji/im_emoji_cache.dart';
import 'package:flutter_im_kit/src/im_emoji/im_emoji_utils.dart';
import 'package:flutter_im_kit/src/im_messages/im_emoji_panel.dart';
import 'package:flutter_im_kit/src/im_messages/im_more_panel.dart';
import 'package:flutter_im_kit/src/im_slide_transition.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';

class ImSendingHandler extends StatefulWidget {
  const ImSendingHandler({
    Key? key,
    this.onSendMessage,
    this.onGalleryAssetsPicked,
    this.onCameraAssetCaptured,
    this.onCommunicationTap,
    this.emojiPanelBuilder,
    this.morePanels,
    this.pickerThemeColor,
    this.voiceIcon = const Icon(Icons.keyboard_voice),
    this.keyboardIcon = const Icon(Icons.keyboard_rounded),
    this.emojiIcon = const Icon(Icons.emoji_emotions_outlined),
    this.moreIcon = const Icon(Icons.add),
    this.emojiPathPrefix,
    this.emojiPathSuffix,
    this.builder,
    this.onVoiceBtnPress,
  }) : super(key: key);
  final Widget? voiceIcon;
  final Widget? keyboardIcon;
  final Widget? emojiIcon;
  final Widget? moreIcon;
  final String? emojiPathPrefix;
  final String? emojiPathSuffix;
  final Future<void>Function(String value, TextEditingController controller)? onSendMessage;
  final GalleryAssetsPickedCallback? onGalleryAssetsPicked;
  final CameraAssetCapturedCallback? onCameraAssetCaptured;
  final BuilderType? onCommunicationTap;
  final List<PanelConfig>? morePanels;
  final Widget Function(BuildContext context, TextEditingController controller, EmojiTextSpanBuilder emojiTextSpanBuilder)? emojiPanelBuilder;
  final Color? pickerThemeColor;
  final Function(BuildContext context, TextEditingController controller)? builder;
  final Function()? onVoiceBtnPress;

  @override
  ImSendingHandlerState createState() => ImSendingHandlerState();
}

class ImSendingHandlerState extends State<ImSendingHandler> {
  List<Emoji> systemEmojis = [];
  TextEditingController _textEditingController = TextEditingController();
  late void Function() editControllerListener;
  BottomPanelState _currentPanel = BottomPanelState.NOTHING;
  bool _isExpanded = false;
  FocusNode _focusNode = FocusNode();
  EmojiTextSpanBuilder? emojiTextSpanBuilder;
  TextSelection? lastSelection;

  Widget get _textFieldHandler {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            border: Border.all(color: Style.DIVIDER),
            borderRadius: BorderRadius.all(Radius.circular(20.5)),
          ),
          child: ExtendedTextField(
            specialTextSpanBuilder: emojiTextSpanBuilder,
            autofocus: false,
            focusNode: _focusNode,
            cursorWidth: 2,
            cursorColor: Style.TEXT_FIELD_CURSOR_COLOR,
            controller: _textEditingController,
            style: TextStyle(color: Style.TEXT_FIELD_COLOR, fontSize: 16.0),
            decoration: InputDecoration(
                isDense: true,
                counterText: "",
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.send,
            minLines: 1,
            maxLines: 4,
            maxLength: 600,
            onTap: () {
              /// @TODO 键盘弹起影响布局问题
              setState(() {
                _isExpanded = false;
                _currentPanel = BottomPanelState.KEYBOARD;
              });
            },
            onChanged: (text) {},
            onSubmitted: (text) {
              if (widget.onSendMessage != null && textValue.isNotEmpty) {
                widget.onSendMessage!(textValue, _textEditingController);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget get _voiceHandlerWidget {
    return InkWell(
      onLongPress: () {
          if (widget.onVoiceBtnPress != null) {
            widget.onVoiceBtnPress!();
          }
      },
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.5)),
      ),
      child: Container(
        // height: 40,
        // alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          border: Border.all(color: Style.DIVIDER),
          borderRadius: BorderRadius.all(Radius.circular(20.5)),
        ),
        child: Text(
          '按住 说话',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget get messageController {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Style.DIVIDER)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    _togglePanel(_currentPanel == BottomPanelState.AUDIO_RECORD
                        ? BottomPanelState.KEYBOARD
                        : BottomPanelState.AUDIO_RECORD);
                  },
                  icon:  _currentPanel == BottomPanelState.AUDIO_RECORD
                      ? widget.keyboardIcon!
                      : widget.voiceIcon!
              )
          ),
          Expanded(
              flex: 6,
              child: BottomPanelState.AUDIO_RECORD == _currentPanel
                  ? _voiceHandlerWidget
                  : _textFieldHandler),
          Expanded(
            // right: 0.0,
            flex: 1,
            child: IconButton(
              onPressed: () {
                _togglePanel(
                  _currentPanel == BottomPanelState.EMOJI
                      ? BottomPanelState.KEYBOARD
                      : BottomPanelState.EMOJI,
                );
              },
              icon: _currentPanel == BottomPanelState.EMOJI
                  ? widget.keyboardIcon! : widget.emojiIcon!
            ),
          ),
          Expanded(
              flex: 1,
              child: IconButton(onPressed: () {
                _togglePanel(
                  _currentPanel == BottomPanelState.MORE
                      ? BottomPanelState.KEYBOARD
                      : BottomPanelState.MORE,
                );
              }, icon: widget.moreIcon!)),
        ],
      ),
    );
  }

  String get textValue => _textEditingController.text.trim();

  Widget get messagePanel {
    Widget _panel = Container();
    switch (_currentPanel) {
      case BottomPanelState.EMOJI:
        if (widget.emojiPanelBuilder != null) {
          _panel = widget.emojiPanelBuilder!(context, _textEditingController, emojiTextSpanBuilder!);
        } else {
          _panel = ImEmojiPanel(
            systemEmojis: systemEmojis,
            onSystemEmojiClick: (Emoji emoji) {
              setState(() {
                ImEmojiUtils.insertText(_textEditingController, emoji.value);
              });
            },
            onSystemEmojiDelete: () {
              ImEmojiUtils.manualDelete(_textEditingController, emojiTextSpanBuilder!);
            },
            onSystemEmojiSend: () {
              if (widget.onSendMessage != null && textValue.isNotEmpty) {
                widget.onSendMessage!(textValue, _textEditingController);
              }
            },
          );
        }
        break;
      case BottomPanelState.MORE:
        _panel = ImMorePanel(
          panels: widget.morePanels,
          themeColor: widget.pickerThemeColor,
          onGalleryAssetsPicked: widget.onGalleryAssetsPicked,
          onCameraAssetCaptured: widget.onCameraAssetCaptured,
          onCommunicationTap: widget.onCommunicationTap,
        );
        break;
      case BottomPanelState.PLACE_HOLDER:
        _panel = Container(height: 0.0);
        break;
      default:
        _panel = Container();
        break;
    }

    return AnimatedCrossFade(
        firstChild: Container(
          height: 0.0,
        ),
        secondChild: AnimatedSwitcher(
            switchOutCurve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ImSlideTransition(
                child: child,
                position: animation,
                curve: Curves.easeOut,
                direction: AxisDirection.up,
              );
            },
            child: _panel
        ),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        crossFadeState:
        _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 120));
  }

  @override
  void initState() {
    _updateEmojis();
    _bindEditListener();
    super.initState();
  }

  void _bindEditListener() {
    editControllerListener = () {
      if (_textEditingController.selection.isValid) {
        lastSelection = _textEditingController.selection;
      }
    };
    _textEditingController.addListener(editControllerListener);
  }

    void _updateEmojis() {
    ImEmojiCache.instance.getSystemEmojisAsync((emojis, async) {
      systemEmojis.addAll(emojis);
      emojiTextSpanBuilder = EmojiTextSpanBuilder(emojis);
      if (async) setState(() {});
    }, emojiPathSuffix: widget.emojiPathSuffix, emojiPathPrefix: widget.emojiPathPrefix);
  }

  void _togglePanel(BottomPanelState current) {
    setState(() {
      /// 点击 voice，切换为 keyboard，键盘收起，textFieldHandler 切换为"按住 说话"
      /// 点击 keyboard，切换为 voice，键盘拉起，textFieldHandler 切换为输入框，焦点聚焦
      /// 点击 emoji，切换为 keyboard，键盘收起，emoji 面板拉起，失去焦点
      /// 点击 keyboard，切换为 emoji，键盘拉起，焦点聚焦
      /// 点击 more，more 面板拉起，失去焦点

      if (_isExpanded && _currentPanel == current) {
        // _isExpanded = true;
        _currentPanel = BottomPanelState.PLACE_HOLDER;
        _focusNode.requestFocus();
        return;
      }

      switch (current) {
        case BottomPanelState.AUDIO_RECORD:
          _focusNode.unfocus();
          _isExpanded = false;
          break;
        case BottomPanelState.KEYBOARD:
          _focusNode.requestFocus();
          _isExpanded = false;
          break;
        case BottomPanelState.EMOJI:
          _focusNode.unfocus();
          _isExpanded = true;
          break;
        case BottomPanelState.MORE:
          _focusNode.unfocus();
          _isExpanded = true;
          break;
        default:
          _focusNode.unfocus();
          _isExpanded = false;
          break;
      }
      _currentPanel = current;
    });
  }


  void resetController() {
    if (_isExpanded || _focusNode.hasFocus) {
      setState(() {
        _isExpanded = false;
        _currentPanel = BottomPanelState.NOTHING;
        _focusNode.unfocus();
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    if (widget.builder != null) {
      return widget.builder!(context, _textEditingController);
    }
    if (lastSelection != null &&
        _textEditingController.selection != lastSelection &&
        _textEditingController.text.isNotEmpty) {
      _textEditingController.selection = lastSelection!;
    }

    return Column(
      children: [
        messageController,
        messagePanel,
      ],
    );
  }
}
