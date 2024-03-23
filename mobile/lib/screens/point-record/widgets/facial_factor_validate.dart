import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class FacialFactorValidateScreen extends StatefulWidget {
  const FacialFactorValidateScreen({super.key});

  @override
  State<FacialFactorValidateScreen> createState() =>
      _FacialFactorValidateScreenState();
}

class _FacialFactorValidateScreenState
    extends State<FacialFactorValidateScreen> {
  late final ImagePicker picker;
  File? _capturedImage;
  late bool _openCamera;

  @override
  void initState() {
    picker = ImagePicker();
    _openCamera = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget message(String msg) => Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

    void croppedFile(String path) async {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Selecionar',
              toolbarColor: AppColorsConst.dark,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      setState(() {
        _openCamera = false;
        _capturedImage = File(croppedFile!.path);
      });
    }

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => {
              if (_openCamera || _capturedImage != null)
                {
                  setState(() {
                    _capturedImage = null;
                    _openCamera = false;
                  })
                }
              else
                {context.pop()}
            },
            icon: const Icon(Icons.close, color: Colors.black, size: 30),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_capturedImage == null) ...[
                if (_openCamera) ...[
                  SmartFaceCamera(
                      message: 'Camera não detectada',
                      autoDisableCaptureControl: true,
                      autoCapture: false,
                      defaultCameraLens: CameraLens.front,
                      orientation: CameraOrientation.portraitUp,
                      onCapture: (File? image) {
                        setState(() => croppedFile(image!.path));
                      },
                      messageBuilder: (context, face) {
                        if (face == null) {
                          return message('Coloque seu rosto na câmera');
                        }
                        if (!face.wellPositioned) {
                          return message('Centralize seu rosto');
                        }
                        return const SizedBox.shrink();
                      })
                ],
              ] else ...[
                SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(29.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.file(
                              _capturedImage!,
                              width: MediaQuery.of(context).size.width * 1,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              const AppButton(text: 'Enviar', onPressed: null),
                              const SizedBox(height: 10),
                              AppButton(
                                text: 'Tirar nova foto',
                                onPressed: () => setState(() {
                                  _capturedImage = null;
                                  _openCamera = true;
                                }),
                                textColor: Colors.red,
                                backgroundColor: Colors.red.withOpacity(0.2),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
