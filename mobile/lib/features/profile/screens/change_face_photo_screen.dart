import 'dart:io';

import 'package:facelocus/features/profile/blocs/change-face-photo/change_face_photo_bloc.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/info_card.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final ImagePicker _picker;
  File? _capturedImage;

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 100,
    );

    setState(() {
      if (pickedFile != null) {
        croppedFile(pickedFile.path);
      }
    });
  }

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
      context.read<ChangeFacePhotoBloc>().add(CameraPhotoCaptured(
            file: _capturedImage!,
          ));
    });
  }

  @override
  void initState() {
    _picker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void getPhotoFromGalery() async {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
          // context.read<FaceUploudBloc>().add(PhotoCaptured(image.path));
        });
        croppedFile(image.path);
      }
    }

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: BlocConsumer<ChangeFacePhotoBloc, ChangeFacePhotoState>(
          listener: (context, state) {
            if (state is UploadedSucessfully) {
              context.pop();
              return Toast.showSuccess('Foto alterada com sucesso', context);
            }

            if (state is UploadedFailed) {
              return Toast.showError(state.message, context);
            }

            if (state is Cancellation) {
              context.pop();
            }
          },
          builder: (context, state) {
            if (state is Uploading) {
              return const Center(
                child: Spinner(),
              );
            }

            if (state is CapturePhotoByGallery) {
              getPhotoFromGalery();
            }

            if (state is CameraPhotoCapturedSuccessfully) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: FileImage(File(_capturedImage!.path)),
                      radius: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(29.0),
                      child: Column(
                        children: [
                          AppButton(
                            isLoading: state is Uploading,
                            text: 'Enviar',
                            onPressed: () =>
                                context.read<ChangeFacePhotoBloc>().add(
                                      UploudPhoto(file: _capturedImage!),
                                    ),
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            text: 'Tirar nova foto',
                            onPressed: _takePhoto,
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            borderColor: Colors.black.withOpacity(0.5),
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            text: 'Voltar',
                            onPressed: () => context
                                .read<ChangeFacePhotoBloc>()
                                .add(CancelCapture()),
                            textColor: Colors.red,
                            backgroundColor: Colors.red.withOpacity(0.2),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is GaleryPhotoCapturedSuccessfully) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: FileImage(File(_capturedImage!.path)),
                      radius: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(29.0),
                      child: Column(
                        children: [
                          AppButton(
                            isLoading: state is Uploading,
                            text: 'Enviar',
                            onPressed: () =>
                                context.read<ChangeFacePhotoBloc>().add(
                                      UploudPhoto(file: _capturedImage!),
                                    ),
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            text: 'Selecionar uma nova foto',
                            onPressed: () => context
                                .read<ChangeFacePhotoBloc>()
                                .add(RequestCaptureByGallery()),
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                            borderColor: Colors.black.withOpacity(0.5),
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            text: 'Cancelar',
                            onPressed: () => context
                                .read<ChangeFacePhotoBloc>()
                                .add(CancelCapture()),
                            textColor: Colors.red,
                            backgroundColor: Colors.red.withOpacity(0.2),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

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
                  const InforCard(
                    'Por questões de segurança, ao alterar sua foto de perfil, '
                    'você será removido de todos os eventos que participa.',
                  ),
                  const SizedBox(height: 15),
                  AppButton(
                    text: 'Tirar uma foto',
                    onPressed: _takePhoto,
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    text: 'Galeria',
                    onPressed: getPhotoFromGalery,
                    backgroundColor: AppColorsConst.purple,
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    text: 'Cancelar',
                    onPressed: () {
                      context
                          .read<ChangeFacePhotoBloc>()
                          .add(RequestCancellation());
                    },
                    textColor: Colors.red,
                    backgroundColor: Colors.red.withOpacity(0.2),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
