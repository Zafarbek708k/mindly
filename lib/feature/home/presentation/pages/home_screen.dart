import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindly/core/const/app_icons.dart';
import 'package:mindly/core/const/static_values.dart';
import 'package:mindly/feature/common/animateed_button.dart';
import 'package:mindly/route/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _mathQuizId = 'math-basics';

  void _startQuiz(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.quizPlay, arguments: _mathQuizId);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.md,
            AppSpacing.pagePadding,
            AppSpacing.huge,
          ),
          children: [
            const _Header(),
            const SizedBox(height: AppSpacing.xl),
            _DailyChallengeCard(onStart: () => _startQuiz(context)),
            const SizedBox(height: AppSpacing.xl),
            Text('Categories', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.md),
            const _CategoriesRow(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Featured quizzes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.md),
            _FeaturedTile(
              icon: AppIcons.lineChart,
              title: 'Simple Math Quiz',
              subtitle: '10 questions · 20 min',
              color: scheme.primary,
              onTap: () => _startQuiz(context),
            ),
            const SizedBox(height: AppSpacing.md),
            _FeaturedTile(
              icon: AppIcons.earth,
              title: 'Geography Basics',
              subtitle: 'Coming soon',
              color: const Color(0xFF22A45D),
            ),
            const SizedBox(height: AppSpacing.md),
            _FeaturedTile(
              icon: AppIcons.pacman,
              title: 'Retro Games Trivia',
              subtitle: 'Coming soon',
              color: const Color(0xFFF08C00),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: scheme.primary.withValues(alpha: 0.12),
          child: SvgPicture.asset(
            AppIcons.smile,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good day 👋', style: TextStyle(color: scheme.onSurfaceVariant)),
              Text(
                'Mindly Player',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedButton(
      onTap: onStart,
      scaleValue: 0.98,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scheme.surface, scheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
          boxShadow: [
            BoxShadow(color: scheme.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily challenge',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Simple Math Quiz',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: Colors.blue, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          'Start quiz',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppIcons.flag,
              width: 56,
              height: 56,
              colorFilter: const ColorFilter.mode(Colors.white24, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  const _CategoriesRow();

  static const _categories = [
    (AppIcons.lineChart, 'Math'),
    (AppIcons.earth, 'Geography'),
    (AppIcons.reactor, 'Science'),
    (AppIcons.pacman, 'Games'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (final (icon, label) in _categories)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: SvgPicture.asset(
                      icon,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturedTile extends StatelessWidget {
  const _FeaturedTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    return AnimatedButton(
      onTap: onTap ?? () {},
      isDisabled: !enabled,
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
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: SvgPicture.asset(
                icon,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(subtitle, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
