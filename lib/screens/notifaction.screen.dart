import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _getTokenAndFetchNotifications() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    _token = await storage.read(key: 'token');
    if (_token != null) {
      try {
        await _loadNotifications(); // Load notifications
      } catch (e) {
        print("Error loading notifications: $e");
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

  Future<void> _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> notifications = await _fetchNotifications(); // Fetch notifications from server

    print('Original Notifications List: $notifications'); // Log the original list

    setState(() {
      _notifications = notifications.where((notif) {
        var adoptionRequestId = notif['data']['adoption_request_id'];
        return !(prefs.getBool('handled_$adoptionRequestId') ?? false);
      }).toList();
    });

    // Log the final notifications list to verify
    print('Final Notifications List: $_notifications');
  }

  Future<List<dynamic>> _fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/Petowner/notifications'), // Update to your server IP
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        print('Notifications fetched: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Failed to load notifications: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
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
        Uri.parse('http://127.0.0.1:8000/api/Petowner/adoption-requests/$adoptionRequestId/$action'), // Update to your server IP
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _notifications.removeAt(index); // Remove notification on success
        });

        // Store in shared preferences that this notification has been handled
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('handled_$adoptionRequestId', true);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Adoption request $action successful'),
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
      backgroundColor: Color.fromARGB(255, 248, 237, 241),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 237, 241),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Color.fromARGB(255, 17, 90, 6),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _getTokenAndFetchNotifications,
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
                    print('Notification data: $notification'); // Log notification data
                    String petName = notification['data']['pet_name'] ?? 'Unknown Pet';

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          petName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(notification['data']['message'] ?? ''),
                        trailing: notification['data']['message'].contains('accepted') || notification['data']['message'].contains('rejected')
                            ? null
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

