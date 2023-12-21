class Device {
  late int id;
  late String bluetoothIdentifier;
  late String imei;
  late String description;

  Device({
    required this.id,
    required this.bluetoothIdentifier,
    required this.imei,
    required this.description,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      bluetoothIdentifier: json['bluetoothIdentifier'],
      imei: json['imei'],
      description: json['description'],
    );
  }
}
