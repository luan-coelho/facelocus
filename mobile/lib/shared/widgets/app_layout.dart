import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLayout extends StatelessWidget {
  const AppLayout(
      {super.key,
      required this.appBarTitle,
      required this.body,
      this.floatingActionButton});

  final String appBarTitle;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColorsConst.blue,
            title: Text(
              appBarTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: SvgPicture.asset(
                      'images/chevron-left-icon.svg',
                      width: 30,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null),
        body: body,
        floatingActionButton: floatingActionButton);
  }
}
