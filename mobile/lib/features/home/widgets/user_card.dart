import 'package:facelocus/router.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserCardHome extends StatefulWidget {
  const UserCardHome({super.key});

  @override
  State<UserCardHome> createState() => _UserCardHomeState();
}

class _UserCardHomeState extends State<UserCardHome> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<UserFacePhotoBloc, UserFacePhotoState>(
            builder: (context, state) {
          if (state is UserFacePhotoLoaded) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: CircleAvatar(
                      backgroundImage: FileImage(state.image),
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Olá,',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      state.user.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )
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
        }),
      ],
    );
  }
}
