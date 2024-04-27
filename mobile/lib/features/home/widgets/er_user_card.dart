import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/er-user-face-photo/er_user_face_photo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ErUserCard extends StatefulWidget {
  const ErUserCard({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  State<ErUserCard> createState() => _ErUserCardState();
}

class _ErUserCardState extends State<ErUserCard> {
  @override
  void initState() {
    context.read<ErUserFacePhotoBloc>().add(
          LoadErUserFacePhoto(user: widget.user),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErUserFacePhotoBloc, ErUserFacePhotoState>(
      builder: (context, state) {
        if (state is ErUserFacePhotoLoaded) {
          return Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CircleAvatar(
              backgroundImage: FileImage(
                state.image,
              ),
              radius: 25,
            ),
          );
        }

        if (state is ErUserFacePhotoError) {
          return Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }

        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: const Skeletonizer.zone(
            child: Bone.circle(size: 200),
          ),
        );
      },
    );
  }
}
