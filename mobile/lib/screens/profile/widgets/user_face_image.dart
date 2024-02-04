import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserFaceImage extends StatefulWidget {
  const UserFaceImage({super.key});

  @override
  State<UserFaceImage> createState() => _UserFaceImageState();
}

class _UserFaceImageState extends State<UserFaceImage> {
  late final SessionController _authController;
  late final UserModel _user;
  late final Map<String, String> _httpHeaders;

  @override
  void initState() {
    _authController = Get.find<SessionController>();
    _user = _authController.authenticatedUser.value!;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? token = await DioFetchApi().getToken();
      _httpHeaders = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Builder(builder: (context) {
            String api = AppConfigConst.baseApiUrl;
            String route = AppRoutes.user;
            var url = '$api$route/face-photo?user=${_user.id}';
            return CachedNetworkImage(
              imageUrl: url,
              httpHeaders: _httpHeaders,
              placeholder: (context, url) => const CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 100,
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 100,
              ),
              errorWidget: (context, url, error) {
                return SvgPicture.asset(
                  'images/user-icon.svg',
                  width: 25,
                );
              },
            );
          }),
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
