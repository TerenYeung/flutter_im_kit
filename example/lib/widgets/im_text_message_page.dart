import 'package:flutter/material.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';

const double kPadding = 20.0;

class ImTextMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Im Text Message',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Im Text Message'),
          ),
          body: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImTextMessage(
                    content: '这是文本消息',
                    isMe: true,
                  ),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImTextMessage(
                    content: '设置消息来源 [流泪]',
                    isMe: false,
                  ),
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImTextMessage(
                    content: '这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息',
                    isMe: true,
                  ),
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImTextMessage(
                    content: '设置背景色-设置文本样式',
                    isMe: true,
                    selfBackgroundColor: Colors.teal,
                    selfTextStyle: TextStyle(
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                Container(
                  width: 260,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImTextMessage(
                    content: '设置「圆角矩形」气泡类型',
                    isMe: true,
                    bubbleType: BubbleType.RoundRect,
                  ),
                ),
                Container(
                  width: 260,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImTextMessage(
                    content: '重建「展开」按钮重建「展开」按钮重建「展开」按钮重建「展开」按钮重建「展开」按钮',
                    isMe: true,
                    limit: 20,
                    expandBuilder: (BuildContext context, bool isExpanded) {
                      return Text( isExpanded ? '↑' : '↓', style: TextStyle(color: Colors.white,
                        fontSize: 16.0
                      ),);
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
