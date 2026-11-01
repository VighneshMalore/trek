import 'package:flutter/foundation.dart';
import '../models/trek_plan.dart';

/// Global in-memory store for saved trek plans.
final ValueNotifier<List<TrekPlan>> savedPlans = ValueNotifier<List<TrekPlan>>(<TrekPlan>[]);

