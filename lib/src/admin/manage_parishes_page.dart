import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/church_service.dart';
import '../auth/auth_controller.dart';

class ManageParishesPage extends StatefulWidget {
  const ManageParishesPage({super.key});

  @override
  State<ManageParishesPage> createState() => _ManageParishesPageState();
}

class _ManageParishesPageState extends State<ManageParishesPage> {
  final ChurchService _churchService = ChurchService();

  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _dioceses = [];
  List<Map<String, dynamic>> _parishes = [];

  String? _selectedProvinceId;
  String? _selectedDioceseId;

  bool _loadingProvinces = true;
  bool _loadingDioceses = false;
  bool _loadingParishes = false;

  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  // ================= PROVINCES =================

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

  // ================= DIOCESES =================

  Future<void> _loadDioceses(String provinceId) async {
    final auth = context.read<AuthController>();

    if (auth.accessToken == null) {
      return;
    }

    setState(() {
      _selectedProvinceId = provinceId;
      _selectedDioceseId = null;
      _dioceses = [];
      _parishes = [];
      _loadingDioceses = true;
      _loadingParishes = false;
      _error = null;
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

  // ================= PARISHES =================

  Future<void> _loadParishes(String dioceseId) async {
    final auth = context.read<AuthController>();

    if (auth.accessToken == null) {
      return;
    }

    setState(() {
      _selectedDioceseId = dioceseId;
      _loadingParishes = true;
      _parishes = [];
      _error = null;
    });

    try {
      final parishes = await _churchService.getParishes(
        dioceseId,
        auth.accessToken!,
      );

      if (!mounted) return;

      setState(() {
        _parishes = parishes;
        _loadingParishes = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadingParishes = false;
        _error = error.toString();
      });
    }
  }

  // ================= ADD PARISH =================

  Future<void> _showAddParishDialog() async {
    if (_selectedDioceseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a diocese first.'),
        ),
      );
      return;
    }

    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Parish'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Parish name',
              hintText: 'Enter parish name',
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
      await _churchService.createParish(
        _selectedDioceseId!,
        name,
        auth.accessToken!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parish added successfully.'),
        ),
      );

      await _loadParishes(_selectedDioceseId!);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add parish: $error'),
        ),
      );
    }
  }

  // ================= EDIT PARISH =================

  Future<void> _showEditParishDialog(
    Map<String, dynamic> parish,
  ) async {
    final controller = TextEditingController(
      text: parish['name']?.toString() ?? '',
    );

    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Parish'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Parish name',
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

    final parishId = parish['id']?.toString();

    if (parishId == null || parishId.isEmpty) {
      return;
    }

    if (_selectedDioceseId == null) {
      return;
    }

    final auth = context.read<AuthController>();

    if (auth.accessToken == null) {
      return;
    }

    try {
      await _churchService.updateParish(
        parishId,
        _selectedDioceseId!,
        name,
        auth.accessToken!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parish updated successfully.'),
        ),
      );

      await _loadParishes(_selectedDioceseId!);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update parish: $error'),
        ),
      );
    }
  }

  // ================= DELETE PARISH =================

  Future<void> _confirmDeleteParish(
    Map<String, dynamic> parish,
  ) async {
    final parishName =
        parish['name']?.toString() ?? 'this parish';

    final parishId = parish['id']?.toString();

    if (parishId == null || parishId.isEmpty) {
      return;
    }

    if (_selectedDioceseId == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Parish'),
          content: Text(
            'Are you sure you want to delete "$parishName"? '
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
      await _churchService.deleteParish(
        parishId,
        auth.accessToken!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parish deleted successfully.'),
        ),
      );

      await _loadParishes(_selectedDioceseId!);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete parish: $error'),
        ),
      );
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Parishes'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddParishDialog,
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
        // ================= PROVINCE =================

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

            final name =
                province['name']?.toString() ??
                    'Unnamed Province';

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

        // ================= DIOCESE =================

        const Text(
          'Select Diocese',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          initialValue: _selectedDioceseId,
          decoration: const InputDecoration(
            labelText: 'Diocese',
            border: OutlineInputBorder(),
          ),
          items: _dioceses.map((diocese) {
            final id = diocese['id']?.toString();

            final name =
                diocese['name']?.toString() ??
                    'Unnamed Diocese';

            return DropdownMenuItem<String>(
              value: id,
              child: Text(name),
            );
          }).toList(),
          onChanged: _dioceses.isEmpty
              ? null
              : (value) {
                  if (value != null) {
                    _loadParishes(value);
                  }
                },
        ),

        const SizedBox(height: 24),

        // ================= STATES =================

        if (_selectedProvinceId == null)
          const Center(
            child: Text(
              'Select a province first.',
              textAlign: TextAlign.center,
            ),
          ),

        if (_selectedProvinceId != null &&
            _loadingDioceses)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),

        if (_selectedProvinceId != null &&
            !_loadingDioceses &&
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

        if (_selectedDioceseId != null &&
            _loadingParishes)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),

        if (_selectedDioceseId != null &&
            !_loadingParishes &&
            _parishes.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No parishes found for this diocese.',
                textAlign: TextAlign.center,
              ),
            ),
          ),

        // ================= PARISH LIST =================

        if (!_loadingParishes)
          ..._parishes.map(
            (parish) => Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.home_work),
                ),
                title: Text(
                  parish['name']?.toString() ??
                      'Unnamed Parish',
                ),
                subtitle: const Text('Parish'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                      ),
                      tooltip: 'Edit Parish',
                      onPressed: () =>
                          _showEditParishDialog(parish),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      tooltip: 'Delete Parish',
                      onPressed: () =>
                          _confirmDeleteParish(parish),
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