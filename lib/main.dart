// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "861666848385-ltu8di0jtv6j8pf9e38000qejopqtedc.apps.googleusercontent.com");

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      print('Sign-in error: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

final _googleSignInService = GoogleSignInService();
GoogleSignInAccount? _currentUser;

Future<void> _handleSignIn(BuildContext context) async {
  try {
    final GoogleSignInAccount? account = await _googleSignInService.signIn();
    if (account != null) {
      print('Signed in: ${account.email}');
      _currentUser = account;

      // Show welcome toast
      Fluttertoast.showToast(
        msg: "Welcome, ${account.displayName}!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotificationScheduler()),
      );
    } else {
      // Show toast if sign-in fails
      Fluttertoast.showToast(
        msg: "Sign-in failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  } catch (error) {
    print('Sign-in error: $error');
    // Show toast if sign-in fails
    Fluttertoast.showToast(
      msg: "Sign-in failed due to an error. Please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

Future<void> _handleSignOut(BuildContext context) async {
  try {
    await _googleSignInService.signOut();
    Fluttertoast.showToast(
      msg: "Signed out successfully.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    _currentUser = null;

    // Navigate back to the AuthScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  } catch (error) {
    print('Sign-out error: $error');
    // Show error in toast
    Fluttertoast.showToast(
      msg: "Sign-out failed due to an error. Please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reflectify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Reflectify',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _handleSignIn(context),
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationScheduler extends StatefulWidget {
  const NotificationScheduler({super.key});

  @override
  _NotificationSchedulerState createState() => _NotificationSchedulerState();
}

class _NotificationSchedulerState extends State<NotificationScheduler> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  List<Map<String, String>> recordings = [
    {'title': 'Recording 1', 'date': '2024-08-20'},
    {'title': 'Recording 2', 'date': '2024-08-21'},
    {'title': 'Recording 3', 'date': '2024-08-22'},
    {'title': 'Recording 5', 'date': '2024-08-26'},
  ];

  void _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Notification Time'),
          content: Text('Selected Time: ${_selectedTime.format(context)}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Select Time'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickTime(context);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Reflectify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showScheduleDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_currentUser != null) ...[
              Text('Signed in as ${_currentUser?.email}'),
              ElevatedButton(
                onPressed: () async {
                  await _handleSignOut(
                      context); // Pass the context to the sign-out method
                  setState(() {});
                },
                child: const Text('Sign out'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: recordings.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(recordings[index]['title']!),
                        subtitle:
                            Text('Recorded on: ${recordings[index]['date']}'),
                        trailing: const Icon(Icons.play_arrow),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${recordings[index]['title']} tapped'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            ElevatedButton(
              onPressed: _showScheduleDialog,
              child: const Text('Set Notification Time'),
            ),
          ],
        ),
      ),
    );
  }
}
