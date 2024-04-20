import 'package:facelocus/controllers/location_controller.dart';
import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/controllers/validate_point_controller.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ILFactorValidateScreen extends StatefulWidget {
  const ILFactorValidateScreen({
    super.key,
    required this.attendanceRecordId,
  });

  final int attendanceRecordId;

  @override
  State<ILFactorValidateScreen> createState() => _ILFactorValidateScreenState();
}

class _ILFactorValidateScreenState extends State<ILFactorValidateScreen> {
  late final ValidatePointController _validatePointController;
  late final PointRecordShowController _pointRecordController;
  late final LocationController _locationController;

  @override
  void initState() {
    _validatePointController = Get.find<ValidatePointController>();
    _pointRecordController = Get.find<PointRecordShowController>();
    _locationController = Get.find<LocationController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pointRecordController.fetchUserAttendanceById(
        context,
        widget.attendanceRecordId,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Obx(() {
          if (_pointRecordController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/location.svg',
                width: 300,
              ),
              const SizedBox(height: 25),
              const Text('Local de validação',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(
                width: 15,
              ),
              Text(
                  _pointRecordController
                      .pointRecord.value!.location!.description
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  )),
              const SizedBox(height: 15),
              AppButton(
                isLoading: _validatePointController.buttonLoading.value,
                onPressed: () => _validatePointController.validateLocation(
                  context,
                ),
                text: 'Validar',
              ),
            ],
          );
        }),
      ),
    );
  }
}
