import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = false;
  List<dynamic> _notifications = [];
  String? _token;

  @override
  void initState() {
    super.initState();
    _getTokenAndFetchNotifications();
  }

  void _getTokenAndFetchNotifications() async {
    setState(() {
      _isLoading = true;
    });

    _token = await storage.read(key: 'token');
    if (_token != null) {
      print("Token retrieved: $_token");
      try {
        List<dynamic> notifications = await fetchNotifications(_token!);
        print("Fetched notifications: $notifications");
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching notifications: $e");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Token is null");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<dynamic>> fetchNotifications(String token) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/Petowner/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load notifications');
    }
  }

Future<void> _handleAction(int index, String action) async {
  var notification = _notifications[index];
  var adoptionRequestId = notification['data']['adoption_request_id'];

  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/Petowner/adoption-requests/$adoptionRequestId/$action'),
    headers: {
      'Authorization': 'Bearer $_token',
    },
  );

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");
  if (response.statusCode == 200) {
    setState(() {
      _notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Adoption request $action successfully'),
    ));
  } else {
    var responseBody = response.body;
    print("Error: $responseBody");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to $action adoption request'),
    ));
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _notifications.isEmpty
              ? Center(
                  child: Text('No notifications found.'),
                )
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    var notification = _notifications[index];
                    print("Displaying notification: $notification");
                    return Card(
                      child: ListTile(
                        title: Text(notification['data']['pet_name'] ?? ''),
                        subtitle: Text(notification['data']['message'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () => _handleAction(index, 'accept'),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _handleAction(index, 'reject'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                    );
  }
                

  }

  