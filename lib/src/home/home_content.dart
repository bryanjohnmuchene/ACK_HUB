import 'package:flutter/material.dart';

class Feature {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const Feature(this.title, this.subtitle, this.icon, this.color);
}

const features = [
  Feature(
    'Learn',
    'Bible studies, leadership and theological resources',
    Icons.menu_book_outlined,
    Color(0xFF245B8F),
  ),
  Feature(
    'Worship',
    'Prayers, liturgy, sermons and devotionals',
    Icons.church_outlined,
    Color(0xFF7A4EAB),
  ),
  Feature(
    'Connect',
    'Parishes, ministries, mentors and prayer groups',
    Icons.people_outline,
    Color(0xFF137C6B),
  ),
  Feature(
    'Gather',
    'Conferences, synods, retreats and registrations',
    Icons.calendar_month_outlined,
    Color(0xFFC46B20),
  ),
  Feature(
    'Celebrate',
    'Create and share Anglican greeting cards',
    Icons.celebration_outlined,
    Color(0xFFC85A74),
  ),
  Feature(
    'Support',
    'Marketplace for books, publications and products',
    Icons.storefront_outlined,
    Color(0xFF356859),
  ),
  Feature(
    'Give',
    'Support parishes, missions and emergency appeals',
    Icons.favorite_border,
    Color(0xFFB23A48),
  ),
  Feature(
    'Ask ACK',
    'Your Anglican AI assistant',
    Icons.smart_toy_outlined,
    Color(0xFF173F5F),
  ),
];