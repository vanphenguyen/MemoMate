import 'package:flutter/material.dart';

import '../app.dart';
import '../texts.dart';

/// The small caption and big title at the top of each tab, with the
/// language button on the right.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.caption, required this.title});

  final String caption;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppScope.textsOf(context).l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caption,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          key: const ValueKey('language-button'),
          tooltip: l10n.languageTitle,
          icon: const Icon(Icons.language),
          onPressed: () => showLanguagePicker(context),
        ),
      ],
    );
  }
}

/// Opens the list of languages. The first row follows the phone's language.
Future<void> showLanguagePicker(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final controller = AppScope.of(context);
        final l10n = AppScope.textsOf(context).l10n;
        final chosen = controller.languageChoice;

        Widget row(String? code, String label) => ListTile(
          key: ValueKey('language-${code ?? 'phone'}'),
          title: Text(label),
          trailing: chosen == code ? const Icon(Icons.check) : null,
          selected: chosen == code,
          onTap: () {
            controller.chooseLanguage(code);
            Navigator.of(context).pop();
          },
        );

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(
                      l10n.languageTitle,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  row(null, l10n.languageFollowPhone),
                  const Divider(height: 1),
                  for (final entry in languageNames.entries)
                    row(entry.key, entry.value),
                ],
              ),
            ),
          ),
        );
      },
    );
