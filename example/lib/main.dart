import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:example/widgets/excellent_badge_page.dart';
import 'package:example/widgets/excellent_bubble_page.dart';
import 'package:example/widgets/im_conversation_page.dart';
import 'package:example/widgets/im_image_message_page.dart';
import 'package:example/widgets/im_message_page.dart';
import 'package:example/widgets/im_text_message_page.dart';
import 'package:example/widgets/im_voice_message_page.dart';
import 'package:example/widgets/photo_editor_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Im Kit',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Im Kit'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map> routes = [
    {
      'title': 'excellent_badge',
      'component': () => ExcellentBadgePage(),
    },
    {
      'title': 'excellent_bubble',
      'component': () => ExcellentBubblePage(),
    },
    {
      'title': 'im_conversation',
      'component': () => ImConversationPage(),
    },
    {
      'title': 'im_text_message',
      'component': () => ImTextMessagePage(),
    },
    {
      'title': 'im_image_message',
      'component': () => ImImageMessagePage(),
    },
    {
      'title': 'im_voice_message',
      'component': () => ImVoiceMessagePage(),
    },
    {
      'title': 'photo_editor',
      'component': () => PhotoEditorPage(),
    },
    {
      'title': 'im_message',
      'component': () => ImMessagePage(conversationId: '1'),
    },
  ];

  List<Widget> get entries {

    return routes.map((elem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return elem['component']();
                }),
              );
            }, child: Text(elem['title'])),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: entries,),
        )),
      ),
    );
  }
}
