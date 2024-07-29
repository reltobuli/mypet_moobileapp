import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:typed_data';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  Uint8List? qrCodeImage;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> generateQRCode(String petName) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/qrcode?pet_name=$petName'),
      );

      if (response.statusCode == 200) {
        setState(() {
          qrCodeImage = response.bodyBytes; // Save the image bytes
        });
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate QR code: ${response.statusCode} ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Pet Name for QR Code',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String petName = _controller.text.trim();
                if (petName.isNotEmpty) {
                  generateQRCode(petName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid Pet Name')),
                  );
                }
              },
              child: const Text('Generate QR Code'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : qrCodeImage != null
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            child: Image.memory(
                              qrCodeImage!,
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







