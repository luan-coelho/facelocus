import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PointRecordCard extends StatefulWidget {
  const PointRecordCard({
    super.key,
    required this.pointRecord,
    required this.user,
  });

  final PointRecordModel pointRecord;
  final UserModel user;

  @override
  State<PointRecordCard> createState() => _PointRecordCardState();
}

class _PointRecordCardState extends State<PointRecordCard> {
  @override
  Widget build(BuildContext context) {
    String getStartTimeAndEndTime() {
      DateTime startTime = widget.pointRecord.points.first.initialDate;
      DateTime endTime = widget.pointRecord.points.last.finalDate;
      String startTimef = DateFormat('HH:mm').format(startTime);
      String endTimef = DateFormat('HH:mm').format(endTime);
      return '$startTimef - $endTimef';
    }

    bool checkIfItIsProgress() {
      DateTime now = DateTime.now();
      DateTime startTime = widget.pointRecord.points.first.initialDate;
      DateTime endTime = widget.pointRecord.points.last.finalDate;
      return now.isAfter(startTime) && now.isBefore(endTime);
    }

    return GestureDetector(
      onTap: () {
        String url = '${AppRoutes.pointRecord}/${widget.pointRecord.id}';
        if (widget.pointRecord.event!.administrator!.id == widget.user.id) {
          context.push('/admin$url');
          return;
        }
        context.push(url);
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pointRecord.event!.description!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  getStartTimeAndEndTime(),
                  style: const TextStyle(color: Colors.black54),
                ),
                if (checkIfItIsProgress()) ...[
                  Container(
                    padding: const EdgeInsets.only(
                      top: 4,
                      right: 8,
                      left: 8,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(color: Colors.green),
                        color: Colors.green.withOpacity(0.1)),
                    child: const Text(
                      'Em andamento',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
