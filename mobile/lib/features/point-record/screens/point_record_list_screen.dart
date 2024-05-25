import 'package:facelocus/router.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PointRecordListScreen extends StatefulWidget {
  const PointRecordListScreen({super.key});

  @override
  State<PointRecordListScreen> createState() => _PointRecordListScreenState();
}

class _PointRecordListScreenState extends State<PointRecordListScreen> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Center(
          child: AppButton(
              text: 'Validar',
              onPressed: () => context.push(
                    AppRoutes.pointRecordPointValidate,
                  )),
        ),
      ),
    );
  }
}
