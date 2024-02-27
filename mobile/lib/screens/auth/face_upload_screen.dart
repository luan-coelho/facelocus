import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class FaceUploadScreen extends StatefulWidget {
  const FaceUploadScreen({
    super.key,
  });

  @override
  FaceUploadScreenState createState() => FaceUploadScreenState();
}

class FaceUploadScreenState extends State<FaceUploadScreen> {
  late final UserController _controller;
  late final SessionController _authController;
  File? _capturedImage;
  late bool _openCamera;

  @override
  void initState() {
    _controller = Get.find<UserController>();
    _authController = Get.find<SessionController>();
    _openCamera = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Realizar uploud de foto',
      showAppBar: true,
      showBottomNavigationBar: false,
      body: Builder(builder: (context) {
        if (!_openCamera) {
          return Padding(
            padding: const EdgeInsets.all(29.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (context) {
                  double width = MediaQuery.of(context).size.width * 0.50;
                  return Lottie.asset('assets/face_recognition.json',
                      width: width);
                }),
                const SizedBox(height: 15),
                const Text(
                  'Para usar os recursos da aplicação será necessário enviar uma foto do seu rosto',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                AppButton(
                    text: 'Iniciar',
                    onPressed: () {
                      setState(() {
                        _openCamera = true;
                      });
                    }),
                const SizedBox(height: 10),
                AppButton(
                  text: 'Sair',
                  onPressed: () {
                    _authController.logout();
                    context.replace(AppRoutes.login);
                  },
                  textColor: Colors.red,
                  backgroundColor: Colors.white,
                )
              ],
            ),
          );
        }

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
                            onPressed: _controller.facePhotoProfileUploud(
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
            orientation: CameraOrientation.portraitUp,
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
