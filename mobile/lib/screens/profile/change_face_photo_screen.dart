import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ChangeFacePhotoScreen extends StatefulWidget {
  const ChangeFacePhotoScreen({
    super.key,
  });

  @override
  ChangeFacePhotoScreenState createState() => ChangeFacePhotoScreenState();
}

class ChangeFacePhotoScreenState extends State<ChangeFacePhotoScreen> {
  late final ImagePicker picker;
  File? _capturedImage;
  late bool _openCamera;

  @override
  void initState() {
    picker = ImagePicker();
    _openCamera = false;
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

    void getPhotoFromGalery() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
        });
        croppedFile(image.path);
      }
    }

    Widget getBody() {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => {
              if (_openCamera || _capturedImage != null)
                {
                  setState(
                    () {
                      _capturedImage = null;
                      _openCamera = false;
                    },
                  )
                }
              else
                context.pop()
            },
            icon: const Icon(Icons.close, color: Colors.black, size: 30),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
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
                  },
                )
              ] else ...[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.7,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      opacity: 0.6,
                      image: NetworkImage(
                          'https://img.freepik.com/premium-photo/abstract-connected-dots-lines-blue-background_34629-424.jpg'),
                    ),
                  ),
                  child: Builder(builder: (context) {
                    double width = MediaQuery.of(context).size.width * 0.60;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 15),
                        Lottie.asset(
                          'assets/face_recognition.json',
                          width: width,
                        ),
                      ],
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(29.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Alterar foto de perfil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const InforCard(
                        'Ao alterar sua foto, você será automaticamente removido de todos os eventos.',
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                          text: 'Tirar uma foto',
                          onPressed: () {
                            setState(() {
                              _openCamera = true;
                            });
                          }),
                      const SizedBox(height: 10),
                      AppButton(
                        text: 'Galeria',
                        onPressed: getPhotoFromGalery,
                        backgroundColor: AppColorsConst.purple,
                      ),
                    ],
                  ),
                )
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
                            AppButton(
                              text: 'Enviar',
                              /*onPressed: () {
                                _controller.facePhotoProfileUploud(
                                  context,
                                  _capturedImage!,
                                );
                              },*/
                            ),
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
      );
    }

    if (_openCamera) {
      return getBody();
    }
    return SafeArea(
      child: getBody(),
    );
  }
}
