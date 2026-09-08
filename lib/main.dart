import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/auth/auth_controller.dart';
import 'src/auth/auth_screen.dart';
import 'src/home/home_content.dart';
import 'src/home/home_page.dart';
import 'src/admin/admin_dashboard.dart';

void main() => runApp(const AckHubApp());

class AckHubApp extends StatefulWidget {
  const AckHubApp({super.key});

  @override
  State<AckHubApp> createState() => _AckHubAppState();
}

class _AckHubAppState extends State<AckHubApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController()..restoreSession(),
      child: MaterialApp(
        title: 'ACK Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF173F5F),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        ),
        home: Consumer<AuthController>(
          builder: (_, auth, __) {
            if (auth.status == AuthStatus.loading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return auth.isAuthenticated
                ? const AppShell()
                : const AuthScreen();
          },
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  List<Widget> get pages => [
        HomePage(onFeatureTap: openFeature),
        CategoryPage(feature: features[0]),
        CategoryPage(feature: features[1]),
        CategoryPage(feature: features[2]),
        const MorePage(),
      ];

  void openFeature(Feature feature) {
    if (feature.title == 'Ask ACK') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AskAckPage()),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryPage(feature: feature),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[index]),
      floatingActionButton: index != 4
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AskAckPage()),
              ),
              icon: const Icon(Icons.smart_toy_outlined),
              label: const Text('Ask ACK'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.church_outlined),
            selectedIcon: Icon(Icons.church),
            label: 'Worship',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Connect',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final Feature feature;

  const CategoryPage({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    final items = {
          'Learn': [
            'Bible Studies',
            'Leadership Training',
            'Theological Education',
            'Children & Youth',
            'KAMA & Mothers’ Union',
          ],
          'Worship': [
            'Daily Prayers',
            'Liturgical Resources',
            'Sermons',
            'Lectionaries',
            'Livestreams & Devotionals',
          ],
          'Connect': [
            'My Parish',
            'Prayer Groups',
            'Ministries',
            'Mentors',
            'Church Community',
          ],
          'Gather': [
            'Upcoming Events',
            'Register for an Event',
            'Conferences',
            'Synods',
            'Retreats',
          ],
          'Celebrate': [
            'Birthdays',
            'Christmas',
            'Easter',
            'Weddings',
            'Ordinations & Anniversaries',
          ],
          'Support': [
            'Books',
            'Publications',
            'Church Merchandise',
            'Policy Documents',
            'Local Products',
          ],
          'Give': [
            'My Parish',
            'My Diocese',
            'Mission Projects',
            'Social Ministries',
            'Emergency Appeals',
          ],
        }[feature.title] ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: Text(feature.title),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(feature.icon, size: 52, color: feature.color),
          const SizedBox(height: 14),
          Text(
            feature.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(feature.subtitle),
          const SizedBox(height: 24),
          ...items.map(
            (item) => Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(child: Icon(feature.icon)),
                title: Text(item),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
final isAdmin = auth.roles.any(
  (role) => [
    'super_admin',
    'province_admin',
    'diocese_admin',
    'parish_admin',
  ].contains(role),
);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'More',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: 16),

        // ================= ADMIN =================

        if (isAdmin) ...[
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.admin_panel_settings),
              ),
              title: const Text('Admin Dashboard'),
              subtitle: const Text(
                'Manage the ACK church administration',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AdminDashboard(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
        ],

        // ================= FEATURES =================

        ...features.skip(3).map(
          (feature) => ListTile(
            leading: CircleAvatar(
              child: Icon(
                feature.icon,
                color: feature.color,
              ),
            ),
            title: Text(feature.title),
            subtitle: Text(feature.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => feature.title == 'Ask ACK'
                    ? const AskAckPage()
                    : CategoryPage(feature: feature),
              ),
            ),
          ),
        ),

        const Divider(height: 32),

        const ListTile(
          leading: Icon(Icons.person_outline),
          title: Text('Profile'),
        ),

        const ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text('Settings'),
        ),
      ],
    );
  }
}

class AskAckPage extends StatefulWidget {
  const AskAckPage({super.key});

  @override
  State<AskAckPage> createState() => _AskAckPageState();
}

class _AskAckPageState extends State<AskAckPage> {
  final controller = TextEditingController();

  final messages = <String>[
    'Welcome to Ask ACK. How can I help you explore Anglican resources today?',
  ];

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      messages.add(
        'ACK Hub AI integration will connect here. This prototype preserves the Ask ACK experience and is ready for a secure backend/API.',
      );
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask ACK')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) => Align(
                alignment:
                    i.isEven ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  constraints: const BoxConstraints(maxWidth: 320),
                  decoration: BoxDecoration(
                    color: i.isEven
                        ? Colors.white
                        : Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(messages[i]),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => send(),
                      decoration: const InputDecoration(
                        hintText: 'Ask about doctrine, liturgy, events...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}