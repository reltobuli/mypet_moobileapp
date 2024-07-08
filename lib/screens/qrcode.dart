import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String? qrCodeSvg;

  Future<void> generateQRCode(String data) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/qrcode?data=${Uri.encodeComponent(data)}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        qrCodeSvg = response.body;
      });
    } else {
      throw Exception('Failed to generate QR code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter data for QR Code',
              ),
              onSubmitted: (value) {
                generateQRCode(value);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                generateQRCode('Example Data'); // Replace with your data
              },
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20),
            qrCodeSvg != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        child: SvgPicture.string(
                          qrCodeSvg!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QRCodePage(),
  ));
}
