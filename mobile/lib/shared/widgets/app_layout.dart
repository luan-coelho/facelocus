import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatefulWidget {
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
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        {
          context.go(AppRoutes.home);
          break;
        }
      case 1:
        {
          context.go(AppRoutes.event);
          break;
        }
      case 2:
        {
          context.go(AppRoutes.eventTicketsRequest);
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.showAppBar == null
            ? AppBar(
                centerTitle: true,
                backgroundColor: widget.appBarTitle != null
                    ? AppColorsConst.blue
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
                    : null,
                leading: Navigator.canPop(context)
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'images/chevron-left-icon.svg',
                            colorFilter: ColorFilter.mode(
                                widget.appBarTitle != null
                                    ? Colors.white
                                    : Colors.black,
                                BlendMode.srcIn),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      )
                    : null)
            : null,
        body: widget.body,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColorsConst.blue,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'images/home-icon.svg',
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'images/event-icon.svg',
              ),
              label: 'Eventos',
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'images/ticket-request-icon.svg',
                ),
                label: 'Solicitações',
                backgroundColor: Colors.white),
          ],
          currentIndex: _selectedIndex,
          selectedIconTheme: const IconThemeData(color: Colors.green),
          selectedItemColor: Colors.amber[800],
          selectedLabelStyle: const TextStyle(color: Colors.white),
          onTap: _onItemTapped,
        ),
        floatingActionButton: widget.floatingActionButton);
  }
}
