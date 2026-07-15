import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindly/core/const/app_icons.dart';
import 'package:mindly/core/const/static_values.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const _top3 = [
    (AppIcons.secondPlaceMedal, 'Aziza', 8420),
    (AppIcons.firstPlaceMedal, 'Timur', 9350),
    (AppIcons.thirdPlaceMedal, 'Diyor', 7980),
  ];

  static const _rest = [
    (4, 'Malika', 7420),
    (5, 'Sardor', 7100),
    (6, 'Nilufar', 6875),
    (7, 'Jasur', 6540),
    (8, 'Kamola', 6210),
    (9, 'Bekzod', 5980),
    (10, 'You', 5720),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        title: const Text('Leaderboard'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.pagePadding),
            child: SvgPicture.asset(
              AppIcons.crown,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Color(0xFFF08C00), BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          AppSpacing.huge,
        ),
        children: [
          // Period chips (mock — Global selected).
          Row(
            children: [
              for (final (label, selected) in const [('Global', true), ('Weekly', false), ('Monthly', false)]) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? scheme.primary : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Podium: 2nd, 1st, 3rd.
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final (i, (medal, name, score)) in _top3.indexed)
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        medal,
                        width: i == 1 ? 44 : 34,
                        height: i == 1 ? 44 : 34,
                        colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CircleAvatar(
                        radius: i == 1 ? 32 : 24,
                        backgroundColor: scheme.primary.withValues(alpha: 0.12),
                        child: Text(
                          name[0],
                          style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: i == 1 ? 22 : 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text('$score pts', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        height: i == 1 ? 64 : 40,
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: i == 1 ? 0.25 : 0.12),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMd)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final (rank, name, score) in _rest) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: name == 'You' ? scheme.primary.withValues(alpha: 0.08) : scheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: name == 'You' ? scheme.primary.withValues(alpha: 0.4) : scheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$rank',
                      style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w800),
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: scheme.surfaceContainerHighest,
                    child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Text(
                    '$score pts',
                    style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
