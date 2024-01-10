import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/providers/user_provider.dart';
import 'package:facelocus/screens/event/widgets/user_card.dart';
import 'package:facelocus/screens/event/widgets/users_search.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LinckedUsersScreen extends StatefulWidget {
  const LinckedUsersScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LinckedUsersScreen> createState() => _LinckedUsersScreenState();
}

class _LinckedUsersScreenState extends State<LinckedUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Usuários vinculados',
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Column(children: [
          Row(
            children: [
              SvgPicture.asset(
                'images/users-icon.svg',
                width: 20,
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              const SizedBox(width: 5),
              const Text('Usuários',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
        Consumer<UserProvider>(builder: (context, state, child) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.users.isEmpty) {
              return const Center(
                child: Text(
                  'Ainda não há nenhuma localização',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Usuários cadastrados',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    UserModel user = state.users[index];
                    return UserCard(user: user);
                  },
                ),
              ],
            );
          })
        ]),
      ),
    );
  }
}
