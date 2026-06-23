import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/auth/change_password_screen.dart';
import 'package:getmarried/features/billing/billing_screen.dart';
import 'package:getmarried/features/chat/chats_screen.dart';
import 'package:getmarried/features/complaints/complaints_screen.dart';
import 'package:getmarried/features/meetings/meetings_screen.dart';
import 'package:getmarried/features/notifications/notifications_screen.dart';
import 'package:getmarried/features/phase3/consultants_screen.dart';
import 'package:getmarried/features/phase3/video_biodata_screen.dart';
import 'package:getmarried/features/phase3/wedding_services_screen.dart';
import 'package:getmarried/features/photo_access/photo_access_screen.dart';
import 'package:getmarried/features/profile/biodata_wizard_screen.dart';
import 'package:getmarried/features/profile/preferences_screen.dart';
import 'package:getmarried/features/profile/unlocked_screen.dart';
import 'package:getmarried/features/profile/verification_screen.dart';

class MoreMenuScreen extends ConsumerWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.more)),
      body: ListView(
        children: [
          _tile(context, Icons.notifications, l10n.notifications, unread.when(
            data: (c) => c > 0 ? Badge(label: Text('$c')) : null,
            loading: () => null,
            error: (_, _) => null,
          ), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
          _tile(context, Icons.chat, l10n.chats, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatsScreen()))),
          _tile(context, Icons.event, l10n.meetings, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MeetingsScreen()))),
          _tile(context, Icons.report, l10n.supportReports, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplaintsScreen()))),
          _tile(context, Icons.payment, l10n.billing, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()))),
          _tile(context, Icons.lock, l10n.changePassword, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()))),
          const Divider(),
          _tile(context, Icons.edit, l10n.editBiodata, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BiodataWizardScreen()))),
          _tile(context, Icons.verified, l10n.verification, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationScreen()))),
          _tile(context, Icons.tune, l10n.preferences, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PreferencesScreen()))),
          _tile(context, Icons.lock_open, l10n.unlockedContacts, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UnlockedScreen()))),
          _tile(context, Icons.photo, l10n.photoAccess, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoAccessScreen()))),
          const Divider(),
          _tile(context, Icons.videocam, l10n.videoBiodata, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoBiodataScreen()))),
          _tile(context, Icons.support_agent, l10n.consultants, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsultantsScreen()))),
          _tile(context, Icons.celebration, l10n.weddingServices, null, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeddingServicesScreen()))),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, Widget? trailing, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
