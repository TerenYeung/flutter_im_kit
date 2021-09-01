import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/widgets/mock_data.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';

class PhotoEditorPage extends StatefulWidget {
  const PhotoEditorPage({Key? key}) : super(key: key);

  @override
  _PhotoEditorPageState createState() => _PhotoEditorPageState();
}

class _PhotoEditorPageState extends State<PhotoEditorPage> {
  Uint8List? data;

  @override
  void initState() {
    _loadImageData();
    super.initState();
  }

  Future<void> _loadImageData() async {
    ByteData imageData = await NetworkAssetBundle(Uri.parse(kLink)).load("");
    Uint8List bytes = imageData.buffer.asUint8List();

    setState(() {
      data = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data != null ? PhotoEditorRouteWrapper(
        data: data,
    ) : Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white,),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('图片加载中...', style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),),
            )
          ],
        ),
      ),
    )
    ;
  }
}
