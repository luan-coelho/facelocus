import 'package:facelocus/providers/ticket_request_provider.dart';
import 'package:facelocus/screens/ticket-request/widgets/ticket_request_card.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TicketRequestScreen extends StatefulWidget {
  const TicketRequestScreen({super.key});

  @override
  State<TicketRequestScreen> createState() => _TicketRequestScreenState();
}

class _TicketRequestScreenState extends State<TicketRequestScreen> {
  late TicketRequestProvider _ticketRequestProvider;

  @override
  void initState() {
    _ticketRequestProvider =
        Provider.of<TicketRequestProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ticketRequestProvider.fetchAllByUser(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Solicitações',
      body: SingleChildScrollView(
        child: Consumer<TicketRequestProvider>(builder: (context, state, child) {
          if (!state.isLoading && state.ticketsRequest!.isEmpty) {
            const message = 'Não existe nenhuma solicitação vinculada a você';
            return const EmptyData(message);
          }
        
          return Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Skeletonizer(
              enabled: state.isLoading,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 15, right: 15),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 20);
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.ticketsRequest!.length,
                itemBuilder: (context, index) {
                  var ticketsRequest = state.ticketsRequest![index];
                  return TicketRequestCard(ticketRequest: ticketsRequest);
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
