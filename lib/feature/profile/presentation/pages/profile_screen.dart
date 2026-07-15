import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindly/core/const/app_icons.dart';
import 'package:mindly/core/const/static_values.dart';
import 'package:mindly/feature/common/animateed_button.dart';
import 'package:mindly/route/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(backgroundColor: scheme.surface, title: const Text('Profile'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          AppSpacing.huge,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: scheme.primary.withValues(alpha: 0.12),
                  child: SvgPicture.asset(
                    AppIcons.user,
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mindly Player',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text('player@mindly.app', style: TextStyle(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                AnimatedButton(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
                  child: Icon(Icons.edit_outlined, color: scheme.onSurfaceVariant, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (final (icon, value, label) in const [
                (AppIcons.trophy, '12', 'Quizzes'),
                (AppIcons.starBadge, '5 720', 'Points'),
                (AppIcons.crown, '#10', 'Rank'),
              ])
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          icon,
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                        ),
                        const SizedBox(height: 6),
                        Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        Text(label, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              children: [
                _SettingTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.settings),
                ),
                Divider(height: 1, indent: 56, color: scheme.outlineVariant),
                _SettingTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.notifications),
                ),
                Divider(height: 1, indent: 56, color: scheme.outlineVariant),
                const _SettingTile(icon: Icons.help_outline_rounded, label: 'Help & feedback'),
                Divider(height: 1, indent: 56, color: scheme.outlineVariant),
                const _SettingTile(icon: Icons.info_outline_rounded, label: 'About', trailing: '1.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.label, this.trailing, this.onTap});

  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap ?? () {},
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: scheme.primary),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) Text(trailing!, style: TextStyle(color: scheme.onSurfaceVariant)),
          Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant, size: 20),
        ],
      ),
    );
  }
}
