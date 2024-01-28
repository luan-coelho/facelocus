import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatefulWidget {
  const AppLayout(
      {super.key,
      this.appBarTitle,
      bool this.showAppBar = true,
      this.showBottomNavigationBar = true,
      required this.body,
      this.floatingActionButton,
      this.onPressLeading});

  final String? appBarTitle;
  final bool? showAppBar;
  final bool? showBottomNavigationBar;
  final Widget body;
  final Widget? floatingActionButton;
  final void Function()? onPressLeading;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar != null && widget.showAppBar == true
          ? AppBar(
              centerTitle: true,
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
                              : Colors.black),
                    )
                  : null)
          : null,
      body: widget.body,
      resizeToAvoidBottomInset: false,
      floatingActionButton: widget.showBottomNavigationBar != null &&
              widget.showBottomNavigationBar == true
          ? FloatingActionButton(
              onPressed: () => context.replace(AppRoutes.pointRecordCreate),
              elevation: 13,
              backgroundColor: AppColorsConst.blue,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: widget.showBottomNavigationBar != null &&
              widget.showBottomNavigationBar == true
          ? BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              color: AppColorsConst.dark,
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'images/home-icon.svg',
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onPressed: () => context.replace(AppRoutes.home),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'images/event-icon.svg',
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    onPressed: () => context.replace(AppRoutes.event),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
