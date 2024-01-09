import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';

class UserFaceImage extends StatelessWidget {
  const UserFaceImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle),
          child: const CircleAvatar(
            radius: 100.0,
            backgroundImage: AssetImage("images/man-face.jpg"),
          ),
        ),
        Positioned(
          right: 30,
          bottom: -2,
          child: GestureDetector(
            onTap: () => {},
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: AppColorsConst.blue,
                  border: Border.all(color: Colors.white, width: 3),
                  shape: BoxShape.circle),
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
  }
}
