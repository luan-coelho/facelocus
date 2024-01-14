import 'package:facelocus/models/user_model.dart';

class EventTicketRequestCreate {
  int? id;
  UserModel user;
  String? code;

  EventTicketRequestCreate({this.id, required this.user, this.code});

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'user': user.toJson(),
      };
}
