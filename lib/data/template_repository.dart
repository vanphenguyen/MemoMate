import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/reminder.dart';

/// Loads the reminder library from `assets/templates/`.
class TemplateRepository {
  TemplateRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const _dir = 'assets/templates';

  final AssetBundle _bundle;

  Future<List<TemplateGroup>> loadAll() async {
    final index =
        jsonDecode(await _bundle.loadString('$_dir/index.json')) as Map<String, dynamic>;
    return [
      for (final id in index['groups'] as List)
        TemplateGroup.fromJson(
          jsonDecode(await _bundle.loadString('$_dir/$id.json')) as Map<String, dynamic>,
        ),
    ];
  }
}
