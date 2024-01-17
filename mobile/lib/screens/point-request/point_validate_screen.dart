import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class PointValidateScreen extends StatefulWidget {
  const PointValidateScreen({
    super.key,
  });

  @override
  PointValidateScreenState createState() => PointValidateScreenState();
}

class PointValidateScreenState extends State<PointValidateScreen> {
  File? _capturedImage;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Validar ponto',
      body: Builder(builder: (context) {
        if (_capturedImage != null) {
          return Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.file(
                  _capturedImage!,
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                ),
                ElevatedButton(
                    onPressed: () => setState(() => _capturedImage = null),
                    child: const Text(
                      'Capturar de novo',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ))
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
