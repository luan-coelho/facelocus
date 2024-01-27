import 'package:facelocus/shared/widgets/app_search_field.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';

class AppSearch extends StatefulWidget {
  const AppSearch({super.key});

  @override
  State<AppSearch> createState() => _AppSearchState();
}

class _AppSearchState extends State<AppSearch> {
  final _debouncer = Debouncer();
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Center(
          child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 20),
              child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: TextField(
                    controller: _textEditingController,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: InkWell(
                          child: true
                              ? GestureDetector(
                                  onTap: _textEditingController.clear,
                                  child: const Icon(Icons.close))
                              // ignore: dead_code
                              : const UnconstrainedBox(
                                  child: SizedBox(
                                      width: 17,
                                      height: 17,
                                      child: CircularProgressIndicator(
                                          color: Colors.black)),
                                ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        hintText: 'Pesquisar',
                        helperStyle: const TextStyle(fontSize: 14),
                        hintStyle: const TextStyle(fontSize: 14)),
                    onChanged: (string) {
                      _debouncer.run(() {});
                    },
                  ))),
        ),
      ),
      body: const Center(
        child:
            SingleChildScrollView(child: EmptyData('Ainda não há nada aqui')),
      ),
    );
  }
}
