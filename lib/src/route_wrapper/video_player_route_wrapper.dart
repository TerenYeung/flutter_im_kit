import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/utils.dart';
import 'package:video_player/video_player.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class VideoPlayerRouteWrapper extends StatefulWidget {
  const VideoPlayerRouteWrapper({
    Key? key,
    // this.imageUrl,
    required this.videoUrl,
    // this.duration,
    this.autoPlay = true,
    this.onDownloadTap,
    this.onCloseTap,
    this.downloadIcon,
    this.playIcon,
    this.showDownloadBtn = true,
    this.showProgress = true,
  }) : super(key: key);
  // final String? imageUrl;
  final String videoUrl;
  // final int? duration;
  final bool? autoPlay;
  final Function(String videoUrl)? onDownloadTap;
  final Function(BuildContext context)? onCloseTap;
  final Widget? downloadIcon;
  final Widget? playIcon;
  final bool? showDownloadBtn;
  final bool? showProgress;

  @override
  _VideoPlayerRouteWrapperState createState() =>
      _VideoPlayerRouteWrapperState();
}

class _VideoPlayerRouteWrapperState extends State<VideoPlayerRouteWrapper>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _showModal = true;

  bool hasErrorWhenInitializing = false;
  bool hasLoaded = false;
  late VideoPlayerController videoController;
  bool _isShow = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool get isControllerPlaying => videoController.value.isPlaying;
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  final ValueNotifier<int> position = ValueNotifier<int>(0);

  Widget get playControlButton {
    return ValueListenableBuilder<bool>(
      valueListenable: isPlaying,
      builder: (_, bool value, Widget? child) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: value && _isShow ? playButtonCallback : null,
        child: Center(
          child: AnimatedOpacity(
            duration: kThemeAnimationDuration,
            opacity: value ? 0.0 : 1.0,
            child: GestureDetector(
              onTap: playButtonCallback,
              child: widget.playIcon != null ? widget.playIcon : Icon(
                value ? Icons.pause : Icons.play_arrow_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get progressSlider {
    return ValueListenableBuilder<int>(
      valueListenable: position,
      builder: (_, int value, Widget? child) => Container(
        height: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Tool.getPlayTime(value),
              style: TextStyle(color: Colors.white, fontSize: 11.0),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackShape: CustomTrackShape(),
                    trackHeight: 2.0,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.0,
                    ),
                  ),
                  child: Slider(
                    inactiveColor: Color(0xFF4C4C4C),
                    activeColor: Colors.white,
                    min: 0.0,
                    max: videoController.value.duration.inMilliseconds
                            .toDouble(),
                    value: value.toDouble(),
                    onChangeStart: (evt) {
                      videoController.pause();
                    },
                    onChangeEnd: (evt) {
                      videoController.play();
                    },
                    onChanged: (value) {
                      videoController
                          .seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
              ),
            ),
            Text(
              Tool.getPlayTime(
                  videoController.value.duration.inMilliseconds),
              style: TextStyle(color: Colors.white, fontSize: 11.0),
            )
          ],
        ),
      ),
    );
  }

  Future<void> playButtonCallback() async {
    if (isPlaying.value) {
      videoController.pause();
    } else {
      if (videoController.value.duration == videoController.value.position) {
        videoController
          ..seekTo(Duration.zero)
          ..play();
      } else {
        videoController.play();
      }

      Future.delayed(Duration(seconds: 3), () {
        togglePlayerController(false);
      });
    }
  }

  void togglePlayerController(bool isShow) {
    setState(() {
      _isShow = isShow;
      if (isShow) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  Future<void> initializeVideoPlayerController() async {
    try {
      await videoController.initialize();
      videoController.addListener(videoPlayerListener);
      hasLoaded = true;
      autoPlay();
    } catch (e) {
      hasErrorWhenInitializing = true;
      print('Error when initializing video controller: $e');
      rethrow;
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_animationController);
  }

  void resetPlayer() {
    if (videoController != null) {
      videoController
        ..seekTo(Duration.zero)
        ..pause();
    }
  }

  void autoPlay() {
    if (videoController != null) {
      videoController
        ..seekTo(Duration.zero)
        ..play();
    }
  }

  void videoPlayerListener() {
    if (isControllerPlaying != isPlaying.value) {
      isPlaying.value = isControllerPlaying;
    }

    if (videoController.value.position.inSeconds.toInt() == 1 && _isShow) {
      /// 播放三秒自动隐藏所有功能按钮
      print('>>>>>>>>>>>>>>>>>>>>>>>>>');
      togglePlayerController(false);
    }

    position.value = videoController.value.position.inMilliseconds;
  }

  void _onDownloadTap(String videoUrl) {
    if (widget.onDownloadTap != null) {
      widget.onDownloadTap!(videoUrl);
    }
  }

  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.videoUrl);
    initializeVideoPlayerController();
    initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    /// Remove listener from the controller and dispose it when widget dispose.
    /// 部件销毁时移除控制器的监听并销毁控制器。
    videoController.removeListener(videoPlayerListener);
    videoController.pause();
    videoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasErrorWhenInitializing) {
      return Center(
        child: Text(
          "加载失败",
          style: const TextStyle(inherit: false),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showModal = !_showModal;
          });
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FadeTransition(
                opacity: _animation,
                child: Container(
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(Icons.close_rounded, size: 32, color: Colors.white,),
                        ),
                        onTap: () async {
                          if (widget.onCloseTap != null) {
                            widget.onCloseTap!(context);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        ),
                      ),
                    ),
                    FadeTransition(
                        opacity: _animation,
                        child: playControlButton),
                    if (!_isShow)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            togglePlayerController(true);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                            ),
                          ),
                        ),
                      )

                  ],
                ),
              ),
              FadeTransition(
                opacity: _animation,
                child: Container(
                  height: 80.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Visibility(
                          visible: widget.showProgress!,
                          maintainAnimation: true,
                          maintainSize: true,
                          maintainState: true,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: progressSlider,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Visibility(
                          visible: widget.showDownloadBtn!,
                          maintainAnimation: true,
                          maintainSize: true,
                          maintainState: true,
                          child: GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child:
                              widget.downloadIcon != null ? widget.downloadIcon : Icon(Icons.download_rounded, size: 28, color: Colors.white,),
                            ),
                            onTap: () async {
                              _onDownloadTap(widget.videoUrl);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
