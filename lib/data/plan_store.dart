import 'package:flutter/foundation.dart';
import '../models/trek_plan.dart';

/// Global in-memory store for saved trek plans.
final ValueNotifier<List<TrekPlan>> savedPlans =
    ValueNotifier<List<TrekPlan>>(<TrekPlan>[]);

bool _isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Saves a trek plan if no plan with identical trek ID and calendar date exists.
bool savePlan(TrekPlan plan) {
  final isDuplicate = savedPlans.value.any(
    (existing) =>
        existing.trek.id == plan.trek.id &&
        _isSameCalendarDay(existing.date, plan.date),
  );

  if (isDuplicate) {
    return false;
  }

  savedPlans.value = <TrekPlan>[...savedPlans.value, plan];
  return true;
}

/// Marks a matching trek plan as completed, preserving existing list order.
void markPlanCompleted(TrekPlan plan) {
  savedPlans.value = savedPlans.value.map((existing) {
    if (existing.trek.id == plan.trek.id &&
        _isSameCalendarDay(existing.date, plan.date)) {
      return existing.copyWith(status: PlanStatus.completed);
    }
    return existing;
  }).toList();
}
