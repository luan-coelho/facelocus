import 'package:facelocus/providers/ticket_request_provider.dart';
import 'package:facelocus/screens/ticket-request/widgets/ticket_request_card.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/shared/widgets/unexpected_error.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Consumer<TicketRequestProvider>(builder: (context, state, child) {
          if (!state.isLoading && state.ticketsRequest!.isEmpty) {
            const message = 'Nenhuma solicitação no momento';
            return EmptyData(message, child: AppButton(text: 'Adicionar', onPressed: (){
              showForm(context);
            },));
          }

          if(!state.isLoading && state.error != null){
            return UnexpectedError(state.error!);
          }

          return SingleChildScrollView(
            child: Skeletonizer(
              enabled: state.isLoading,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 15, right: 15),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 20);
                },
                physics: const NeverScrollableScrollPhysics(),
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

  void showForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Nova solicitação'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.account_box),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        icon: Icon(Icons.message ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions:  const [
              AppButton(text: 'Solicitar', onPressed: null)
            ],
          );
        });
  }
}
