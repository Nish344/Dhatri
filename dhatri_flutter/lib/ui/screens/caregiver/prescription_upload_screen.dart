import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../components/dhatri_buttons.dart';
import 'prescription_review_screen.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  State<PrescriptionUploadScreen> createState() => _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen> {
  bool _isReading = false;
  int _readingStep = 0;

  void _startExtraction() {
    setState(() {
      _isReading = true;
      _readingStep = 1;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _readingStep = 2);
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _readingStep = 3);
    });

    Future.delayed(const Duration(milliseconds: 2100), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PrescriptionReviewScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Prescription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_isReading) ...[
              // Upload Area Card (Guide §15)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Take a photo of the prescription',
                      style: AppTypography.cardTitle.copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dhatri\'s AI will extract medicine names, dosages, and daily reminder times.',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Sample Prescriptions Available for Demo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.document_scanner_rounded, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Demo Sample Ready: Dr. S.K. Verma Clinic (Metformin, Amlodipine & Atorvastatin)',
                        style: AppTypography.supporting.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              DhatriPrimaryButton(
                label: 'Take Photo (Demo Rx)',
                icon: Icons.camera_alt_rounded,
                onPressed: _startExtraction,
                height: 56,
              ),
              const SizedBox(height: 14),
              DhatriSecondaryButton(
                label: 'Choose From Gallery',
                icon: Icons.photo_library_outlined,
                onPressed: _startExtraction,
                height: 52,
              ),
            ] else ...[
              // Reading & Extraction State (Guide §15)
              const SizedBox(height: 40),
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Reading Prescription...',
                style: AppTypography.displayLarge.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'AI is analyzing handwritten timings and drug schedules',
                style: AppTypography.supporting,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _extractionStep(
                title: 'Extracting medicine names & strengths',
                isDone: _readingStep >= 1,
              ),
              const SizedBox(height: 14),
              _extractionStep(
                title: 'Mapping frequencies to IST reminder times',
                isDone: _readingStep >= 2,
              ),
              const SizedBox(height: 14),
              _extractionStep(
                title: 'Preparing draft for your review',
                isDone: _readingStep >= 3,
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _extractionStep({required String title, required bool isDone}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDone ? AppColors.successBg : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? AppColors.successBorder : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: isDone ? AppColors.success : AppColors.textMuted,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                color: isDone ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

