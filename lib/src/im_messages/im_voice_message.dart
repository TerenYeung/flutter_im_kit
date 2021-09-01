import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/flutter_excellent_bubble.dart';
import 'package:flutter_im_kit/src/im_messages/im_voice_msg_anim_view.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';
import 'package:just_audio/just_audio.dart';

class ImVoiceMessage extends StatefulWidget {
  const ImVoiceMessage({
    Key? key,
    this.duration,
    this.remoteUrl,
    this.localPath,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    required this.isMe,
    this.selfTextStyle = const TextStyle(
      fontSize: 16.0,
      color: Style.MSG_TEXT_SELF,
    ),
    this.otherTextStyle = const TextStyle(
      fontSize: 16.0,
      color: Style.MSG_TEXT_OTHER,
    ),
    this.arrowSize = 10.0,
    this.selfBackgroundColor = Style.MSG_BG_SELF,
    this.otherBackgroundColor = Style.MSG_BG_OTHER,
    this.bubbleType = BubbleType.Normal,
    this.topLeft = 8.0,
    this.topRight = 8.0,
    this.bottomLeft = 8.0,
    this.bottomRight = 8.0,
    this.contentBuilder,
    this.builder,
  }) : super(key: key);
  final double? duration;
  final String? remoteUrl;
  final String? localPath;
  final bool isMe;
  final double? arrowSize;
  final Color? selfBackgroundColor;
  final Color? otherBackgroundColor;
  final TextStyle? selfTextStyle;
  final TextStyle? otherTextStyle;
  final BubbleType? bubbleType;
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;
  final EdgeInsets? padding;
  final Widget Function(BuildContext context, AudioPlayer audioPlayer)?
      contentBuilder;
  final BuilderType? builder;

  @override
  _ImVoiceMessageState createState() => _ImVoiceMessageState();
}

class _ImVoiceMessageState extends State<ImVoiceMessage> {
  // ChewieAudioController? audioController;
  // late VideoPlayerController videoPlayerController;
  late AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  String get _formatDuration {
    return Tool.getElapsedTime(widget.duration!.toInt(),
        formatter: (hours, minutes, seconds) {
      String ret = "";
      if (hours != 0) {
        ret += hours.toString() + ":";
      }

      if (minutes != 0) {
        ret += minutes.toString() + "'";
      }

      if (seconds != 0) {
        ret += seconds.toString() + '"';
      }

      return ret;
    });
  }

  Future<void> play() async {
    await audioPlayer.seek(Duration(seconds: 0));
    await audioPlayer.play();
  }

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  Future<void> initAudioPlayer() async {
    if (widget.remoteUrl != null && widget.remoteUrl!.isNotEmpty) {
      audioPlayer.setUrl(widget.remoteUrl!);
    } else if (widget.localPath != null && widget.localPath!.isNotEmpty) {
      audioPlayer.setFilePath(widget.localPath!);
    }

    audioPlayer.playerStateStream.listen((state) {
      if (!isPlaying && state.playing) {
        setState(() {
          isPlaying = true;
        });
      } else if (state.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Widget get _voiceWidget {
    if (widget.contentBuilder != null) {
      return widget.contentBuilder!(context, audioPlayer);
    }

    List<Widget> widgets = [];

    Widget textWidget = Padding(
      padding: EdgeInsets.only(
          left: widget.isMe ? 0.0 : 6.0, right: widget.isMe ? 6.0 : 0),
      child: Text(
        _formatDuration,
        style: TextStyle(
          color: widget.isMe ? Style.MSG_TEXT_SELF : Style.MSG_TEXT_OTHER,
        ),
      ),
    );

    Widget animateWidget = ImVoiceMsgAnimView(
      doAnim: isPlaying,
      color: widget.isMe ? Style.MSG_TEXT_SELF : Style.MSG_TEXT_OTHER,
    );

    if (widget.isMe) {
      widgets.addAll([
        textWidget,
        animateWidget,
      ]);
    } else {
      widgets.insertAll(0, [animateWidget, textWidget]);
    }

    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context);
    }

    return GestureDetector(
        onTap: play,
        child: Container(
          padding: EdgeInsets.only(
              left: widget.isMe ? 0 : widget.arrowSize!,
              right: widget.isMe ? widget.arrowSize! : 0),
          child: ExcellentBubble(
            bubbleType: widget.bubbleType,
            backgroundColor: widget.isMe
                ? widget.selfBackgroundColor
                : widget.otherBackgroundColor,
            topLeft: widget.topLeft!,
            topRight: widget.topRight!,
            bottomLeft: widget.bottomLeft!,
            bottomRight: widget.bottomRight!,
            position: widget.isMe
                ? BubblePosition.rightCenter
                : BubblePosition.leftCenter,
            child: Container(
                constraints: BoxConstraints(
                    minWidth: 80.0
                ),
                child: _voiceWidget),
          ),
        ));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
