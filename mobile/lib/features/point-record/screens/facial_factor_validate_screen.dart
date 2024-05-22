import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:facelocus/features/point-record/blocs/facial-factor-validate/facial_factor_validate_bloc.dart';
import 'package:facelocus/features/point-record/blocs/point-record-show/point_record_show_bloc.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class FacialFactorValidateScreen extends StatefulWidget {
  const FacialFactorValidateScreen({
    super.key,
    required this.attendanceRecordId,
  });

  final int attendanceRecordId;

  @override
  State<FacialFactorValidateScreen> createState() =>
      _FacialFactorValidateScreenState();
}

class _FacialFactorValidateScreenState
    extends State<FacialFactorValidateScreen> {
  late final ImagePicker picker;
  File? _capturedImage;

  @override
  void initState() {
    picker = ImagePicker();
    _capturedImage = null;
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
              color: Colors.red,
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
        _capturedImage = File(croppedFile!.path);
        context.read<FacialFactorValidateBloc>().add(PhotoCaptured(
              image: _capturedImage!,
            ));
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.read<FacialFactorValidateBloc>().add(ResetCapture());
            context.pop();
          },
          icon: const Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<FacialFactorValidateBloc, FacialFactorValidateState>(
        listener: (context, state) {
          if (state is ValidateFaceSuccess) {
            context.pop();
            context.pop();
            return Toast.showSuccess('Ponto validado com sucesso', context);
          }

          if (state is ValidateFaceError) {
            context.pop();
            return Toast.showError(state.message, context);
          }
        },
        builder: (context, state) {
          if (state is ValidateFaceLoading) {
            return const Center(
              child: Spinner(),
            );
          }

          if (state is PhotoCapturedSuccess) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(29.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Validar fator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.file(
                          _capturedImage!,
                          width: MediaQuery.of(context).size.width * 1,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Column(
                        children: [
                          BlocBuilder<PointRecordShowBloc,
                              PointRecordShowState>(
                            builder: (context, state) {
                              return AppButton(
                                text: 'Enviar',
                                onPressed: () {
                                  context.read<FacialFactorValidateBloc>().add(
                                        ValidateFace(
                                          image: _capturedImage!,
                                          attendanceRecordId:
                                              widget.attendanceRecordId,
                                          pointRecordId:
                                              (state as PointRecordShowLoaded)
                                                  .pointRecord
                                                  .id!,
                                        ),
                                      );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            text: 'Tirar nova foto',
                            onPressed: () => setState(() {
                              context.read<FacialFactorValidateBloc>().add(
                                    ResetCapture(),
                                  );
                              _capturedImage = null;
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
            );
          }

          return SmartFaceCamera(
            message: 'Camera não detectada',
            autoDisableCaptureControl: true,
            autoCapture: false,
            defaultCameraLens: CameraLens.front,
            orientation: CameraOrientation.portraitUp,
            imageResolution: ImageResolution.max,
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
          );
        },
      ),
    );
  }
}
