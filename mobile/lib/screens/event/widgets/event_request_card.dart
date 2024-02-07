import 'package:facelocus/models/event_request_model.dart';
import 'package:facelocus/models/event_request_status_enum.dart';

// Certifique-se de que as importações abaixo estão corretas
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart'; // Verifique se este caminho está correto
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventRequestCard extends StatefulWidget {
  const EventRequestCard(
      {super.key, required this.eventRequest, required this.authenticatedUser});

  final EventRequestModel eventRequest;
  final UserModel authenticatedUser;

  @override
  State<EventRequestCard> createState() => _EventRequestCardState();
}

class _EventRequestCardState extends State<EventRequestCard> {
  @override
  Widget build(BuildContext context) {
    // Corrigido para usar 'initiatorUser' e 'targetUser' adequadamente
    String getBannerText(EventRequestType requestType) {
      bool isInitiator =
          widget.eventRequest.initiatorUser.id == widget.authenticatedUser.id;
      return requestType == EventRequestType.invitation
          ? (isInitiator ? 'Enviada' : 'Recebida')
          : (isInitiator ? 'Recebida' : 'Enviada');
    }

    Color getBannerColor(EventRequestType requestType) {
      bool isInitiator =
          widget.eventRequest.initiatorUser.id == widget.authenticatedUser.id;
      return requestType == EventRequestType.invitation
          ? (isInitiator ? Colors.deepPurple : Colors.green)
          : (isInitiator ? Colors.green : Colors.deepPurple);
    }

    // Garantindo retorno padrão para colorByStatus e descriptionByStatus
    Color colorByStatus(EventRequestStatus? status) {
      switch (status) {
        case EventRequestStatus.approved:
          return Colors.green;
        case EventRequestStatus.pending:
          return Colors.amber;
        case EventRequestStatus.rejected:
          return Colors.red;
        default:
          return Colors.grey; // Valor padrão
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
          return 'Indefinido'; // Valor padrão
      }
    }

    // Ajuste na lógica para mostrar a solicitação do evento
    void showEventRequest() {
      int eventRequestId = widget.eventRequest.id!;
      // Ajuste para definir corretamente o tipo de solicitação
      EventRequestType requestType =
          widget.authenticatedUser.id == widget.eventRequest.initiatorUser.id
              ? EventRequestType.ticketRequest
              : EventRequestType.invitation;
      // Certifique-se de que a serialização para string está correta
      context.push(Uri(
          path: '${AppRoutes.eventRequest}/$eventRequestId',
          queryParameters: {
            'eventrequest': widget.eventRequest.id.toString(),
            'requesttype': requestType.toString()
            // Pode precisar de ajuste para serialização
          }).toString());
    }

    return Builder(builder: (context) {
      // Corrigido para checar corretamente o dono da solicitação
      bool isRequestOwner =
          widget.eventRequest.initiatorUser.id == widget.authenticatedUser.id;
      return GestureDetector(
        onTap: !isRequestOwner &&
                widget.eventRequest.requestStatus == EventRequestStatus.pending
            ? showEventRequest
            : null,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.eventRequest.event.description!.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  // Ajustar lógica conforme necessário para exibir informações corretas
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color:
                              colorByStatus(widget.eventRequest.requestStatus),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                          descriptionByStatus(
                              widget.eventRequest.requestStatus),
                          style: const TextStyle(color: Colors.black54))
                    ],
                  )
                ],
              )),
          Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 4, right: 8, left: 8, bottom: 4),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color:
                            getBannerColor(widget.eventRequest.requestType!)),
                    color: getBannerColor(widget.eventRequest.requestType!)
                        .withOpacity(0.1)),
                child: Text(getBannerText(widget.eventRequest.requestType!),
                    style: TextStyle(
                        color: getBannerColor(widget.eventRequest.requestType!),
                        fontSize: 10,
                        fontWeight: FontWeight.w500)),
              ))
        ]),
      );
    });
  }
}
