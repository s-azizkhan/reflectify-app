// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationScheduler(),
    );
  }
}

class NotificationScheduler extends StatefulWidget {
  const NotificationScheduler({super.key});

  @override
  _NotificationSchedulerState createState() => _NotificationSchedulerState();
}

class _NotificationSchedulerState extends State<NotificationScheduler> {
  TimeOfDay _selectedTime =
      const TimeOfDay(hour: 9, minute: 0); // Default time set to 9:00 AM

  // Sample list of recordings with their recorded date
  List<Map<String, String>> recordings = [
    {'title': 'Recording 1', 'date': '2024-08-20'},
    {'title': 'Recording 2', 'date': '2024-08-21'},
    {'title': 'Recording 2', 'date': '2024-08-21'},
    {'title': 'Recording 2', 'date': '2024-08-21'},
    {'title': 'Recording 2', 'date': '2024-08-21'},
    {'title': 'Recording 2', 'date': '2024-08-21'},
    {'title': 'Recording 2', 'date': '2024-08-21'},
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
        title: const Text('Audio Journal'),
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
                        // Action when recording is tapped
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
