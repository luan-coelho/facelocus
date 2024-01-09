import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:facelocus/screens/event/widgets/users_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UsersAccordion extends StatefulWidget {
  const UsersAccordion({super.key, required this.eventId});

  final int eventId;

  @override
  State<UsersAccordion> createState() => _UsersAccordionState();
}

class _UsersAccordionState extends State<UsersAccordion> {
  @override
  Widget build(BuildContext context) {
    return Accordion(
      headerBorderColor: Colors.black,
      headerBorderColorOpened: Colors.white,
      headerBackgroundColorOpened: Colors.white,
      headerBackgroundColor: Colors.white,
      contentBackgroundColor: Colors.white,
      contentBorderColor: Colors.white,
      contentBorderWidth: 3,
      contentHorizontalPadding: 20,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerBorderRadius: 5,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: [
        AccordionSection(
          isOpen: true,
          contentVerticalPadding: 20,
          leftIcon: SvgPicture.asset(
            'images/users-icon.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          header: const Row(
            children: [
              Text("Usuários", style: TextStyle(fontWeight: FontWeight.w500))
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [UsersSearch(widget.eventId)],
          ),
        ),
      ],
    );
  }
}
