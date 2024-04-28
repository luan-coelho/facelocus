import 'package:flutter/material.dart';

class InforCard extends StatelessWidget {
  const InforCard(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        right: 20,
        left: 20,
        bottom: 15,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.blue,
            size: 32,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontWeight: FontWeight.w400),
                children: [
                  const WidgetSpan(child: SizedBox(width: 40.0)),
                  TextSpan(text: text),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
