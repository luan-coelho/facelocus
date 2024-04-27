import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserFaceImage extends StatefulWidget {
  const UserFaceImage({super.key});

  @override
  State<UserFaceImage> createState() => _UserFaceImageState();
}

class _UserFaceImageState extends State<UserFaceImage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFacePhotoBloc, UserFacePhotoState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Builder(
              builder: (context) {
                if (state is UserFacePhotoLoaded) {
                  return Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: FileImage(
                            state.image,
                          ),
                          radius: 100,
                        ),
                      ),
                    ],
                  );
                }

                if (state is UserFacePhotoError) {
                  return Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.profile),
                          child: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 25,
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: const Skeletonizer.zone(
                    child: Bone.circle(size: 48),
                  ),
                );
              },
            ),
            Positioned(
              right: 30,
              bottom: -2,
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.changeFacePhoto),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColorsConst.blue,
                    border: Border.all(color: Colors.white, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
