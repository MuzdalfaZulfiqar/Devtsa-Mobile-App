// lib/screens/onboarding/onboarding_screen.dart
import 'dart:convert';

import 'package:devsta_mobileapp/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../config/backend_config.dart';
import '../../services/auth_api.dart';
import '../../services/onboarding_api.dart';
import '../../state/app_state.dart';
import '../../models/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- controllers: account ---
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // --- controllers: profile/onboarding ---
  final _phoneCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();

  // experience / role / skills options from backend
  List<_OptionItem> _expLevels = [];
  List<_OptionItem> _roleOptions = [];
  List<_OptionItem> _skillOptions = [];

  String? _selectedExpKey;
  String? _selectedRoleKey;
  bool _loadingOptions = true;
  bool _loadingSubmit = false;

  // custom role
  final _customRoleCtrl = TextEditingController();
  bool _showCustomRoleInput = false;

  // skills multi-select
  final Set<String> _selectedSkillKeys = {};
  final _customSkillCtrl = TextEditingController();
  bool _showCustomSkillInput = false;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _githubCtrl.dispose();
    _customRoleCtrl.dispose();
    _customSkillCtrl.dispose();
    super.dispose();
  }

  // ------------------- LOAD META OPTIONS -------------------

  Future<void> _loadOptions() async {
    try {
      final base = BackendConfig.baseUrl;
      final expRes =
          await http.get(Uri.parse('$base/api/experience/levels'));
      final roleRes =
          await http.get(Uri.parse('$base/api/experience/roles'));
      final skillsRes = await http.get(Uri.parse('$base/api/skills'));

      if (expRes.statusCode >= 200 && expRes.statusCode < 300) {
        final List<dynamic> list = jsonDecode(expRes.body);
        _expLevels = list
            .map((e) => _OptionItem(
                  key: e['key'].toString(),
                  label: e['label'].toString(),
                ))
            .toList();
      }

      if (roleRes.statusCode >= 200 && roleRes.statusCode < 300) {
        final List<dynamic> list = jsonDecode(roleRes.body);
        _roleOptions = list
            .map((e) => _OptionItem(
                  key: e['key'].toString(),
                  label: e['label'].toString(),
                ))
            .toList();

        // Ensure "Other" exists
        if (!_roleOptions.any((r) => r.key == 'other')) {
          _roleOptions.add(
            const _OptionItem(key: 'other', label: 'Other'),
          );
        }
      }

      if (skillsRes.statusCode >= 200 && skillsRes.statusCode < 300) {
        final List<dynamic> list = jsonDecode(skillsRes.body);
        _skillOptions = list
            .map((e) => _OptionItem(
                  key: e['key'].toString(),
                  label: e['label'].toString(),
                ))
            .toList();

        // Add "Other" as a special chip option
        if (!_skillOptions.any((s) => s.key == 'other')) {
          _skillOptions.add(
            const _OptionItem(key: 'other', label: 'Other'),
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to load onboarding meta options: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingOptions = false;
        });
      }
    }
  }

  // ------------------- HELPERS -------------------

  String _slugify(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9+.# ]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');
  }

  void _toggleSkill(String key) {
    setState(() {
      if (_selectedSkillKeys.contains(key)) {
        _selectedSkillKeys.remove(key);
      } else {
        _selectedSkillKeys.add(key);
      }

      // show/hide "Other" skill input
      _showCustomSkillInput = _selectedSkillKeys.contains('other');
    });
  }

  Future<void> _addCustomRole() async {
    final label = _customRoleCtrl.text.trim();
    if (label.isEmpty) return;

    final key = 'custom:${_slugify(label)}';

    setState(() {
      if (!_roleOptions.any((o) => o.key == key)) {
        _roleOptions.add(_OptionItem(key: key, label: label));
      }
      _selectedRoleKey = key;
      _showCustomRoleInput = false;
      _customRoleCtrl.clear();
    });
  }

  Future<void> _addCustomSkill() async {
    final label = _customSkillCtrl.text.trim();
    if (label.isEmpty) return;

    final key = 'custom:${_slugify(label)}';

    setState(() {
      if (!_skillOptions.any((o) => o.key == key)) {
        _skillOptions.add(_OptionItem(key: key, label: label));
      }
      _selectedSkillKeys.remove('other');
      _selectedSkillKeys.add(key);

      _showCustomSkillInput = false;
      _customSkillCtrl.clear();
    });
  }

  // ------------------- SUBMIT FLOW -------------------

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedExpKey == null || _selectedExpKey!.isEmpty) {
      _showSnack('Please select your experience level');
      return;
    }
    if (_selectedRoleKey == null || _selectedRoleKey!.isEmpty) {
      _showSnack('Please select your primary role');
      return;
    }
    if (_selectedRoleKey == 'other') {
      _showSnack(
          'Please add a custom role instead of leaving "Other" selected.');
      return;
    }

    final filteredSkills = _selectedSkillKeys
        .where((k) => k != 'other')
        .toList(growable: false);

    if (filteredSkills.isEmpty) {
      _showSnack('Please select at least one skill');
      return;
    }

    setState(() {
      _loadingSubmit = true;
    });

    try {
      // 1) Signup
      final signupRes = await AuthApi().signup(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      final token = signupRes['token'] as String;
      final userJson = signupRes['user'] as Map<String, dynamic>;

      // 2) Store session (AppState)
      AppState().setSessionFromBackend(
        userJson: userJson,
        token: token,
      );

      // 3) Prepare OnboardingData
      final onboarding = OnboardingData(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        experienceLevel: _selectedExpKey,
        primaryRole: _selectedRoleKey,
        topSkills: filteredSkills,
        githubUrl:
            _githubCtrl.text.trim().isEmpty ? null : _githubCtrl.text.trim(),
        resumeUrl: null,
        onboardingCompleted: true,
      );

      // 4) Save onboarding (complete=true)
      await OnboardingApi().saveOnboarding(onboarding, complete: true);
// refresh user from backend
await Provider.of<AuthProvider>(context, listen: false).fetchCurrentUser();
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/dashboard', (r) => false);
      }
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _loadingSubmit = false;
        });
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ------------------- BUILD -------------------

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF086972); // DevSta primary

    // Apply Poppins to the whole screen
    final baseTheme = Theme.of(context);
    final poppinsTheme = baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );

    return Theme(
      data: poppinsTheme,
      child: Scaffold(
        backgroundColor: primary, // whole page primary
        appBar: AppBar(
          title: const Text(
            'Create your DevSta account',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primary,
          centerTitle: true,
          elevation: 0.5,
        ),
        body: SafeArea(
          child: _loadingOptions
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------- Account section ----------
                          Text(
                            'Account Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _nameCtrl,
                            label: 'Full Name',
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _emailCtrl,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _passwordCtrl,
                            label: 'Password',
                            obscureText: true,
                            required: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              if (v.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),
                          // ---------- Profile section ----------
                          Text(
                            'Profile information',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _phoneCtrl,
                            label: 'Phone (optional)',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),

                          // Experience dropdown
                          Text(
                            'Experience Level *',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _selectedExpKey,
                            decoration: _dropdownDecoration(),
                            items: _expLevels
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e.key,
                                    child: Text(e.label),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedExpKey = val;
                              });
                            },
                            validator: (val) =>
                                (val == null || val.isEmpty) ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Role dropdown + custom
                          Text(
                            'Primary Role *',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _selectedRoleKey,
                            decoration: _dropdownDecoration(),
                            items: _roleOptions
                                .map(
                                  (r) => DropdownMenuItem<String>(
                                    value: r.key,
                                    child: Text(r.label),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedRoleKey = val;
                                _showCustomRoleInput = val == 'other';
                              });
                            },
                            validator: (val) =>
                                (val == null || val.isEmpty) ? 'Required' : null,
                          ),
                          if (_showCustomRoleInput) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _customRoleCtrl,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Custom role (e.g. SRE, Data Eng)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _addCustomRole,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 24),

                          // ---------- Skills section ----------
                          Text(
                            'Top Skills (choose at least one)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _skillOptions.map((s) {
                              final selected =
                                  _selectedSkillKeys.contains(s.key);
                              return FilterChip(
                                label: Text(s.label),
                                selected: selected,
                                onSelected: (_) {
                                  if (s.key == 'other') {
                                    setState(() {
                                      if (_selectedSkillKeys
                                          .contains('other')) {
                                        _selectedSkillKeys.remove('other');
                                        _showCustomSkillInput = false;
                                      } else {
                                        _selectedSkillKeys.add('other');
                                        _showCustomSkillInput = true;
                                      }
                                    });
                                  } else {
                                    _toggleSkill(s.key);
                                  }
                                },
                                selectedColor: primary.withOpacity(0.2),
                                checkmarkColor: primary,
                              );
                            }).toList(),
                          ),

                          if (_showCustomSkillInput) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _customSkillCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Custom skill (e.g. GraphQL)',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _addCustomSkill,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 24),

                          Text(
                            'GitHub (optional)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          _buildTextField(
                            controller: _githubCtrl,
                            label: 'GitHub profile URL',
                          ),

                          const SizedBox(height: 32),

                          // ---------- Submit button ----------
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _loadingSubmit ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _loadingSubmit
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Create account & continue',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        border: const OutlineInputBorder(),
      ),
      validator: validator ??
          (required
              ? (v) => (v == null || v.trim().isEmpty)
                  ? '$label is required'
                  : null
              : null),
    );
  }
}

class _OptionItem {
  final String key;
  final String label;

  const _OptionItem({
    required this.key,
    required this.label,
  });
}
