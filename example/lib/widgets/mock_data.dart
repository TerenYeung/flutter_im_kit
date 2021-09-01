import 'package:flutter_im_kit/src/utils.dart';

const String kLink = "https://source.unsplash.com/1900x3600/?camera,paper";
const String kVideoLink = 'https://www.runoob.com/try/demo_source/movie.mp4';
const String kAudioLink = "https://www.runoob.com/try/demo_source/horse.mp3";

class ImConversation {
  ImConversation({
    required this.id,
    this.title,
    this.subTitle,
    this.avatarUrl,
    this.msgType,
    this.timestamp,
    this.unreadCount,
  });
  String id;
  String? title;
  String? subTitle;
  String? avatarUrl;
  int? msgType;
  int? timestamp;
  int? unreadCount;
}

List<ImConversation> conversations = [
  ImConversation(
      id: '1',
      title: '普通会话',
      subTitle: 'I believe I can fly',
      avatarUrl: kLink,
      msgType: ImMessageType.Text,
      timestamp: 1629118437278,
      unreadCount: 1),
  ImConversation(
      id: '2',
      title: '圆角矩形头像-空头像',
      subTitle: 'I believe I can fly',
      avatarUrl: null,
      msgType: ImMessageType.Text,
      timestamp: 1629118437278,
      unreadCount: 120),
  ImConversation(
      id: '3',
      title: '草稿',
      subTitle: '飞翔',
      avatarUrl: kLink,
      msgType: ImMessageType.Draft,
      timestamp: 1629118437278,
      unreadCount: 1),
  ImConversation(
      id: '4',
      title: '图片会话',
      subTitle: 'I believe I can fly',
      avatarUrl: null,
      msgType: ImMessageType.Image,
      timestamp: 1629118437278,
      unreadCount: 120),
  ImConversation(
      id: '5',
      title: '视频会话',
      subTitle: 'I believe I can fly',
      avatarUrl: kLink,
      msgType: ImMessageType.Video,
      timestamp: 1629118437278,
      unreadCount: 1),
  ImConversation(
      id: '6',
      title: '语音会话',
      subTitle: 'I believe I can fly',
      avatarUrl: kLink,
      msgType: ImMessageType.Voice,
      timestamp: 1629118437278,
      unreadCount: 0),
  ImConversation(
      id: '7',
      title: '视频通话',
      subTitle: 'I believe I can fly',
      avatarUrl: kLink,
      msgType: ImMessageType.VideoCall,
      timestamp: 1629118437278,
      unreadCount: 99),
  ImConversation(
      id: '8',
      title: '语音通话',
      subTitle: 'I believe I can fly',
      avatarUrl: kLink,
      msgType: ImMessageType.VoiceCall,
      timestamp: 1629118437278,
      unreadCount: 78),
];

class MockImMessage {
  MockImMessage({
    required this.id,
    required this.conversationId,
    this.isMe,
    required this.msgType,
    this.name,
    this.avatarUrl,
    this.imageUrl,
    this.thumbWidth,
    this.thumbHeight,
    this.previewWidth,
    this.previewHeight,
    this.content,
    required this.createdAt,
    this.remoteUrl,
    this.msgStatus,
    this.isRecalled,
    this.duration,
  });
  String id;
  String conversationId;
  bool? isMe;
  int msgType;
  String? avatarUrl;
  String? name;
  String? imageUrl;
  double? thumbWidth;
  double? thumbHeight;
  double? previewWidth;
  double? previewHeight;
  String? content;
  int createdAt;
  String? remoteUrl;
  int? msgStatus;
  bool? isRecalled;
  int? duration;
}

List<MockImMessage> messages = [
  MockImMessage(
      id: '1',
      conversationId: '1',
      isMe: true,
      name: '科比',
      msgType: ImMessageType.System,
      content: '这是一个系统消息',
      msgStatus: ImMessageStatus.Sending,
      createdAt: 1629344350537,
  ),
  MockImMessage(
    id: '2',
    name: '詹姆斯',
    conversationId: '1',
    msgType: ImMessageType.Time,
    msgStatus: ImMessageStatus.SendFailed,
    createdAt: 1629344350537,
  ),
  MockImMessage(
    id: '3',
    conversationId: '1',
    name: '科比',
    isMe: true,
    msgType: ImMessageType.Text,
    msgStatus: ImMessageStatus.Sending,
    content: '这是文本消息',
    createdAt: 1629344350537,
  ),
  MockImMessage(
    id: '4',
    conversationId: '1',
    name: '詹姆斯',
    isMe: false,
    msgType: ImMessageType.Text,
    msgStatus: ImMessageStatus.SendFailed,
    content: '这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息',
    createdAt: 1629344350537,
  ),
  MockImMessage(
    id: '5',
    conversationId: '1',
    name: '詹姆斯',
    isMe: false,
    msgType: ImMessageType.Image,
    content: '这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息',
    createdAt: 1629344350537,
    imageUrl: kLink,
  ),
  MockImMessage(
    id: '6',
    conversationId: '1',
    name: '詹姆斯',
    avatarUrl: kLink,
    isMe: false,
    thumbWidth: 120,
    thumbHeight: 200,
    msgType: ImMessageType.Image,
    content: '这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息',
    createdAt: 1629344350537,
    imageUrl: kLink,
  ),
  MockImMessage(
    id: '7',
    conversationId: '1',
    name: '詹姆斯',
    isMe: false,
    thumbWidth: 120,
    thumbHeight: 200,
    msgType: ImMessageType.Video,
    content: '这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息',
    createdAt: 1629344350537,
    duration: 12123,
    imageUrl: kLink,
    remoteUrl: kVideoLink,
  ),
  MockImMessage(
    id: '8',
    conversationId: '1',
    name: '詹姆斯',
    isMe: true,
    // avatarUrl: kLink,
    thumbWidth: 120,
    thumbHeight: 200,
    msgType: ImMessageType.Voice,
    content: '这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息',
    createdAt: 1629344350537,
    duration: 12,
    imageUrl: kLink,
    remoteUrl: kAudioLink,
  ),
];
