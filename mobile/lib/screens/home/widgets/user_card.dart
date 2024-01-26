import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:facelocus/controllers/auth_controller.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class UserCardHome extends StatefulWidget {
  const UserCardHome({super.key});

  @override
  State<UserCardHome> createState() => _UserCardHomeState();
}

class _UserCardHomeState extends State<UserCardHome> {
  late final AuthController _authController;
  late final UserModel _user;
  late final Map<String, String> _httpHeaders;
  bool _isLoading = true;

  @override
  void initState() {
    _authController = Get.find<AuthController>();
    _user = _authController.authenticatedUser.value!;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? token = await DioFetchApi().getToken();
      _httpHeaders = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      };
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seja bem-vindo',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Luan",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.7)),
                    shape: BoxShape.circle),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.profile),
                      child: Builder(builder: (context) {
                        String api = AppConfigConst.baseApiUrl;
                        String route = AppRoutes.user;
                        var url = '$api$route/face-photo?user=${_user.id}';
                        return CachedNetworkImage(
                          width: 100,
                          imageUrl: url,
                          httpHeaders: _httpHeaders,
                          placeholder: (context, url) => const CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 150,
                          ),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundImage: image,
                            radius: 150,
                          ),
                        );
                      }),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      );
    });
  }
}
