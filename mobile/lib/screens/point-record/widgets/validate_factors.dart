import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class ValidateFactors extends StatefulWidget {
  const ValidateFactors({super.key, required this.factors});

  final List<Factor> factors;

  @override
  State<ValidateFactors> createState() => _ValidateFactorsState();
}

class _ValidateFactorsState extends State<ValidateFactors> {
  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      appBarTitle: 'Validar Fatores',
      showBottomNavigationBar: false,
      body: Text('Fatores'),
    );
  }
}
