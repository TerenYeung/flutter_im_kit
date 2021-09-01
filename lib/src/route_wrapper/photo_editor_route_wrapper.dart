import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/flutter_excellent_image_painter/flutter_excellent_image_painter.dart';
import 'package:flutter_im_kit/src/flutter_excellent_image_painter/flutter_excellent_slider.dart';
import 'package:flutter_im_kit/src/flutter_excellent_image_painter/pencil_color.dart';

class PhotoEditorRouteWrapper extends StatefulWidget {
  PhotoEditorRouteWrapper({
    Key? key,
    this.data,
    this.imageUrl,
    this.pencilColors,
    this.sliderBuilder,
    this.colorPickerBuilder,
    this.bottomControllerBuilder,
    this.onSend,
    this.onDownload,
  }) : super(key: key);
  final Uint8List? data;
  final String? imageUrl;
  final Map<String, Color>? pencilColors;
  final Widget Function(BuildContext context, PainterController painterController)? sliderBuilder;
  final Widget Function(BuildContext context, PainterController painterController)? colorPickerBuilder;
  final Widget Function(BuildContext context, PainterController painterController)? bottomControllerBuilder;
  final Function(Uint8List bytes)? onSend;
  final Function(Uint8List bytes)? onDownload;

  @override
  _PhotoEditorRouteWrapperState createState() => _PhotoEditorRouteWrapperState();
}

class _PhotoEditorRouteWrapperState extends State<PhotoEditorRouteWrapper> {
  late Image bg;
  GlobalKey<ExcellentImagePainterState> painterKey = GlobalKey<ExcellentImagePainterState>();

  //To use buttons
  double scale = 1;
  double translateX = 0;
  double translateY = 0;
  String savePath = "";

  //TO use modes
  bool isDrawMode = true;
  late PainterController _controller;
  int pointers = 0;
  bool _canEdit = true;
  String pencilColor = 'default';

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.backgroundImage = bg;
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  void _undo() {
    _controller.undo();
  }

  void toggleTransform(bool isDrawMode) {
    setState(() {
      isDrawMode = isDrawMode;
    });
    _controller.drawMode = isDrawMode;
    painterKey.currentState!.setState(() {});
  }


    @override
  void initState() {
    if (widget.data != null) {
      bg = Image.memory(widget.data!, fit: BoxFit.cover,);
    } else if (widget.imageUrl != null){
      bg = Image.network(widget.imageUrl!, fit: BoxFit.cover,);
    }
    _controller = _newController();
    _controller.drawMode = _canEdit;
    _controller.drawColor = pencilColors['default'];
    super.initState();
  }

  Map<String, Color> get pencilColors => widget.pencilColors ??  DefaultPencilColor;

  Widget get _topController {
    return Container(
      height: 80.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16.0,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 32,
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _sliderWidget {
    if (widget.sliderBuilder != null) {
      return widget.sliderBuilder!(context, _controller);
    }

    return Visibility(
      visible: _canEdit,
      child: Positioned(
        bottom: 76,
        left: (MediaQuery.of(context).size.width / 2 - 100),
        child: ExcellentSlider(
          color: Colors.white.withOpacity(.7),
          activeColor: Colors.white,
          backgroundColor: Colors.transparent,
          canvasWidth: 200,
          canvasHeight: 50,
          onChanged: (double value) {
            _controller.thickness = value;
          },
        ),
      ),
    );
  }

  Widget get _colorPickerWidget {
    if (widget.colorPickerBuilder != null) {
      return widget.colorPickerBuilder!(context, _controller);
    }

    List<Map<String, dynamic>> colors = pencilColors.entries.map((entry) {
      return {'key': entry.key, 'value': entry.value};
    }).toList();

    List<Widget> colorWidgets = colors.map((Map map) {
      bool isCurrentColor = pencilColor == map['key'];
      return Expanded(
        flex: 1,
        child: GestureDetector(
            onTap: () {
              setState(() {
                pencilColor = map['key'];
                _controller.drawColor = map['value'];
              });
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: isCurrentColor ? 24 : 20,
                height: isCurrentColor ? 24 : 20,
                decoration: BoxDecoration(
                  color: map['value'],
                  border: Border.all(
                      color: Colors.white, width: isCurrentColor ? 4 : 2),
                  borderRadius: BorderRadius.all(
                      Radius.circular(isCurrentColor ? 12 : 10)),
                ),
              ),
            ),
        ),
      );
    }).toList();

    colorWidgets.add(Expanded(
        flex: 1,
        child: IconButton(
          color: Colors.white,
          iconSize: 36.0,
          icon: Icon(Icons.undo_rounded),
          onPressed: () {
            _undo();
          },
        )));

    return Visibility(
      visible: _canEdit,
      child: Positioned(
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: colorWidgets,
          ),
        ),
      ),
    );
  }

  Widget get _centerContent {
    return Container(
      // color: Colors.red,
      child: Stack(
        children: [
          Listener(
            onPointerDown: (evt) {
              pointers++;
              if (pointers >= 2 || !_canEdit) {
                toggleTransform(false);
              } else {
                toggleTransform(true);
              }
            },
            onPointerUp: (evt) {
              pointers--;
              if (pointers >= 2 || !_canEdit) {
                toggleTransform(false);
              } else {
                toggleTransform(true);
              }
            },
            child: ExcellentImagePainter(
              _controller,
              key: painterKey,
            ),
          ),
          _sliderWidget,
          _colorPickerWidget,
        ],
      ),
    );
  }

  Widget get _bottomController {
    if (widget.bottomControllerBuilder != null) {
      return widget.bottomControllerBuilder!(context, _controller);
    }

    return Container(
      height: 80.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16.0,
            child: IconButton(
                iconSize: 32,
                onPressed: () async {
                  setState(() {
                    _canEdit = !_canEdit;
                    _controller.drawMode = !_controller.drawMode;
                  });
                  painterKey.currentState!.setState(() {});
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          ),
          Positioned(
            right: 80.0,
            child: IconButton(
                iconSize: 32,
                onPressed: () async {
                  if (widget.onDownload != null) {
                    Uint8List bytes = await _controller.getPNGBytes();
                    widget.onDownload!(bytes);
                  }
                },
                icon: Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                )),
          ),
          Positioned(
            right: 16.0,
            child: IconButton(
                iconSize: 32,
                onPressed: () async {
                  if (widget.onSend != null) {
                    Uint8List bytes = await _controller.getPNGBytes();
                    widget.onSend!(bytes);
                  }
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            constraints:
            BoxConstraints.expand(height: MediaQuery.of(context).size.height),
            child: Stack(
              children: [
                Positioned(child: _topController),
                Positioned(
                  top: 80.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 80.0,
                  child: _centerContent,
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: _bottomController,
                )
              ],
            ),
          ),
        )
    );
  }
}
