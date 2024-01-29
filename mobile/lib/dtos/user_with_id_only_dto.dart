class UserWithIdOnly {
  final int? id;

  UserWithIdOnly({
    this.id,
  });

  Map<String, dynamic> toJson() => {'id': id};
}
