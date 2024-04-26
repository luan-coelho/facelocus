import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/features/auth/blocs/face-uploud/face_uploud_bloc.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class FaceUploadScreen extends StatefulWidget {
  const FaceUploadScreen({
    super.key,
  });

  @override
  FaceUploadScreenState createState() => FaceUploadScreenState();
}

class FaceUploadScreenState extends State<FaceUploadScreen> {
  late final SessionRepository _sessionRepository;
  late final ImagePicker picker;
  File? _capturedImage;
  late bool _openCamera;

  @override
  void initState() {
    _sessionRepository = SessionRepository();
    picker = ImagePicker();
    _openCamera = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<FaceUploudBloc, FaceUploudState>(
        listener: (context, state) {
          if (state is UploadedSucessfully) {
            context.go(AppRoutes.home);
          }

          if (state is UploadedFailed) {
            Toast.showError(state.message, context);
          }
        },
        builder: (context, state) {
          if (!_openCamera) {
            return Padding(
              padding: const EdgeInsets.all(29.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      double width = MediaQuery.of(context).size.width * 0.50;
                      return Lottie.asset(
                        'assets/face_recognition.json',
                        width: width,
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Para usar os recursos da aplicação será necessário enviar uma foto do seu rosto',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 10),
                  AppButton(
                    text: 'Sair',
                    onPressed: () {
                      _sessionRepository.logout();
                      context.replace(AppRoutes.login);
                    },
                    textColor: Colors.red,
                    backgroundColor: Colors.red.withOpacity(0.2),
                  )
                ],
              ),
            );
          }

          if (_capturedImage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.file(
                    _capturedImage!,
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(29.0),
                    child: Column(
                      children: [
                        AppButton(
                          isLoading: state is Uploading,
                          text: 'Enviar',
                          onPressed: () => context.read<FaceUploudBloc>().add(
                                UploudPhoto(_capturedImage!.path),
                              ),
                        ),
                        const SizedBox(height: 10),
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
              setState(() => croppedFile(image!.path));
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
            },
          );
        },
      ),
    );
  }

  Widget _message(String msg) => SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
}
