import 'package:flutter/material.dart';

class PRUserCard extends StatefulWidget {
  const PRUserCard({super.key});

  @override
  State<PRUserCard> createState() => _PRUserCardState();
}

class _PRUserCardState extends State<PRUserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      width: double.infinity,
      height: 45,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Teste',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
