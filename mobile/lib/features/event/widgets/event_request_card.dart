import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_status_enum.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventRequestCard extends StatefulWidget {
  const EventRequestCard({
    super.key,
    required this.eventRequest,
    required this.authenticatedUser,
  });

  final EventRequestModel eventRequest;
  final UserModel authenticatedUser;

  @override
  State<EventRequestCard> createState() => _EventRequestCardState();
}

class _EventRequestCardState extends State<EventRequestCard> {
  @override
  Widget build(BuildContext context) {
    String getBannerText(EventRequestType requestType) {
      return requestType == EventRequestType.invitation
          ? 'Convite'
          : 'Solicitação';
    }

    String getSecondaryBannerText(EventRequestType requestType) {
      bool isInitiator =
          widget.eventRequest.initiatorUser.id == widget.authenticatedUser.id;
      return isInitiator ? 'Enviado' : 'Recebido';
    }

    Color getBannerColor(EventRequestType requestType) {
      return requestType == EventRequestType.invitation
          ? Colors.green
          : Colors.deepPurple;
    }

    Color colorByStatus(EventRequestStatus? status) {
      switch (status) {
        case EventRequestStatus.approved:
          return Colors.green;
        case EventRequestStatus.pending:
          return Colors.amber;
        case EventRequestStatus.rejected:
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    String descriptionByStatus(EventRequestStatus? status) {
      switch (status) {
        case EventRequestStatus.approved:
          return 'Aprovada';
        case EventRequestStatus.pending:
          return 'Pendente';
        case EventRequestStatus.rejected:
          return 'Rejeitada';
        default:
          return 'Indefinido';
      }
    }

    void showEventRequest() {
      int eventRequestId = widget.eventRequest.id!;
      EventRequestType requestType = widget.eventRequest.type!;
      context.push(Uri(
          path: '${AppRoutes.eventRequest}/$eventRequestId',
          queryParameters: {
            'eventrequest': widget.eventRequest.id.toString(),
            'event': widget.eventRequest.event.id.toString(),
            'requesttype': EventRequestType.toJson(requestType)
          }).toString());
    }

    return Builder(
      builder: (context) {
        bool isRequestOwner =
            widget.eventRequest.initiatorUser.id == widget.authenticatedUser.id;
        return GestureDetector(
          onTap: !isRequestOwner &&
                  widget.eventRequest.status == EventRequestStatus.pending
              ? showEventRequest
              : null,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventRequest.event.description!.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.eventRequest.initiatorUser.id ==
                                widget.authenticatedUser.id
                            ? 'Para:'
                            : 'De:',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.eventRequest.initiatorUser.id ==
                              widget.authenticatedUser.id
                          ? widget.eventRequest.targetUser
                              .getFullName()
                              .toUpperCase()
                          : widget.eventRequest.initiatorUser
                              .getFullName()
                              .toUpperCase(),
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: colorByStatus(widget.eventRequest.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        descriptionByStatus(widget.eventRequest.status),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                            border: Border.all(
                              color: getBannerColor(
                                widget.eventRequest.type!,
                              ),
                            ),
                            color: getBannerColor(
                              widget.eventRequest.type!,
                            ).withOpacity(0.1),
                          ),
                          child: Text(
                            getSecondaryBannerText(
                              widget.eventRequest.type!,
                            ),
                            style: TextStyle(
                              color: getBannerColor(
                                widget.eventRequest.type!,
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
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
                            border: Border.all(
                              color: getBannerColor(
                                widget.eventRequest.type!,
                              ),
                            ),
                            color: getBannerColor(
                              widget.eventRequest.type!,
                            ).withOpacity(0.1),
                          ),
                          child: Text(
                            getBannerText(
                              widget.eventRequest.type!,
                            ),
                            style: TextStyle(
                              color: getBannerColor(widget.eventRequest.type!),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
