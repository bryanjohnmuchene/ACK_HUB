import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.calendar_today),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}