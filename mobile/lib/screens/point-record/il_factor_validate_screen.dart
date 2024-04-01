import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/controllers/validate_point_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mac_address/mac_address.dart';

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

  @override
  void initState() {
    _validatePointController = Get.find<ValidatePointController>();
    _pointRecordController = Get.find<PointRecordShowController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void getDeviceInfo() async {
      // String? identifier = await _validatePointController.getDeviceIdentifier();
      var identifier = await GetMac.macAddress;
      debugPrint('Identificador - $identifier');
    }

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
        child: RefreshIndicator(
          onRefresh: () => FlutterBluePlus.startScan(
            timeout: const Duration(seconds: 4),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map(
                          (r) => ListTile(
                            title: Text(r.device.platformName),
                            subtitle: Text(r.rssi.toString()),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.stopScan(),
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.startScan(
                timeout: const Duration(seconds: 4),
              ),
              child: const Icon(Icons.search),
            );
          }
        },
      ),
    );
  }
}
