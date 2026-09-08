import 'package:flutter/material.dart';

import 'event_card.dart';
import 'feature_card.dart';
import 'home_content.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<Feature> onFeatureTap;

  const HomePage({
    super.key,
    required this.onFeatureTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              child: Icon(Icons.church, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACK HUB',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text('The Digital Cathedral'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF173F5F),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Scripture',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 10),
              Text(
                '“Let all that you do be done in love.”',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1 Corinthians 16:14',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Explore ACK Hub',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .92,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];

            return FeatureCard(
              feature: feature,
              onTap: () => onFeatureTap(feature),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Coming Up',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        const EventCard(
          title: 'Parish Fellowship',
          date: 'Sunday • 10:00 AM',
        ),
        const EventCard(
          title: 'Daily Evening Prayer',
          date: 'Today • 6:00 PM',
        ),
      ],
    );
  }
}