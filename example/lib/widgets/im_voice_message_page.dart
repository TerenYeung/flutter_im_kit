import 'package:flutter/material.dart';
import 'package:example/widgets/mock_data.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';
import 'package:just_audio/just_audio.dart';

const double kPadding = 20.0;

class ImVoiceMessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Im Voice Message',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Im Voice Message'),
            // backwardsCompatibility: true,
          ),
          body: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImVoiceMessage(
                    isMe: true,
                    duration: 145,
                    remoteUrl: kAudioLink,
                  ),
                ),
                Text(
                  '默认样式-我',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImVoiceMessage(
                    isMe: false,
                    duration: 145,
                    remoteUrl: kAudioLink,
                  ),
                ),
                Text(
                  '默认样式-对方',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(kPadding),
                  child: ImVoiceMessage(
                    isMe: false,
                    duration: 145,
                    remoteUrl: kAudioLink,
                    contentBuilder: (BuildContext context, AudioPlayer player) {
                      return Row(
                        children: [
                          Icon(Icons.record_voice_over_rounded),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(Tool.getElapsedTime(123),),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Text(
                  '自定义样式',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
