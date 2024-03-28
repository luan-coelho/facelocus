import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({
    super.key,
    this.appBarTitle,
    bool this.showAppBar = true,
    this.actions,
    this.leading,
    this.showBottomNavigationBar = true,
    required this.body,
    this.bodyBackgroundColor,
    this.floatingActionButton,
  });

  final String? appBarTitle;
  final bool? showAppBar;
  final List<Widget>? actions;

  final Widget? leading;
  final bool? showBottomNavigationBar;

  final Widget body;
  final Color? bodyBackgroundColor;
  final Widget? floatingActionButton;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.showAppBar != null && widget.showAppBar == true
            ? AppBar(
                leading: widget.leading,
                centerTitle: true,
                actions: widget.actions,
                backgroundColor: widget.appBarTitle != null
                    ? AppColorsConst.dark
                    : AppColorsConst.white,
                title: widget.appBarTitle != null
                    ? Text(
                        widget.appBarTitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.appBarTitle != null
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    : null,
              )
            : null,
        body: widget.body,
        backgroundColor: widget.bodyBackgroundColor,
        resizeToAvoidBottomInset: false,
        floatingActionButton: widget.showBottomNavigationBar != null &&
                widget.showBottomNavigationBar == true
            ? FloatingActionButton(
                onPressed: () => context.push(AppRoutes.pointRecordCreate),
                elevation: 13,
                backgroundColor: AppColorsConst.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: widget.showBottomNavigationBar != null &&
                widget.showBottomNavigationBar == true
            ? const AppBottomNavigationBar()
            : null,
      ),
    );
  }
}
