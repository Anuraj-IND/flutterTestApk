import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/theme.dart';
import '../../../core/validators.dart';
import '../../../shared/widgets/feedback.dart';
import '../../../shared/widgets/ifsc_field.dart';
import '../../../shared/widgets/upload_tile.dart';
import '../data/covermint_repository.dart';
import 'tos_sheet.dart';

const List<Map<String, String>> _docFields = [
  {'key': 'aadhaar_front', 'label': 'Aadhaar — Front'},
  {'key': 'aadhaar_back', 'label': 'Aadhaar — Back'},
  {'key': 'pan_card', 'label': 'PAN Card'},
  {'key': 'cheque', 'label': 'Cancelled Cheque'},
];

class _DocPick {
  final String path;
  final String name;
  final String size;
  _DocPick({required this.path, required this.name, required this.size});
}

class Step2Screen extends StatefulWidget {
  final CovermintRepository repository;
  final String draftId;

  const Step2Screen({
    super.key,
    required this.repository,
    required this.draftId,
  });

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final _imagePicker = ImagePicker();

  Map<String, dynamic>? _echo;
  String? _echoError;
  bool _loadingEcho = true;

  bool _phoneVerified = false;
  String _echoName = '';
  final Set<String> _uploadedDocs = {};
  bool _tosAccepted = false;
  String? _tosVersion;

  final _addressAadhaar = TextEditingController();
  final _pincode = TextEditingController();
  final _currentAddress = TextEditingController();
  final _rmName = TextEditingController();
  final _rmNumber = TextEditingController();
  final _aadhaarNo = TextEditingController();
  final _bankName = TextEditingController();
  final _branch = TextEditingController();
  final _ifsc = TextEditingController();
  final _accountNo = TextEditingController();
  final _bankAddress = TextEditingController();

  bool _saving = false;
  bool _uploadingDocs = false;
  bool _submitting = false;
  bool _verifyingIfsc = false;
  bool? _ifscValid;
  String? _ifscMessage;

  final Map<String, _DocPick> _picks = {};
  String? _banner;

  @override
  void initState() {
    super.initState();
    _loadEcho();
  }

  @override
  void dispose() {
    _addressAadhaar.dispose();
    _pincode.dispose();
    _currentAddress.dispose();
    _rmName.dispose();
    _rmNumber.dispose();
    _aadhaarNo.dispose();
    _bankName.dispose();
    _branch.dispose();
    _ifsc.dispose();
    _accountNo.dispose();
    _bankAddress.dispose();
    super.dispose();
  }

  Future<void> _loadEcho() async {
    setState(() {
      _loadingEcho = true;
      _echoError = null;
    });
    try {
      final echo = await widget.repository.getDraft(widget.draftId);
      if (!mounted) return;
      setState(() {
        _echo = echo;
        _phoneVerified = echo['phone_verified'] == true;
        _echoName = '${echo['name'] ?? ''}';
        _uploadedDocs
          ..clear()
          ..addAll(_docsFromEcho(echo['documents']));
        final tos = echo['tos'];
        if (tos is Map) {
          _tosAccepted = tos['accepted'] == true;
          _tosVersion =
              tos['version'] == null ? null : '${tos['version']}';
        } else if (tos == true) {
          _tosAccepted = true;
        }
        _setIfEmpty(_addressAadhaar, echo['address_aadhaar']);
        _setIfEmpty(_pincode, echo['pincode']);
        _setIfEmpty(_currentAddress, echo['current_address']);
        _setIfEmpty(_rmName, echo['rm_name']);
        _setIfEmpty(_rmNumber, echo['rm_number'] ?? echo['rm_phone']);
        _setIfEmpty(_aadhaarNo, echo['aadhaar_no']);
        final banking = echo['banking'];
        if (banking is Map) {
          _setIfEmpty(_bankName, banking['bank_name']);
          _setIfEmpty(_branch, banking['branch']);
          _setIfEmpty(_ifsc, banking['ifsc']);
          _setIfEmpty(_accountNo, banking['account_number']);
          _setIfEmpty(_bankAddress, banking['bank_address']);
          if (_ifsc.text.isNotEmpty) {
            _ifscValid = true;
            _ifscMessage = 'Saved earlier — re-verified on submit.';
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _echoError = e is ApiException ? e.message : e.toString();
        });
      }
    } finally {
      if (mounted) setState(() => _loadingEcho = false);
    }
  }

  void _setIfEmpty(TextEditingController c, Object? value) {
    if (c.text.isEmpty && value != null && '$value'.isNotEmpty) {
      c.text = '$value';
    }
  }

  static Set<String> _docsFromEcho(Object? documents) {
    const known = {'aadhaar_front', 'aadhaar_back', 'pan_card', 'cheque'};
    if (documents is Map) {
      return documents.keys.map((e) => '$e').where(known.contains).toSet();
    }
    if (documents is List) {
      final out = <String>{};
      for (final item in documents) {
        if (item is String && known.contains(item)) {
          out.add(item);
        } else if (item is Map) {
          for (final key in ['field', 'name', 'doc_type', 'type']) {
            final v = item[key];
            if (v is String && known.contains(v)) out.add(v);
          }
        }
      }
      return out;
    }
    return {};
  }

  Future<void> _verifyIfsc(String ifsc) async {
    final upper = ifsc.trim().toUpperCase();
    if (Validators.isDevMode && upper.startsWith('TEST') && upper.length >= 6) {
      setState(() {
        _ifscValid = true;
        _ifscMessage = 'Dev mode: TEST IFSC accepted.';
        _bankName.text = 'Test Bank';
        _branch.text = 'Test Branch';
        _bankAddress.text = 'Test Address, Dev City';
      });
      return;
    }
    setState(() {
      _verifyingIfsc = true;
      _ifscValid = null;
      _ifscMessage = null;
    });
    try {
      final res = await widget.repository.verifyIfsc(ifsc);
      if (!mounted) return;
      final verified = res['verified'] == true;
      setState(() {
        _verifyingIfsc = false;
        _ifscValid = verified;
        _ifscMessage = verified
            ? 'Valid IFSC — details autofilled.'
            : 'Invalid IFSC — check and retry.';
        if (verified) {
          _setOrReplace(_bankName, res['bank']);
          _setOrReplace(_branch, res['branch']);
          _setOrReplace(_bankAddress, res['address']);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _verifyingIfsc = false;
          _ifscValid = false;
          _ifscMessage = e is ApiException ? e.message : 'IFSC check failed.';
        });
      }
    }
  }

  void _setOrReplace(TextEditingController c, Object? value) {
    if (value != null && '$value'.isNotEmpty) c.text = '$value';
  }

  bool get _detailsValid =>
      Validators.required(_addressAadhaar.text) == null &&
      Validators.pincode(_pincode.text) == null &&
      Validators.required(_currentAddress.text, 'Current address') == null &&
      Validators.required(_bankName.text, 'Bank name') == null &&
      Validators.ifsc(_ifsc.text) == null &&
      Validators.required(_accountNo.text, 'Account number') == null;

  Future<void> _saveDetails() async {
    if (!_detailsValid) {
      setState(() => _banner = 'Fill address + banking correctly first.');
      return;
    }
    if (_ifscValid != true) {
      setState(() => _banner = 'Verify the IFSC before saving.');
      return;
    }
    setState(() {
      _saving = true;
      _banner = null;
    });
    try {
      await widget.repository.patchDraft(widget.draftId, {
        'address_aadhaar': _addressAadhaar.text.trim(),
        'pincode': _pincode.text.trim(),
        'current_address': _currentAddress.text.trim(),
        'rm_name': _rmName.text.trim(),
        'rm_number': _rmNumber.text.trim(),
        if (_aadhaarNo.text.trim().isNotEmpty)
          'aadhaar_no': _aadhaarNo.text.trim(),
        'banking': {
          'bank_name': _bankName.text.trim(),
          'branch': _branch.text.trim(),
          'ifsc': _ifsc.text.trim().toUpperCase(),
          'account_number': _accountNo.text.trim(),
          'bank_address': _bankAddress.text.trim(),
        },
      });
      if (mounted) showOk(context, 'Details saved.');
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pick(
    String field,
    Future<String?> Function() picker,
  ) async {
    String? path;
    try {
      path = await picker();
    } catch (e) {
      if (mounted) {
        showOk(context,
            'Gallery/camera is unavailable here — use the PDF option.');
      }
      return;
    }
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (!file.existsSync()) return;
    final bytes = file.lengthSync();
    if (bytes > Validators.maxFileBytes) {
      if (mounted) showOk(context, 'File must be 5 MB or less.');
      return;
    }
    if (!mounted) return;
    setState(() {
      _picks[field] = _DocPick(
        path: path!,
        name: path.split(Platform.pathSeparator).last,
        size: _humanSize(bytes),
      );
    });
  }

  static String _humanSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<String?> _pickImage(ImageSource source) async {
    final x = await _imagePicker.pickImage(source: source, imageQuality: 85);
    return x?.path;
  }

  Future<String?> _pickPdf() async {
    final res = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    return res?.files.single.path;
  }

  Future<void> _uploadDocs() async {
    if (_picks.isEmpty) {
      setState(() => _banner = 'Pick at least one document first.');
      return;
    }
    setState(() {
      _uploadingDocs = true;
      _banner = null;
    });
    try {
      await widget.repository.uploadDocs(
        widget.draftId,
        {for (final e in _picks.entries) e.key: e.value.path},
      );
      if (!mounted) return;
      setState(() {
        _uploadedDocs.addAll(_picks.keys);
        _picks.clear();
      });
      showOk(context, 'Documents uploaded.');
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _uploadingDocs = false);
    }
  }

  Future<void> _openTos() async {
    final version = await TosSheet.open(
      context,
      repository: widget.repository,
      draftId: widget.draftId,
      name: _echoName.isEmpty ? 'Lead Generator' : _echoName,
    );
    if (version != null && mounted) {
      setState(() {
        _tosAccepted = true;
        _tosVersion = version;
      });
      showOk(context, 'Terms accepted.');
    }
  }

  bool get _canSubmit =>
      _phoneVerified &&
      _detailsValid &&
      _ifscValid == true &&
      _docFields.every((d) => _uploadedDocs.contains(d['key'])) &&
      _tosAccepted &&
      !_submitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _submitting = true;
      _banner = null;
    });
    try {
      final res = await widget.repository.submit(widget.draftId);
      if (!mounted) return;
      final seq = res['lg_seq'];
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: CovermintTheme.approvedGreen),
              SizedBox(width: 8),
              Text('Submitted!'),
            ],
          ),
          content: Text(
            'Your LG-ID is #$seq.\nVerification status: pending.\nPlease log in to continue.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go to login'),
            ),
          ],
        ),
      );
      if (mounted) context.go('/login');
    } catch (e) {
      if (mounted) {
        setState(() {
          _banner = e is ApiException ? e.message : e.toString();
        });
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loadingEcho
          ? Container(
              decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : _echoError != null
              ? Container(
                  decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white, size: 48),
                        const SizedBox(height: 16),
                        Text(_echoError!, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _loadEcho,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
                  child: SafeArea(
                    child: RefreshIndicator(
                      onRefresh: _loadEcho,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildStepIndicator(2, 2),
                            const SizedBox(height: 20),
                            if (_banner != null) _buildBanner(),
                            _buildEchoCard(),
                            const SizedBox(height: 16),
                            _buildSectionCard(
                              title: 'Address & RM',
                              icon: Icons.location_on_outlined,
                              children: [
                                _buildField(
                                    _addressAadhaar, 'Address as per Aadhaar *',
                                    maxLines: 2),
                                const SizedBox(height: 12),
                                _buildField(_pincode, 'Pincode *',
                                    keyboardType: TextInputType.number),
                                const SizedBox(height: 12),
                                _buildField(
                                    _currentAddress, 'Current address *',
                                    maxLines: 2),
                                const SizedBox(height: 12),
                                _buildField(_rmName, "RM name"),
                                const SizedBox(height: 12),
                                _buildField(_rmNumber, "RM phone",
                                    keyboardType: TextInputType.phone),
                                const SizedBox(height: 12),
                                _buildField(_aadhaarNo, 'Aadhaar number',
                                    keyboardType: TextInputType.number),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildSectionCard(
                              title: 'Banking Details',
                              icon: Icons.account_balance_outlined,
                              children: [
                                _buildField(_bankName, 'Bank name *'),
                                const SizedBox(height: 12),
                                _buildField(_branch, 'Branch'),
                                const SizedBox(height: 12),
                                IfscField(
                                  controller: _ifsc,
                                  onVerify: _verifyIfsc,
                                  verifying: _verifyingIfsc,
                                  valid: _ifscValid,
                                  message: _ifscMessage,
                                ),
                                const SizedBox(height: 12),
                                _buildField(_accountNo, 'Account number *',
                                    keyboardType: TextInputType.number),
                                const SizedBox(height: 12),
                                _buildField(_bankAddress, 'Bank address',
                                    maxLines: 2),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _saving ? null : _saveDetails,
                                    icon: _saving
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.save_outlined),
                                    label: Text(
                                        _saving ? 'Saving...' : 'Save Details'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildSectionCard(
                              title: 'Documents',
                              subtitle: 'Image or PDF, max 5 MB each',
                              icon: Icons.folder_outlined,
                              children: [
                                ..._docFields.map((d) {
                                  final key = d['key']!;
                                  final pick = _picks[key];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: UploadTile(
                                      label: d['label']!,
                                      pickedName: pick?.name,
                                      pickedSize: pick?.size,
                                      uploaded: _uploadedDocs.contains(key),
                                      busy: _uploadingDocs,
                                      onGallery: () => _pick(
                                          key,
                                          () => _pickImage(
                                              ImageSource.gallery)),
                                      onCamera: () => _pick(
                                          key,
                                          () =>
                                              _pickImage(ImageSource.camera)),
                                      onPdf: () => _pick(key, _pickPdf),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed:
                                        _uploadingDocs ? null : _uploadDocs,
                                    icon: _uploadingDocs
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.cloud_upload_outlined),
                                    label: Text(_uploadingDocs
                                        ? 'Uploading...'
                                        : 'Upload Documents'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildSectionCard(
                              title: 'Terms of Service',
                              icon: Icons.gavel_outlined,
                              children: [
                                CheckboxListTile(
                                  value: _tosAccepted,
                                  onChanged: (_) {
                                    if (!_tosAccepted) _openTos();
                                  },
                                  title: const Text(
                                      'I accept the Terms of Service'),
                                  subtitle: _tosVersion == null
                                      ? null
                                      : Text('Accepted v$_tosVersion'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSubmitButton(),
                            const SizedBox(height: 8),
                            Text(
                              _gateHint(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildStepIndicator(int current, int total) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i < current;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 5,
            decoration: BoxDecoration(
              color: isActive
                  ? CovermintTheme.brandAccent
                  : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CovermintTheme.rejectedRed.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CovermintTheme.rejectedRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: CovermintTheme.rejectedRed, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_banner!,
                style: const TextStyle(color: CovermintTheme.rejectedRed)),
          ),
        ],
      ),
    );
  }

  Widget _buildEchoCard() {
    final echo = _echo!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CovermintTheme.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: CovermintTheme.brandPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Step 1 Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Icon(
                _phoneVerified ? Icons.verified : Icons.pending,
                color: _phoneVerified
                    ? CovermintTheme.approvedGreen
                    : CovermintTheme.pendingAmber,
                size: 20,
              ),
            ],
          ),
          const Divider(height: 24),
          _echoRow('Name', echo['name']),
          _echoRow('Phone', echo['phone']),
          _echoRow('Email', echo['email'] ?? echo['mail']),
          _echoRow('PAN', echo['pan_no'] ?? echo['pan']),
        ],
      ),
    );
  }

  Widget _echoRow(String label, Object? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              '${value ?? '—'}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CovermintTheme.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: CovermintTheme.brandPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: _canSubmit ? _submit : null,
        icon: _submitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.send),
        label: Text(_submitting ? 'Submitting...' : 'Submit Registration'),
        style: FilledButton.styleFrom(
          backgroundColor: _canSubmit
              ? CovermintTheme.brandAccent
              : Colors.grey.shade400,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String _gateHint() {
    final missing = <String>[];
    if (!_phoneVerified) missing.add('phone verification');
    if (!_detailsValid) missing.add('address + banking');
    if (_ifscValid != true) missing.add('IFSC verify');
    final missingDocs = _docFields
        .where((d) => !_uploadedDocs.contains(d['key']))
        .map((d) => d['label']!);
    if (missingDocs.isNotEmpty) {
      missing.add('docs: ${missingDocs.join(', ')}');
    }
    if (!_tosAccepted) missing.add('TOS');
    if (missing.isEmpty) return 'All gates clear — ready to submit.';
    return 'Still needed: ${missing.join(' · ')}.';
  }
}
