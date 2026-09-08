import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/church_service.dart';
import '../auth/auth_controller.dart';

class ManageProvincesPage extends StatefulWidget {
  const ManageProvincesPage({super.key});

  @override
  State<ManageProvincesPage> createState() => _ManageProvincesPageState();
}

class _ManageProvincesPageState extends State<ManageProvincesPage> {
  final ChurchService _churchService = ChurchService();

  List<Map<String, dynamic>> _provinces = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    final auth = context.read<AuthController>();

    if (auth.accessToken == null) {
      setState(() {
        _loading = false;
        _error = 'Authentication required.';
      });
      return;
    }

    try {
      final provinces = await _churchService.getProvinces(
        auth.accessToken!,
      );

      if (!mounted) return;

      setState(() {
        _provinces = provinces;
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _showAddProvinceDialog() async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Province'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Province name',
              hintText: 'Enter province name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isNotEmpty) {
                  Navigator.of(context).pop(value);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (name == null || name.isEmpty) {
      return;
    }

    final auth = context.read<AuthController>();

    if (auth.accessToken == null) {
      return;
    }

    try {
      await _churchService.createProvince(
        name,
        auth.accessToken!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Province added successfully.'),
        ),
      );

      await _loadProvinces();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add province: $error'),
        ),
      );
    }
  }

  Future<void> _showEditProvinceDialog(
    Map<String, dynamic> province,
  ) async {
    final controller = TextEditingController(
      text: province['name']?.toString() ?? '',
    );

    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Province'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Province name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isNotEmpty) {
                  Navigator.of(context).pop(value);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (name == null || name.isEmpty) {
      return;
    }

    final provinceId = province['id']?.toString();

    if (provinceId == null || provinceId.isEmpty) {
      return;
    }

    final auth = context.read<AuthController>();

    if (auth.accessToken == null) {
      return;
    }

    try {
      await _churchService.updateProvince(
        provinceId,
        name,
        auth.accessToken!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Province updated successfully.'),
        ),
      );

      await _loadProvinces();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update province: $error'),
        ),
      );
    }
  }

  Future<void> _confirmDeleteProvince(
  Map<String, dynamic> province,
) async {
  final provinceName =
      province['name']?.toString() ?? 'this province';

  final provinceId = province['id']?.toString();

  if (provinceId == null || provinceId.isEmpty) {
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Province'),
        content: Text(
          'Are you sure you want to delete "$provinceName"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (confirmed != true) {
    return;
  }

  final auth = context.read<AuthController>();

  if (auth.accessToken == null) {
    return;
  }

  try {
    await _churchService.deleteProvince(
      provinceId,
      auth.accessToken!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Province deleted successfully.'),
      ),
    );

    await _loadProvinces();
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete province: $error'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Provinces'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProvinceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _loading = true;
                  });

                  _loadProvinces();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_provinces.isEmpty) {
      return const Center(
        child: Text(
          'No provinces found.',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProvinces,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _provinces.length,
        itemBuilder: (context, index) {
          final province = _provinces[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.account_balance),
              ),
              title: Text(
                province['name']?.toString() ?? 'Unnamed Province',
              ),
              subtitle: const Text(
                'Province',
              ),
              trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () => _showEditProvinceDialog(province),
    ),
    IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: () => _confirmDeleteProvince(province),
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