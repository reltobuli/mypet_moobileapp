
class VeterinaryCenter {
  final int id;
  final String name;
  final String address;
  final String phoneNumber;
  final String city;
    final String rating;

  VeterinaryCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.rating,
    required this.city,

  });

  factory VeterinaryCenter.fromJson(Map<String, dynamic> json) {
    return VeterinaryCenter(
      id: json['id'],
      name: json['name'],
      
      phoneNumber: json['phone_number'],
      rating: json['rating'],
      city: json['city'],
      address: json['address'],
    );
  }
}