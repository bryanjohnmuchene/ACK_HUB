import 'package:flutter/material.dart';
import 'api_client.dart';
class ChurchProfile { final String firstName,lastName; final Map<String,dynamic> churchIds; ChurchProfile(this.firstName,this.lastName,this.churchIds); }
class ChurchOnboarding extends StatefulWidget { const ChurchOnboarding({super.key}); @override State<ChurchOnboarding> createState() => _ChurchOnboardingState(); }
class _ChurchOnboardingState extends State<ChurchOnboarding> { final _api=ApiClient(); final _first=TextEditingController(); final _last=TextEditingController(); List<Map<String,dynamic>> provinces=[], dioceses=[], parishes=[]; String? provinceId,dioceseId,parishId; bool busy=true;
  @override void initState(){super.initState(); _loadProvinces();} Future<void> _loadProvinces() async { try { provinces=await _api.getList('/church/provinces'); } finally { if(mounted)setState(()=>busy=false); } } Future<void> _loadDioceses(String id) async { setState(() {busy=true;provinceId=id;dioceseId=null;parishId=null;dioceses=[];parishes=[];}); dioceses=await _api.getList('/church/provinces/$id/dioceses'); if(mounted)setState(()=>busy=false); } Future<void> _loadParishes(String id) async { setState(() {busy=true;dioceseId=id;parishId=null;parishes=[];}); parishes=await _api.getList('/church/dioceses/$id/parishes'); if(mounted)setState(()=>busy=false); }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your church community')),
    body: busy
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Tell us where you worship',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _first,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(labelText: 'First name'),
              ),
              TextField(
                controller: _last,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(labelText: 'Last name'),
              ),
              DropdownButtonFormField<String>(
                initialValue: provinceId,
                decoration: const InputDecoration(labelText: 'Province'),
                items: provinces
                    .map<DropdownMenuItem<String>>(
                      (x) => DropdownMenuItem<String>(
                        value: x['id'] as String,
                        child: Text(x['name'].toString()),
                      ),
                    )
                    .toList(),
                onChanged: (v) => v == null ? null : _loadDioceses(v),
              ),
              DropdownButtonFormField<String>(
                initialValue: dioceseId,
                decoration: const InputDecoration(labelText: 'Diocese (optional)'),
                items: dioceses
                    .map<DropdownMenuItem<String>>(
                      (x) => DropdownMenuItem<String>(
                        value: x['id'] as String,
                        child: Text(x['name'].toString()),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) {
                    setState(() {
                      dioceseId = null;
                      parishId = null;
                    });
                    return;
                  }
                  setState(() {
                    dioceseId = v;
                    parishId = null;
                  });
                  _loadParishes(v);
                },
              ),
              DropdownButtonFormField<String>(
  initialValue: parishId,
  decoration: const InputDecoration(
    labelText: 'Parish (optional)',
  ),
  items: parishes
      .map<DropdownMenuItem<String>>(
        (x) => DropdownMenuItem<String>(
          value: x['id'] as String,
          child: Text(x['name'].toString()),
        ),
      )
      .toList(),
  onChanged: dioceses.isEmpty
      ? null
      : (v) {
          setState(() {
            parishId = v;
          });
        },
),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: _first.text.trim().isEmpty ||
                        _last.text.trim().isEmpty ||
                        provinceId == null
                    ? null
                    : () => Navigator.pop(
                          context,
                          ChurchProfile(
                            _first.text.trim(),
                            _last.text.trim(),
                            {
                              'provinceId': provinceId,
                              'dioceseId': dioceseId,
                              'parishId': parishId,
                            },
                          ),
                        ),
                child: const Text('Create account'),
              ),
            ],
          ),
  );
}
