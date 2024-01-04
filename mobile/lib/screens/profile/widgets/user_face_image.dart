import 'package:flutter/material.dart';

class UserFaceImage extends StatelessWidget {
  const UserFaceImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              shape: BoxShape.circle),
          child: const CircleAvatar(
            radius: 100.0,
            backgroundImage: AssetImage("images/man-face.jpg"),
          ),
        ),
        Positioned(
          right: 30,
          bottom: 5,
          child: GestureDetector(
            onTap: () => {},
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle),
              child: const Icon(
                Icons.edit,
                size: 25.0,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
