import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AppDatePicker extends StatefulWidget {
  const AppDatePicker(
      {super.key,
      this.text,
      this.value,
      required this.onDateSelected,
      this.onChanged});

  final String? text;
  final DateTime? value;
  final Function(DateTime) onDateSelected;
  final Function(DateTime dateTime)? onChanged;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        if (widget.onChanged != null) {
          widget.onChanged!(picked);
        }
      });
      widget.onDateSelected(picked);
    }
  }

  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(
      _selectedDate ?? (widget.value ?? DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.black12.withOpacity(0.1),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            AppColorsConst.black,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () => _selectDate(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/calendar-icon.svg',
              colorFilter: const ColorFilter.mode(
                AppColorsConst.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              getFormattedDate(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
