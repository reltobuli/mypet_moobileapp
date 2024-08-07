import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/veterinary_center.dart';
import '../models/instruction.dart';


Future<List<Instruction>> fetchInstructions() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/instructions'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Instruction> instructions = data.map((json) => Instruction.fromJson(json)).toList();
    return instructions;
  } else {
    throw Exception('Failed to load instructions');
  }
}

Future<List<dynamic>> fetchShelters() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/shelters'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load shelters');
  }
}

Future<List<VeterinaryCenter>> fetchVeterinaryCenters() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/veterinaries'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<VeterinaryCenter> centers = data.map((json) => VeterinaryCenter.fromJson(json)).toList();
    return centers;
  } else {
    throw Exception('Failed to load veterinary centers');
  }
}



