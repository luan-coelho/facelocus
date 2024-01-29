import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LinckedUserCard extends StatelessWidget {
  final UserModel user;

  const LinckedUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          width: double.infinity,
          height: 45,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/user-icon.svg',
                colorFilter: const ColorFilter.mode(
                    AppColorsConst.black, BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(user.getFullName(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis)),
              )
            ],
          )),
    );
  }
}
