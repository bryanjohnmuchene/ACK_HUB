import 'package:flutter/material.dart';
import 'manage_provinces_page.dart';
import 'manage_dioceses_page.dart';
import 'manage_parishes_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Church Administration',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Manage the ACK church hierarchy.',
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Provinces'),
              subtitle: const Text(
                'Manage provinces in the church hierarchy',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ManageProvincesPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.church),
              title: const Text('Dioceses'),
              subtitle: const Text(
                'Manage dioceses under each province',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ManageDiocesesPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text('Parishes'),
              subtitle: const Text(
                'Manage parishes under each diocese',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const ManageParishesPage(),
    ),
  );
},
            ),
          ),
        ],
      ),
    );
  }
}