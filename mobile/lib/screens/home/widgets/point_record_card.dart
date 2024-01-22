import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/utils/app_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PointRecordCard extends StatefulWidget {
  const PointRecordCard({super.key, required this.pointRecord});

  final PointRecordModel pointRecord;

  @override
  State<PointRecordCard> createState() => _TicketRequestCardState();
}

enum TicketRequestType { received, sent }

class _TicketRequestCardState extends State<PointRecordCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 1.5),
                ),
              ],
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.pointRecord.event!.description!.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5),
              Row(
                children: [
                  widget.pointRecord.inProgress!
                      ? Container(
                          width: 15.0,
                          height: 15.0,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(width: widget.pointRecord.inProgress! ? 5 : 0),
                  Builder(builder: (context) {
                    DateTime date = widget.pointRecord.date;
                    String datef = DateFormat('dd/MM/yyyy').format(date);
                    return Text(
                        widget.pointRecord.inProgress!
                            ? 'Em andamento'
                            : '${AppDateUtils.getDayOfWeek(date)} - $datef',
                        style: const TextStyle(color: Colors.black54));
                  })
                ],
              )
            ],
          )),
    );
  }
}
