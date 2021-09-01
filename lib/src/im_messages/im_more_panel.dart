import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CustomCameraPickerTextDelegate implements CameraPickerTextDelegate {
  factory CustomCameraPickerTextDelegate() => _instance;

  CustomCameraPickerTextDelegate._internal();

  static final CustomCameraPickerTextDelegate _instance =
  CustomCameraPickerTextDelegate._internal();

  @override
  String confirm = '发送';

  @override
  String shootingTips = '轻触拍照，长按摄像';

  @override
  String loadFailed = '加载失败';
}


typedef GalleryAssetsPickedCallback = Function(BuildContext context, List<AssetEntity>);
typedef CameraAssetCapturedCallback = Function(BuildContext context, AssetEntity asset);

class PanelConfig {
  PanelConfig({
    required this.id,
    required this.title,
    required this.icon,
    this.callback,
  });
  String id;
  String title;
  IconData icon;
  void Function(BuildContext context)? callback;
}

class ImMorePanel extends StatefulWidget {
  const ImMorePanel({
    Key? key,
    // this.panels = List(),
    this.panels,
    this.themeColor = Style.PRIMARY_COLOR,
    this.onGalleryAssetsPicked,
    this.onCameraAssetCaptured,
    this.onCommunicationTap,
  }) : super(key: key);
  final List<PanelConfig>? panels;
  final Color? themeColor;
  final GalleryAssetsPickedCallback? onGalleryAssetsPicked;
  final CameraAssetCapturedCallback? onCameraAssetCaptured;
  final BuilderType? onCommunicationTap;

  @override
  _ImMorePanelState createState() => _ImMorePanelState();
}

class _ImMorePanelState extends State<ImMorePanel> {
  List<PanelConfig> _panels = [];

  @override
  void initState() {
    _initPanels();
    super.initState();
  }

  void _initPanels() {
    setState(() {
      _panels = [
        PanelConfig(
            id: 'image',
            title: '图片',
            icon: Icons.image_rounded,
            callback: (context) => _goToImagePicker(context)
        ),
        PanelConfig(
          id: 'camera',
          title: '拍摄',
          icon: Icons.camera_alt_rounded,
          callback: (context) => _goToCameraPicker(context),
        ),
        PanelConfig(
          id: 'video',
          title: '视频通话',
          icon: Icons.videocam_rounded,
          callback: (context) => _goToVideoPicker(context),
        ),
      ];
    });
  }

  List<PanelConfig> get panels {
    if (widget.panels != null) {
      return widget.panels!;
    }

    return _panels;
  }

  Future<void> _goToImagePicker(context) async {
    PermissionStatus status = (await Permission.storage.request());

    if (!status.isGranted) {
      EasyLoading.showToast("请先开启存储权限");
      return;
    }

    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      maxAssets: 9,
      requestType: RequestType.common,
      themeColor: widget.themeColor,
    );

    if (assets != null && widget.onGalleryAssetsPicked != null) {
      widget.onGalleryAssetsPicked!(context, assets);
    }
  }

  Future<void> _goToCameraPicker(context) async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone,
    ].request();

    if (
      !(statuses[Permission.storage] as PermissionStatus).isGranted ||
          !(statuses[Permission.camera] as PermissionStatus).isGranted ||
      !(statuses[Permission.microphone] as PermissionStatus).isGranted
    ) {
      EasyLoading.showToast("请先开启存储、摄像头以及麦克风权限");
      return;
    }

    final AssetEntity? assetEntity = await CameraPicker.pickFromCamera(
        context,
        enableRecording: true,
        theme: CameraPicker.themeData(Style.PRIMARY_COLOR),
        maximumRecordingDuration: Duration(minutes: 1),
        // imageFormatGroup: ImageFormatGroup.jpeg,
        textDelegate: CustomCameraPickerTextDelegate()
    );

    if (assetEntity != null && widget.onCameraAssetCaptured != null) {
      widget.onCameraAssetCaptured!(context, assetEntity);
    }
  }

  Future<void> _goToVideoPicker(context) async {
    if (widget.onCommunicationTap != null) {
      widget.onCommunicationTap!(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('morePanel');
    return Container(
      key: ValueKey<String>('more'),
      decoration: BoxDecoration(color: Colors.white),
      constraints: BoxConstraints(minHeight: 240),
      // height: 200,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 2, crossAxisCount: 4, childAspectRatio: 1.0),
          itemCount: panels.length,
          itemBuilder: (context, index) {
            PanelConfig item = panels[index];

            return GestureDetector(
              onTap: () {
                final Function callback = item.callback as Function;
                if (callback != null) callback(context);
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                        color: Color(0xFFF8F8FA),
                        width: 60,
                        height: 60,
                        child: Icon(
                          item.icon,
                          size: 32,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
