import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageUploadService {
  Future<http.Response> uploadImage({
    required File imageFile,
    required String name,
    required String type,
    required String gender,
    required String age,
    required String color,
    required String address,
    required String qrCode,
    required String token,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8006/api/Petowner/report-missing-pet'); // Replace with your actual API endpoint

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    request.fields.addAll({
      'name': name,
      'type': type,
      'gender': gender,
      'age': age,
      'color': color,
      'address': address,
      'qrcode': qrCode,
    });

    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'), // Adjust content type based on your image type
    ));

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}