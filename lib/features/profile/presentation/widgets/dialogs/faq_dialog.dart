import 'package:file_pod/theme.dart';
import 'package:flutter/material.dart';

class FaqDialog extends StatelessWidget {
  const FaqDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FAQ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  _FaqItem(
                    question: 'How do I upload a file?',
                    answer:
                        'Tap the "+" button at the bottom of the screen and select "Upload File". You can choose any file from your device.',
                  ),
                  _FaqItem(
                    question: 'Can I create folders?',
                    answer:
                        'Yes, tap the "+" button and select "Create Folder". Give it a name and organize your files.',
                  ),
                  _FaqItem(
                    question: 'How do I share a file?',
                    answer:
                        'Tap the three dots on a file item and select "Share". You can set an optional password for secure sharing.',
                  ),
                  _FaqItem(
                    question: 'Is my data secure?',
                    answer:
                        'Yes, we use secure storage and industry-standard encryption to keep your files safe.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(answer, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }
}
