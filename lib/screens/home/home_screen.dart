import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/trek_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning 👋',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready for your next adventure?',
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.secondaryText,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Search treks',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // 3. Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: SectionHeader(title: 'Quick Actions'),
              ),
              const SizedBox(height: AppSpacing.md),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Row(
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.explore_outlined,
                        label: 'Explore',
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.add_location_alt_outlined,
                        label: 'Plan a Trek',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // 4. Recommended for You
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: SectionHeader(title: 'Recommended for You'),
              ),
              const SizedBox(height: AppSpacing.md),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: FeaturedTrekCard(
                  name: 'Rajgad',
                  location: 'Pune, Maharashtra',
                  difficulty: 'Medium',
                  distance: '5.0 km',
                  rating: 4.8,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // 5. Popular Treks
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: SectionHeader(title: 'Popular Treks'),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 185,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  children: const [
                    CompactTrekCard(
                      name: 'Lohagad',
                      difficulty: 'Easy',
                      locationOrDistance: 'Lonavala • 3.5 km',
                    ),
                    SizedBox(width: AppSpacing.md),
                    CompactTrekCard(
                      name: 'Visapur',
                      difficulty: 'Easy',
                      locationOrDistance: 'Malavli • 4.2 km',
                    ),
                    SizedBox(width: AppSpacing.md),
                    CompactTrekCard(
                      name: 'Harishchandragad',
                      difficulty: 'Hard',
                      locationOrDistance: 'Ahmednagar • 8.5 km',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
