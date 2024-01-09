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
    return Column(children: [
      Row(
        children: [
          SvgPicture.asset(
            'images/users-icon.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          const SizedBox(width: 5),
          const Text("Usuários", style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      const SizedBox(height: 10),
      UsersSearch(widget.eventId)
    ]);
  }
}
