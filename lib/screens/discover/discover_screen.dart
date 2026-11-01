import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/trek_data.dart';
import '../../models/trek.dart';
import '../../widgets/trek_card.dart';

/// Distance filter options based on trek length.
enum DistanceFilter {
  under5('Under 5 km'),
  fiveToTen('5-10 km'),
  over10('Over 10 km');

  final String label;
  const DistanceFilter(this.label);

  bool matches(double km) => switch (this) {
        DistanceFilter.under5 => km < 5.0,
        DistanceFilter.fiveToTen => km >= 5.0 && km <= 10.0,
        DistanceFilter.over10 => km > 10.0,
      };
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  ExperienceLevel? _selectedExperience;
  DistanceFilter? _selectedDistance;
  TrekDifficulty? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isFiltered =>
      _searchQuery.trim().isNotEmpty ||
      _selectedExperience != null ||
      _selectedDistance != null ||
      _selectedDifficulty != null;

  List<Trek> get _filteredTreks {
    final query = _searchQuery.trim().toLowerCase();

    return mockTreks.where((trek) {
      // 1. Search filter: Case-insensitive substring match on trek name only
      if (query.isNotEmpty) {
        if (!trek.name.toLowerCase().contains(query)) {
          return false;
        }
      }

      // 2. Experience level filter
      if (_selectedExperience != null) {
        if (trek.experienceLevel != _selectedExperience) {
          return false;
        }
      }

      // 3. Distance filter (trek length distanceKm)
      if (_selectedDistance != null) {
        if (!_selectedDistance!.matches(trek.distanceKm)) {
          return false;
        }
      }

      // 4. Difficulty filter
      if (_selectedDifficulty != null) {
        if (trek.difficulty != _selectedDifficulty) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _showFilterSheet<T>({
    required String title,
    required List<_FilterOption<T>> options,
    required T? selectedValue,
    required ValueChanged<T?> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                        ),
                  ),
                ),
                const Divider(color: AppColors.border),
                ...options.map((option) {
                  final isCurrent = option.value == selectedValue;
                  return ListTile(
                    title: Text(
                      option.label,
                      style: TextStyle(
                        fontSize: AppTextSize.sm,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                        color: isCurrent
                            ? AppColors.primaryGreen
                            : AppColors.primaryText,
                      ),
                    ),
                    trailing: isCurrent
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primaryGreen,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onSelected(option.value);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openExperienceFilter() {
    _showFilterSheet<ExperienceLevel?>(
      title: 'Experience Level',
      selectedValue: _selectedExperience,
      options: const [
        _FilterOption(label: 'Any', value: null),
        _FilterOption(label: 'Beginner', value: ExperienceLevel.beginner),
        _FilterOption(label: 'Intermediate', value: ExperienceLevel.intermediate),
        _FilterOption(label: 'Advanced', value: ExperienceLevel.advanced),
      ],
      onSelected: (val) {
        setState(() {
          _selectedExperience = val;
        });
      },
    );
  }

  void _openDistanceFilter() {
    _showFilterSheet<DistanceFilter?>(
      title: 'Trek Distance',
      selectedValue: _selectedDistance,
      options: const [
        _FilterOption(label: 'Any', value: null),
        _FilterOption(label: 'Under 5 km', value: DistanceFilter.under5),
        _FilterOption(label: '5-10 km', value: DistanceFilter.fiveToTen),
        _FilterOption(label: 'Over 10 km', value: DistanceFilter.over10),
      ],
      onSelected: (val) {
        setState(() {
          _selectedDistance = val;
        });
      },
    );
  }

  void _openDifficultyFilter() {
    _showFilterSheet<TrekDifficulty?>(
      title: 'Difficulty',
      selectedValue: _selectedDifficulty,
      options: const [
        _FilterOption(label: 'Any', value: null),
        _FilterOption(label: 'Easy', value: TrekDifficulty.easy),
        _FilterOption(label: 'Moderate', value: TrekDifficulty.moderate),
        _FilterOption(label: 'Hard', value: TrekDifficulty.hard),
      ],
      onSelected: (val) {
        setState(() {
          _selectedDifficulty = val;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final results = _filteredTreks;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  'Discover',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                    letterSpacing: -0.3,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search treks',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.secondaryText,
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: AppColors.secondaryText,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // 3. Filter Pills
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _FilterPill(
                      label: _selectedExperience?.label ?? 'Experience',
                      isSelected: _selectedExperience != null,
                      onTap: _openExperienceFilter,
                    ),
                    _FilterPill(
                      label: _selectedDistance?.label ?? 'Distance',
                      isSelected: _selectedDistance != null,
                      onTap: _openDistanceFilter,
                    ),
                    _FilterPill(
                      label: _selectedDifficulty?.label ?? 'Difficulty',
                      isSelected: _selectedDifficulty != null,
                      onTap: _openDifficultyFilter,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // 4. Results Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  _isFiltered
                      ? '${results.length} treks found'
                      : 'Popular Treks',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // 5. Trek list or empty state
              if (results.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.xxxl,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_off_rounded,
                            size: 32,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'No treks found.',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Try changing your search or filters.',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (final trek in results) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: TrekCard(trek: trek),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primaryGreen : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.surface : AppColors.primaryText,
                  fontSize: AppTextSize.xs,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: isSelected ? AppColors.surface : AppColors.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterOption<T> {
  const _FilterOption({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}
