// veterinary_center.dart

class VeterinaryCenter {
  final int id;
  final String name;
  final String address;
  final String phoneNumber;
  final String city;

  VeterinaryCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.city,
  });

  factory VeterinaryCenter.fromJson(Map<String, dynamic> json) {
    return VeterinaryCenter(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      city: json['city'],
    );
  }
}