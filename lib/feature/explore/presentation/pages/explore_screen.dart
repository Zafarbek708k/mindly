import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindly/core/const/app_icons.dart';
import 'package:mindly/core/const/static_values.dart';
import 'package:mindly/feature/common/animateed_button.dart';
import 'package:mindly/route/app_router.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with ExploreMixin {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(backgroundColor: scheme.surface, title: const Text('Explore'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          AppSpacing.huge,
        ),
        children: [
          // Decorative search bar (mock).
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.sm),
                Text('Search quizzes...', style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Categories', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.4,
            children: [
              for (final (icon, label, count) in _categories)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: SvgPicture.asset(
                          icon,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('$count quizzes', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Popular quizzes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final (title, subtitle, isReal) in _popular) ...[
            AnimatedButton(
              onTap: isReal ? () => navigateToQuiz('math-basics') : () {},
              isDisabled: !isReal,
              scaleValue: 0.98,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.starBadge,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text(subtitle, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

mixin ExploreMixin on State<ExploreScreen> {
  void navigateToQuiz(String quizId) {
    Navigator.of(context).pushNamed(AppRoutes.quizPlay, arguments: quizId);
  }

  List<(String, String, int)> get _categories => const [
    (AppIcons.lineChart, 'Math', 12),
    (AppIcons.earth, 'Geography', 8),
    (AppIcons.reactor, 'Science', 15),
    (AppIcons.pacman, 'Games', 6),
    (AppIcons.wallet, 'Economics', 9),
    (AppIcons.flag, 'History', 11),
  ];

  List<(String, String, bool)> get _popular => const [
    ('Simple Math Quiz', '10 questions · 4.9 ★', true),
    ('World Capitals', '15 questions · 4.7 ★', false),
    ('Physics Basics', '12 questions · 4.6 ★', false),
    ('Famous Paintings', '8 questions · 4.5 ★', false),
  ];
}
