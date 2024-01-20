import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLayout extends StatelessWidget {
  const AppLayout(
      {super.key,
      this.appBarTitle,
      this.showAppBar,
      required this.body,
      this.floatingActionButton});

  final String? appBarTitle;
  final bool? showAppBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppBar == null
            ? AppBar(
                centerTitle: true,
                backgroundColor: appBarTitle != null
                    ? AppColorsConst.blue
                    : AppColorsConst.white,
                title: appBarTitle != null
                    ? Text(
                        appBarTitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: appBarTitle != null
                                ? Colors.white
                                : Colors.black),
                      )
                    : null,
                leading: Navigator.canPop(context)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'images/chevron-left-icon.svg',
                            colorFilter: ColorFilter.mode(
                                appBarTitle != null
                                    ? Colors.white
                                    : Colors.black,
                                BlendMode.srcIn),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      )
                    : null)
            : null,
        body: body,
        floatingActionButton: floatingActionButton);
  }
}
