import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointValidateScreen extends StatefulWidget {
  const PointValidateScreen({
    super.key,
  });

  @override
  PointValidateScreenState createState() => PointValidateScreenState();
}

class PointValidateScreenState extends State<PointValidateScreen> {
  late final PointRecordController _controller;
  File? _capturedImage;

  @override
  void initState() {
    _controller = Get.find<PointRecordController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Validar ponto',
      body: Builder(builder: (context) {
        if (_capturedImage != null) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.file(
                  _capturedImage!,
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  child: Padding(
                    padding: const EdgeInsets.all(29.0),
                    child: Column(
                      children: [
                        AppButton(
                            text: 'Validar identidade',
                            onPressed: _controller.checkFace(
                                context, _capturedImage!)),
                        const SizedBox(height: 15),
                        AppButton(
                          text: 'Tirar nova foto',
                          onPressed: () =>
                              setState(() => _capturedImage = null),
                          textColor: Colors.red,
                          backgroundColor: AppColorsConst.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return SmartFaceCamera(
            message: 'Camera não detectada',
            autoDisableCaptureControl: true,
            autoCapture: false,
            defaultCameraLens: CameraLens.front,
            onCapture: (File? image) {
              setState(() => _capturedImage = image);
            },
            onFaceDetected: (Face? face) {},
            messageBuilder: (context, face) {
              if (face == null) {
                return _message('Coloque seu rosto na câmera');
              }
              if (!face.wellPositioned) {
                return _message('Centralize seu rosto');
              }
              return const SizedBox.shrink();
            });
      }),
    );
  }

  Widget _message(String msg) => SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
        ),
      );
}
