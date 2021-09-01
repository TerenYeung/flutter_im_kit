import 'package:example/widgets/im_message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';
import 'mock_data.dart' as MockData;

const String kLink = "https://source.unsplash.com/1900x3600/?camera,paper";

class ImConversationPage extends StatelessWidget {
  List<MockData.ImConversation> conversations = MockData.conversations;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Im Conversation',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Im Conversation'),
          ),
          body: ListView.builder(
            itemCount: conversations.length,
            // itemExtent: 68,
            itemBuilder: (BuildContext context, int index) {
              MockData.ImConversation item = conversations[index];

              return ImConversation(
                key: ValueKey(item.id) ,
                avatarUrl: item.avatarUrl,
                title: item.title!,
                subTitle: item.subTitle!,
                msgType: item.msgType!,
                timestamp: item.timestamp!,
                unreadCount: item.unreadCount!,
                avatarShape: index == 1 ? BoxShape.rectangle : BoxShape.circle,
                onTap: () {
                  print(index.toString());
                  final snackBar = SnackBar(content: Text('${index + 1} 会话被点击'), duration: Duration(milliseconds: 600),);
                  Scaffold.of(context).showSnackBar(snackBar);
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return ImMessagePage(conversationId: item.id);
                  }));
                },
                onItemDelete: (BuildContext context) {
                  final snackBar = SnackBar(content: Text('${index + 1} 会话被删除'), duration: Duration(milliseconds: 600),);
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              );
            },
          )
          ),
    );
  }
}
