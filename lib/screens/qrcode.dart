import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String? qrCodeSvg;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> generateQRCode(String petId) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/qrcode/$petId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          qrCodeSvg = response.body;
        });
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate QR code: ${response.reasonPhrase}')),
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
        title: Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Pet ID for QR Code',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String petId = _controller.text;
                if (petId.isNotEmpty) {
                  generateQRCode(petId);
                }
              },
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Show loading indicator
                : qrCodeSvg != null
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



