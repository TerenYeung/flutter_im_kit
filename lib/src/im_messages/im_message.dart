import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/common_widgets.dart';
import 'package:flutter_im_kit/src/im_messages/im_image_message.dart';
import 'package:flutter_im_kit/src/im_messages/im_system_message.dart';
import 'package:flutter_im_kit/src/im_messages/im_text_message.dart';
import 'package:flutter_im_kit/src/im_messages/im_time_message.dart';
import 'package:flutter_im_kit/src/im_messages/im_voice_message.dart';
import 'package:flutter_im_kit/src/model/gallery_image_info.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';

class ImMessage extends StatelessWidget {
  const ImMessage({
    Key? key,
    this.conversationId,
    required this.msgId,
    this.isMe,
    this.name,
    this.avatarUrl,
    this.avatarSize = 44.0,
    this.avatarShape = BoxShape.circle,
    this.textLimit = 100,
    this.thumbWidth = 100.0,
    this.thumbHeight = 100.0,
    this.imageUrl,
    this.localPath,
    this.duration,
    this.remoteUrl,
    this.content,
    required this.createdAt,
    this.msgType,
    this.msgStatus,
    this.galleryImages = const [],
    this.sendStatusBuilder,
    this.builder,
  }) : super(key: key);
  final String? conversationId;
  final String msgId;
  final bool? isMe;

  final String? name;

  /// 头像
  final String? avatarUrl;
  final double? avatarSize;
  final BoxShape? avatarShape;

  /// 文本
  final int? textLimit;

  /// 图片
  final double? thumbWidth;
  final double? thumbHeight;
  final String? imageUrl;
  final List<GalleryImageInfo> galleryImages;

  /// 音视频
  final int? duration;
  final String? remoteUrl;
  final String? localPath;

  /// 内容
  final String? content;
  final int createdAt;
  final int? msgType;
  final int? msgStatus;
  final Widget Function(int msgStatus)? sendStatusBuilder;
  final BuilderType? builder;

  bool get _isMe => isMe != null && isMe!;

  Widget get sendStatusWidget {
    if (sendStatusBuilder != null) {
      return sendStatusBuilder!(msgStatus!);
    }

    return Visibility(
      visible: msgStatus == ImMessageStatus.Sending || msgStatus == ImMessageStatus.SendFailed,
      child: Padding(
        padding: EdgeInsets.only(left: isMe! ? 0.0 : 15.0, right: isMe! ? 15.0 : 0),
        child: Container(
          width: 16.0,
          height: 16.0,
          child:
          msgStatus == ImMessageStatus.Sending
            ? CircularProgressIndicator(
            color: Style.MSG_SEND_STATUS_LOADING,
            strokeWidth: 2.0,
          ) : Icon(Icons.error_rounded, color: Style.MSG_SEND_STATUS_FAIL,),
        ),
      ),
    );
    return Container();
  }

  Widget _buildMessageByType(BuildContext context) {
    Widget message = Container();

    switch (msgType) {
      case ImMessageType.System:
        return Center(child: ImSystemMessage(content: content!));
      case ImMessageType.Time:
        return Center(child: ImTimeMessage(milliseconds: createdAt),);
      case ImMessageType.Text:
        message = ImTextMessage(content: content!, isMe: _isMe, limit: textLimit);
        break;
      case ImMessageType.Image:
      case ImMessageType.Video:
        message = ImImageMessage(
            imageId: msgId,
            imageUrl: imageUrl!,
            videoUrl: remoteUrl,
            type: msgType,
            thumbWidth: thumbWidth,
            thumbHeight: thumbHeight,
            galleryImages: galleryImages,
            duration: duration,
        );
        break;
      case ImMessageType.UnKnown:
        message = ImTextMessage(content: '暂不支持此消息类型', isMe: _isMe, limit: textLimit);
        break;
    }

    List<Widget> widgets = [];

    if (_isMe) {
      widgets.addAll([sendStatusWidget, message,]);
    } else {
      widgets.insertAll(0, [message, sendStatusWidget]);
    }

    EdgeInsets padding = EdgeInsets.all(0);

    if (ImMessageType.Text == msgType) {
      padding = EdgeInsets.fromLTRB(_isMe ? 20.0 : 0, 0, _isMe ? 0 : 20.0, 0);
    } else {
      padding = EdgeInsets.fromLTRB(_isMe ? 10.0 : 0, 0, _isMe ? 0 : 10.0, 0);
    }

    return Row(
      textDirection: _isMe ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: ImAvatar(
            avatarSize: avatarSize,
            avatarShape: avatarShape,
            avatarUrl: avatarUrl,
            placeholderText: name ?? "",
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: widgets,
            ),
            /// @TODO 长按逻辑的实现
            // Positioned(
            //   // top: -10,
            //   child: Container(
            //     width: 120,
            //     height: 20,
            //     color: Colors.black.withOpacity(.4),
            //   ),
            // )
          ],
        )

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      return builder!(context);
    }

    return _buildMessageByType(context);
  }
}

