import 'package:facelocus/shared/constants.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchAnchor(
            searchController: controller,
            builder: (BuildContext context, SearchController controller) {
              return SizedBox(
                width: double.infinity,
                height: 35,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black12.withOpacity(0.1)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          AppColorsConst.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () {
                    controller.clear();
                    controller.openView();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Selecionar evento',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            },
            viewBackgroundColor: Colors.white,
            headerTextStyle: const TextStyle(color: Colors.black),
            dividerColor: Colors.black,
            viewHintText: 'Pesquisar',
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            }),
        Center(
          child: controller.text.isEmpty
              ? const Text('No item selected')
              : Text('Selected item: ${controller.value.text}'),
        ),
      ],
    );
  }
}
