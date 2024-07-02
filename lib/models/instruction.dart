// lib/models/instruction.dart
class Instruction {
  final int id;
  final String title;
  final String details;

  Instruction({required this.id, required this.title, required this.details});

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      id: json['id'],
      title: json['title'],
      details: json['details'],
    );
  }
}
