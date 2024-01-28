class EventWithCodeDTO {
  int? id;
  String? code;

  EventWithCodeDTO({this.id, this.code});

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
      };
}
