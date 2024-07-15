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
    _isLoading = true; // Start loading
  });

  _token = await storage.read(key: 'token');
  if (_token != null) {
    try {
      await _fetchNotifications(); // Fetch notifications
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  } else {
    print("Token is null");
    setState(() {
      _isLoading = false; // Stop loading if token is null
    });
  }
}


  Future<void> _fetchNotifications() async {
    try {
      final notifications = await fetchNotifications(_token!);
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
  }

 Future<List<dynamic>> fetchNotifications(String token) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/Petowner/notifications'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Notifications fetched: ${response.body}'); // Log the response
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load notifications');
  }
}


Future<void> _handleAction(int index, String action) async {
  var notification = _notifications[index];
  var adoptionRequestId = notification['data']['adoption_request_id'];

  setState(() {
    _isLoading = true; // Show loading indicator
  });

  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/Petowner/adoption-requests/$adoptionRequestId/$action'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _notifications.removeAt(index); // Remove notification on success
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Adoption request $action successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to $action adoption request: ${response.body}'),
      ));
    }
  } catch (e) {
    print("Error processing request: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: $e'),
    ));
  } finally {
    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor:Color.fromARGB(255, 248, 237, 241),
    appBar: AppBar(
       backgroundColor:Color.fromARGB(255, 248, 237, 241),
      title: Text('Notifications',
      style: TextStyle(
        color: Color.fromARGB(255, 17, 90, 6)
      ),),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _fetchNotifications,
        ),
      ],
    ),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _notifications.isEmpty
            ? Center(child: Text('No notifications found.'))
            : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  var notification = _notifications[index];
                  String message = notification['data']['message'] ?? '';

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        notification['data']['pet_name'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(message),
                      trailing: (message.contains('accepted') || message.contains('rejected'))
                          ? null // Remove buttons if accepted/rejected
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: const Color.fromARGB(255, 147, 177, 148)),
                                  onPressed: () => _handleAction(index, 'accept'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: const Color.fromARGB(255, 147, 177, 148)),
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