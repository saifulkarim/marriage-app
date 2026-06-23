import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:open_filex/open_filex.dart';

Future<void> downloadAndOpenBiodataPdf({
  required WidgetRef ref,
  required BuildContext context,
  required String slug,
}) async {
  try {
    final path = await ref.read(profileRepositoryProvider).downloadBiodataPdf(slug);
    if (!context.mounted) return;
    final result = await OpenFilex.open(path);
    if (!context.mounted) return;
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved: $path')),
      );
    }
  } on ApiException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
