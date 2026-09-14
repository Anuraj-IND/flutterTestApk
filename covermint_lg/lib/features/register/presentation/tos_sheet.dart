import 'package:flutter/material.dart';

import '../../register/data/covermint_repository.dart';
import '../../../shared/widgets/feedback.dart';
import '../../../core/theme.dart';

class TosSheet extends StatefulWidget {
  final CovermintRepository repository;
  final String draftId;
  final String name;

  const TosSheet({
    super.key,
    required this.repository,
    required this.draftId,
    required this.name,
  });

  static Future<String?> open(
    BuildContext context, {
    required CovermintRepository repository,
    required String draftId,
    required String name,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TosSheet(
        repository: repository,
        draftId: draftId,
        name: name,
      ),
    );
  }

  @override
  State<TosSheet> createState() => _TosSheetState();
}

class _TosSheetState extends State<TosSheet> {
  late final Future<Map<String, dynamic>> _tosFuture;
  bool _scrolledToBottom = false;
  bool _accepting = false;

  @override
  void initState() {
    super.initState();
    _tosFuture = widget.repository.getTos();
  }

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.maxScrollExtent <= 0) {
      if (!_scrolledToBottom) setState(() => _scrolledToBottom = true);
      return false;
    }
    final reached = n.metrics.pixels >= n.metrics.maxScrollExtent - 8;
    if (reached && !_scrolledToBottom) {
      setState(() => _scrolledToBottom = true);
    }
    return false;
  }

  Future<void> _accept(String version) async {
    setState(() => _accepting = true);
    try {
      await widget.repository.tosAccept(
        draftId: widget.draftId,
        name: widget.name,
        tosVersion: version,
      );
      if (mounted) Navigator.of(context).pop(version);
    } catch (e) {
      if (mounted) {
        setState(() => _accepting = false);
        showApiError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final stamp =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _tosFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: CovermintTheme.rejectedRed, size: 48),
                      const SizedBox(height: 16),
                      const Text('Could not load the Terms of Service.'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
              final tos = snap.data!;
              final version = '${tos['version'] ?? 'latest'}';
              final text = '${tos['text'] ?? ''}';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'I, ${widget.name}, on $stamp',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Terms of Service (v$version)',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Scroll to the bottom to accept',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: _onScroll,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Text(text),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: (!_scrolledToBottom || _accepting)
                          ? null
                          : () => _accept(version),
                      style: FilledButton.styleFrom(
                        backgroundColor: CovermintTheme.brandPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _accepting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              _scrolledToBottom
                                  ? 'Accept Terms'
                                  : 'Scroll to bottom to accept',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
