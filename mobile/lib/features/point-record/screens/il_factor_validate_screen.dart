import 'package:facelocus/features/point-record/blocs/location-factor-validate/location_factor_validate_bloc.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LocationFactorValidateScreen extends StatefulWidget {
  const LocationFactorValidateScreen({
    super.key,
    required this.attendanceRecordId,
  });

  final int attendanceRecordId;

  @override
  State<LocationFactorValidateScreen> createState() =>
      _LocationFactorValidateScreenState();
}

class _LocationFactorValidateScreenState
    extends State<LocationFactorValidateScreen> {
  @override
  void initState() {
    context.read<LocationFactorValidateBloc>().add(LoadUserAttendace(
          userAttendanceId: widget.attendanceRecordId,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          child: BlocConsumer<LocationFactorValidateBloc,
              LocationFactorValidateState>(
            listener: (context, state) {
              if (state is LocationFactorValidateSuccess) {
                context.pop();
              }

              if (state is LocationFactorValidateError) {
                return Toast.showError(state.message, context);
              }
            },
            builder: (context, state) {
              if (state is LocationFactorLoaded) {
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
                      state.userAttendance.pointRecord!.location!.description
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 15),
                    AppButton(
                      onPressed: () => context
                          .read<LocationFactorValidateBloc>()
                          .add(ValidateLocation(
                            userAttendance: state.userAttendance,
                            attendanceRecordId: widget.attendanceRecordId,
                          )),
                      text: 'Validar',
                    ),
                  ],
                );
              }

              if (state is WithinThePermittedRadius) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'images/completing.svg',
                      width: 200,
                    ),
                    const SizedBox(height: 15),
                    const Text('Localização validada com sucesso',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 15),
                    AppButton(
                      onPressed: () => context.pop(),
                      text: 'Fechar',
                    ),
                  ],
                );
              }

              if (state is OutsideThePermittedRadius) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'images/failed.svg',
                      width: 200,
                    ),
                    const SizedBox(height: 25),
                    const Text('Fora do raio permitido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 25),
                    AppButton(
                        onPressed: () => context
                            .read<LocationFactorValidateBloc>()
                            .add(ValidateLocation(
                                userAttendance: state.userAttendance,
                                attendanceRecordId: widget.attendanceRecordId)),
                        text: 'Tentar novamente'),
                  ],
                );
              }

              return const Center(child: Spinner());
            },
          ),
        ),
      ),
    );
  }
}
