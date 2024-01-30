import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/app_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PointRecordCard extends StatefulWidget {
  const PointRecordCard(
      {super.key, required this.pointRecord, required this.user});

  final PointRecordModel pointRecord;
  final UserModel user;

  @override
  State<PointRecordCard> createState() => _PointRecordCardState();
}

class _PointRecordCardState extends State<PointRecordCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.pointRecord.event!.administrator!.id == widget.user.id) {
          context.push('${AppRoutes.pointRecord}/${widget.pointRecord.id}');
        }
      },
      child: Container(
          padding:
              const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.pointRecord.event!.description!.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(width: widget.pointRecord.inProgress! ? 7 : 0),
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
