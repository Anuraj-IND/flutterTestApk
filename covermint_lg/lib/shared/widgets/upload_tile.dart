import 'package:flutter/material.dart';

import '../../core/theme.dart';

class UploadTile extends StatelessWidget {
  final String label;
  final String? pickedName;
  final String? pickedSize;
  final bool uploaded;
  final bool busy;
  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final VoidCallback onPdf;

  const UploadTile({
    super.key,
    required this.label,
    this.pickedName,
    this.pickedSize,
    this.uploaded = false,
    this.busy = false,
    required this.onGallery,
    required this.onCamera,
    required this.onPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: uploaded
            ? CovermintTheme.approvedGreen.withValues(alpha: 0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: uploaded
              ? CovermintTheme.approvedGreen.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: uploaded
                      ? CovermintTheme.approvedGreen.withValues(alpha: 0.1)
                      : CovermintTheme.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  uploaded ? Icons.check_circle : Icons.description_outlined,
                  size: 18,
                  color: uploaded
                      ? CovermintTheme.approvedGreen
                      : CovermintTheme.brandPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (uploaded)
                const Icon(Icons.check_circle,
                    color: CovermintTheme.approvedGreen, size: 20)
              else if (pickedName != null)
                const Icon(Icons.insert_drive_file,
                    color: CovermintTheme.brandAccent, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            uploaded
                ? 'Uploaded'
                : (pickedName == null
                    ? 'Not selected'
                    : '$pickedName${pickedSize == null ? '' : ' ($pickedSize)'}'),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
          if (!uploaded) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _buildActionBtn('Gallery', Icons.photo_library, onGallery),
                const SizedBox(width: 8),
                _buildActionBtn('Camera', Icons.photo_camera, onCamera),
                const SizedBox(width: 8),
                _buildActionBtn('PDF', Icons.picture_as_pdf, onPdf),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionBtn(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: busy ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: CovermintTheme.brandPrimary),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: CovermintTheme.brandPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
