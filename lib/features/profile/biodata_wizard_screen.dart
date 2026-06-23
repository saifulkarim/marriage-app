import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class BiodataWizardScreen extends ConsumerStatefulWidget {
  const BiodataWizardScreen({super.key});

  @override
  ConsumerState<BiodataWizardScreen> createState() => _BiodataWizardScreenState();
}

class _BiodataWizardScreenState extends ConsumerState<BiodataWizardScreen> {
  int _step = 0;
  bool _loadingMeta = true;
  bool _saving = false;

  List<dynamic> _types = [];
  List<dynamic> _marital = [];
  List<dynamic> _countries = [];
  List<dynamic> _districts = [];
  List<dynamic> _permanentUpazilas = [];
  List<dynamic> _presentUpazilas = [];
  List<dynamic> _questionSets = [];
  List<dynamic> _questions = [];
  List<dynamic> _options = [];

  int? _biodataTypeId;
  int? _maritalId;
  int? _nationalityId;
  int? _permDistrictId;
  int? _permUpazilaId;
  int? _presDistrictId;
  int? _presUpazilaId;
  bool _showImage = true;
  String? _imagePath;
  String? _contentLanguage;

  final _birthDate = TextEditingController();
  final _heightFoot = TextEditingController();
  final _heightInch = TextEditingController();
  final _skinTone = TextEditingController();
  final _weight = TextEditingController();
  final _bloodGroup = TextEditingController();
  final _permAddress = TextEditingController();
  final _presAddress = TextEditingController();
  final _candidateName = TextEditingController();
  final _contactNo = TextEditingController();
  final _guardianMobile = TextEditingController();
  final _relation = TextEditingController();
  final _email = TextEditingController();

  final Map<int, TextEditingController> _answerControllers = {};
  final Map<int, int?> _mcqSelections = {};

  @override
  void initState() {
    super.initState();
    _loadMeta();
    _loadExisting();
  }

  Future<void> _loadMeta() async {
    final meta = ref.read(metaRepositoryProvider);
    final bundle = await meta.questionSetsBundle();
    setState(() {
      _types = [];
      _marital = [];
      _countries = [];
      _districts = [];
      _questionSets = bundle['question_sets'] as List? ?? [];
      _questions = bundle['questions'] as List? ?? [];
      _options = bundle['options'] as List? ?? [];
      _loadingMeta = true;
    });

    try {
      final results = await Future.wait([
        meta.biodataTypes(),
        meta.maritalConditions(),
        meta.countries(),
        meta.districts(),
      ]);
      setState(() {
        _types = results[0];
        _marital = results[1];
        _countries = results[2];
        _districts = results[3];
      });
    } finally {
      setState(() => _loadingMeta = false);
    }
  }

  Future<void> _loadExisting() async {
    try {
      final dash = await ref.read(profileRepositoryProvider).dashboard();
      final biodata = dash['user']?['biodata'] as Map<String, dynamic>?;
      if (biodata == null) return;

      setState(() {
        _biodataTypeId = biodata['biodata_type_id'] as int?;
        _maritalId = biodata['marital_condition_id'] as int?;
        _nationalityId = biodata['nationality'] as int?;
        _permDistrictId = biodata['permenant_district_id'] as int?;
        _permUpazilaId = biodata['permenant_upazila_id'] as int?;
        _presDistrictId = biodata['present_district_id'] as int?;
        _presUpazilaId = biodata['present_upazila_id'] as int?;
        _showImage = biodata['show_image'] == 1;
        _birthDate.text = biodata['birth_date']?.toString() ?? '';
        _heightFoot.text = biodata['height_foot']?.toString() ?? '';
        _heightInch.text = biodata['height_inch']?.toString() ?? '';
        _skinTone.text = biodata['skin_tone']?.toString() ?? '';
        _weight.text = biodata['weight']?.toString() ?? '';
        _bloodGroup.text = biodata['blood_group']?.toString() ?? '';
        _permAddress.text = biodata['permenant_address']?.toString() ?? '';
        _presAddress.text = biodata['present_address']?.toString() ?? '';
        _candidateName.text = biodata['name']?.toString() ?? '';
        _contactNo.text = biodata['contact_no']?.toString() ?? '';
        _guardianMobile.text = biodata['gurdians_mobile_no']?.toString() ?? '';
        _relation.text = biodata['relation_with_gurdian']?.toString() ?? '';
        _email.text = biodata['email']?.toString() ?? '';
      });

      if (_permDistrictId != null) {
        _permanentUpazilas = await ref.read(metaRepositoryProvider).upazilas(_permDistrictId!);
      }
      if (_presDistrictId != null) {
        _presentUpazilas = await ref.read(metaRepositoryProvider).upazilas(_presDistrictId!);
      }
      setState(() {});
    } catch (_) {}
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (file != null) setState(() => _imagePath = file.path);
  }

  List<dynamic> _optionsForQuestion(int questionId) {
    return _options.where((o) => (o as Map)['question_id'] == questionId).toList();
  }

  List<dynamic> _questionsForSet(int setId) {
    return _questions.where((q) => (q as Map)['question_set_id'] == setId).toList();
  }

  Future<void> _saveStep() async {
    setState(() => _saving = true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      if (_step == 0) {
        await repo.saveGeneral({
          'biodata_type_id': _biodataTypeId,
          'marital_condition_id': _maritalId,
          'birth_date': _birthDate.text.trim(),
          'height_foot': _heightFoot.text.trim(),
          'height_inch': _heightInch.text.trim(),
          'skin_tone': _skinTone.text.trim(),
          'weight': _weight.text.trim(),
          'blood_group': _bloodGroup.text.trim(),
          'nationality': _nationalityId,
          if (_contentLanguage != null) 'content_language': _contentLanguage,
        });
      } else if (_step == 1) {
        await repo.saveAddress({
          'permenant_district_id': _permDistrictId,
          'permenant_upazila_id': _permUpazilaId,
          'permenant_address': _permAddress.text.trim(),
          'present_district_id': _presDistrictId,
          'present_upazila_id': _presUpazilaId,
          'present_address': _presAddress.text.trim(),
        });
      } else if (_step == 2) {
        final answers = <Map<String, dynamic>>[];
        for (final q in _questions) {
          final question = q as Map<String, dynamic>;
          final id = question['id'] as int;
          final type = question['type'] as int? ?? 1;
          String answer;
          if (type == 2) {
            answer = (_mcqSelections[id] ?? '').toString();
          } else {
            answer = _answerControllers[id]?.text.trim() ?? '';
          }
          if (answer.isEmpty) continue;
          answers.add({
            'question_set_id': question['question_set_id'],
            'question_id': id,
            'answer': answer,
          });
        }
        if (answers.isNotEmpty) await repo.saveAnswers(answers);
      } else {
        await repo.saveContact(
          candidateName: _candidateName.text.trim(),
          guardiansMobile: _guardianMobile.text.trim(),
          relationWithGuardian: _relation.text.trim(),
          email: _email.text.trim(),
          contactNo: _contactNo.text.trim().isEmpty ? null : _contactNo.text.trim(),
          showImage: _showImage,
          imagePath: _imagePath,
        );
      }

      ref.invalidate(currentUserProvider);

      if (_step < 3) {
        setState(() => _step++);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).biodataSaved)),
          );
          Navigator.of(context).pop(true);
        }
      }
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _birthDate.dispose();
    _heightFoot.dispose();
    _heightInch.dispose();
    _skinTone.dispose();
    _weight.dispose();
    _bloodGroup.dispose();
    _permAddress.dispose();
    _presAddress.dispose();
    _candidateName.dispose();
    _contactNo.dispose();
    _guardianMobile.dispose();
    _relation.dispose();
    _email.dispose();
    for (final c in _answerControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loadingMeta) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.createBiodata)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.biodataStep(_step + 1))),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_step + 1) / 4),
          Expanded(child: _buildStep()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_step > 0)
                  OutlinedButton(
                    onPressed: _saving ? null : () => setState(() => _step--),
                    child: Text(l10n.back),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _saving ? null : _saveStep,
                  child: _saving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_step == 3 ? l10n.finish : l10n.saveNext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _generalStep(),
      1 => _addressStep(),
      2 => _questionsStep(),
      _ => _contactStep(),
    };
  }

  Widget _generalStep() {
    final l10n = AppLocalizations.of(context);
    final languagesAsync = ref.watch(languagesProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.writeInYourLanguage, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        languagesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (languages) => DropdownButtonFormField<String>(
            value: _contentLanguage,
            decoration: InputDecoration(labelText: l10n.contentLanguage, border: const OutlineInputBorder()),
            items: languages
                .map((l) => DropdownMenuItem(value: l.code, child: Text(l.name)))
                .toList(),
            onChanged: (v) => setState(() => _contentLanguage = v),
          ),
        ),
        const SizedBox(height: 16),
        _dropdown('Biodata Type', _types, _biodataTypeId, (v) => setState(() => _biodataTypeId = v)),
        _dropdown('Marital Status', _marital, _maritalId, (v) => setState(() => _maritalId = v)),
        _dropdown('Nationality', _countries, _nationalityId, (v) => setState(() => _nationalityId = v), labelKey: 'nationality'),
        _field(_birthDate, 'Birth Date (YYYY-MM-DD)'),
        Row(children: [
          Expanded(child: _field(_heightFoot, 'Height (ft)')),
          const SizedBox(width: 8),
          Expanded(child: _field(_heightInch, 'Height (in)')),
        ]),
        _field(_weight, 'Weight (kg)'),
        _field(_skinTone, 'Skin Tone'),
        _field(_bloodGroup, 'Blood Group'),
      ],
    );
  }

  Widget _addressStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Permanent Address', style: TextStyle(fontWeight: FontWeight.bold)),
        _dropdown('District', _districts, _permDistrictId, (v) async {
          setState(() {
            _permDistrictId = v;
            _permUpazilaId = null;
          });
          if (v != null) {
            _permanentUpazilas = await ref.read(metaRepositoryProvider).upazilas(v);
            setState(() {});
          }
        }),
        _dropdown('Upazila', _permanentUpazilas, _permUpazilaId, (v) => setState(() => _permUpazilaId = v)),
        _field(_permAddress, 'Address'),
        const SizedBox(height: 24),
        const Text('Present Address', style: TextStyle(fontWeight: FontWeight.bold)),
        _dropdown('District', _districts, _presDistrictId, (v) async {
          setState(() {
            _presDistrictId = v;
            _presUpazilaId = null;
          });
          if (v != null) {
            _presentUpazilas = await ref.read(metaRepositoryProvider).upazilas(v);
            setState(() {});
          }
        }),
        _dropdown('Upazila', _presentUpazilas, _presUpazilaId, (v) => setState(() => _presUpazilaId = v)),
        _field(_presAddress, 'Address'),
      ],
    );
  }

  Widget _questionsStep() {
    if (_questionSets.isEmpty) {
      return const Center(child: Text('No dynamic questions configured'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final set in _questionSets) ...[
          Text((set as Map)['title']?.toString() ?? '', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final q in _questionsForSet(set['id'] as int)) _questionField(q as Map<String, dynamic>),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _questionField(Map<String, dynamic> question) {
    final id = question['id'] as int;
    final type = question['type'] as int? ?? 1;
    final label = question['question']?.toString() ?? '';

    if (type == 2) {
      final opts = _optionsForQuestion(id);
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<int>(
          value: _mcqSelections[id],
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          items: opts
              .map((o) => DropdownMenuItem<int>(
                    value: (o as Map)['id'] as int,
                    child: Text(o['option']?.toString() ?? o['option_bn']?.toString() ?? ''),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _mcqSelections[id] = v),
        ),
      );
    }

    _answerControllers.putIfAbsent(id, TextEditingController.new);
    final isLong = type == 3;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _answerControllers[id],
        maxLines: isLong ? 4 : 1,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _contactStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _field(_candidateName, 'Candidate Name'),
        _field(_contactNo, 'Contact No (optional)'),
        _field(_guardianMobile, 'Guardian Mobile'),
        _field(_relation, 'Relation with Guardian'),
        _field(_email, 'Email'),
        SwitchListTile(
          title: const Text('Show profile photo publicly'),
          value: _showImage,
          onChanged: (v) => setState(() => _showImage = v),
        ),
        const SizedBox(height: 8),
        if (_imagePath != null) Image.file(File(_imagePath!), height: 120, fit: BoxFit.cover),
        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo),
          label: const Text('Pick Photo'),
        ),
      ],
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List<dynamic> items,
    int? value,
    ValueChanged<int?> onChanged, {
    String labelKey = 'title',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: items
            .map((item) => DropdownMenuItem<int>(
                  value: (item as Map)['id'] as int,
                  child: Text(item[labelKey]?.toString() ?? item['title']?.toString() ?? ''),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
