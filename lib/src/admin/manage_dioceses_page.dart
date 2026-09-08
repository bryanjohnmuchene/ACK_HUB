import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/church_service.dart';
import '../auth/auth_controller.dart';

class ManageDiocesesPage extends StatefulWidget {
  const ManageDiocesesPage({super.key});

  @override
  State<ManageDiocesesPage> createState() => _ManageDiocesesPageState();
}

class _ManageDiocesesPageState extends State<ManageDiocesesPage> {
  final ChurchService _churchService = ChurchService();

  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _dioceses = [];

  String? _selectedProvinceId;

  bool _loadingProvinces = true;
  bool _loadingDioceses = false;

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
        _loadingProvinces = false;
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
        _loadingProvinces = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadingProvinces = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _loadDioceses(String provinceId) async {
    final auth = context.read<AuthController>();

    if (auth.accessToken == null) {
      return;
    }

    setState(() {
      _selectedProvinceId = provinceId;
      _loadingDioceses = true;
      _dioceses = [];
    });

    try {
      final dioceses = await _churchService.getDioceses(
        provinceId,
        auth.accessToken!,
      );

      if (!mounted) return;

      setState(() {
        _dioceses = dioceses;
        _loadingDioceses = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadingDioceses = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _showAddDioceseDialog() async {
  if (_selectedProvinceId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a province first.'),
      ),
    );
    return;
  }

  final controller = TextEditingController();

  final name = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Diocese'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Diocese name',
            hintText: 'Enter diocese name',
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
    await _churchService.createDiocese(
      _selectedProvinceId!,
      name,
      auth.accessToken!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Diocese added successfully.'),
      ),
    );

    await _loadDioceses(_selectedProvinceId!);
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to add diocese: $error'),
      ),
    );
  }
}

Future<void> _showEditDioceseDialog(
  Map<String, dynamic> diocese,
) async {
  final controller = TextEditingController(
    text: diocese['name']?.toString() ?? '',
  );

  final name = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Diocese'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Diocese name',
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

  final dioceseId = diocese['id']?.toString();

  if (dioceseId == null || dioceseId.isEmpty) {
    return;
  }

  if (_selectedProvinceId == null) {
    return;
  }

  final auth = context.read<AuthController>();

  if (auth.accessToken == null) {
    return;
  }

  try {
    await _churchService.updateDiocese(
      dioceseId,
      _selectedProvinceId!,
      name,
      auth.accessToken!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Diocese updated successfully.'),
      ),
    );

    await _loadDioceses(_selectedProvinceId!);
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to update diocese: $error'),
      ),
    );
  }
}

Future<void> _confirmDeleteDiocese(
  Map<String, dynamic> diocese,
) async {
  final dioceseName =
      diocese['name']?.toString() ?? 'this diocese';

  final dioceseId = diocese['id']?.toString();

  if (dioceseId == null || dioceseId.isEmpty) {
    return;
  }

  if (_selectedProvinceId == null) {
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Diocese'),
        content: Text(
          'Are you sure you want to delete "$dioceseName"? '
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
    await _churchService.deleteDiocese(
      dioceseId,
      auth.accessToken!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Diocese deleted successfully.'),
      ),
    );

    await _loadDioceses(_selectedProvinceId!);
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete diocese: $error'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(
    title: const Text('Manage Dioceses'),
  ),
  body: _buildBody(),
  floatingActionButton: FloatingActionButton(
    onPressed: _showAddDioceseDialog,
    child: const Icon(Icons.add),
  ),
);
  }

  Widget _buildBody() {
    if (_loadingProvinces) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null && _provinces.isEmpty) {
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
                    _loadingProvinces = true;
                    _error = null;
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Select Province',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          initialValue: _selectedProvinceId,
          decoration: const InputDecoration(
            labelText: 'Province',
            border: OutlineInputBorder(),
          ),
          items: _provinces.map((province) {
            final id = province['id']?.toString();
            final name = province['name']?.toString() ?? 'Unnamed Province';

            return DropdownMenuItem<String>(
              value: id,
              child: Text(name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _loadDioceses(value);
            }
          },
        ),

        const SizedBox(height: 24),

        if (_selectedProvinceId == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Select a province to view its dioceses.',
                textAlign: TextAlign.center,
              ),
            ),
          ),

        if (_loadingDioceses)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),

        if (!_loadingDioceses &&
            _selectedProvinceId != null &&
            _dioceses.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No dioceses found for this province.',
                textAlign: TextAlign.center,
              ),
            ),
          ),

        if (!_loadingDioceses)
          ..._dioceses.map(
            (diocese) => Card(
              child: ListTile(
  leading: const CircleAvatar(
    child: Icon(Icons.church),
  ),
  title: Text(
    diocese['name']?.toString() ?? 'Unnamed Diocese',
  ),
  subtitle: const Text('Diocese'),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () => _showEditDioceseDialog(diocese),
      ),
      IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => _confirmDeleteDiocese(diocese),
      ),
    ],
  ),
),
            ),
          ),
      ],
    );
  }
}