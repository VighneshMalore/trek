/// Domain model for an individual checklist item.
class ChecklistItem {
  final String id;
  final String title;
  final String? description;

  const ChecklistItem({
    required this.id,
    required this.title,
    this.description,
  });
}

/// Category grouping for checklist items.
class ChecklistCategory {
  final String name;
  final List<ChecklistItem> items;

  const ChecklistCategory({
    required this.name,
    required this.items,
  });
}

/// Preparation readiness status derived from checklist completion percentage.
enum ReadinessStatus {
  notReady('Not Ready', 'Start with the essentials.'),
  gettingReady('Getting Ready', "Keep going, you're making progress."),
  almostReady('Almost Ready', 'Complete the remaining items before your trek.'),
  ready('Ready', 'Your checklist looks good. Enjoy your trek!');

  final String label;
  final String message;

  const ReadinessStatus(this.label, this.message);

  /// Computes readiness level from integer completion percent (0-100).
  static ReadinessStatus fromPercent(int percent) {
    if (percent >= 90) {
      return ReadinessStatus.ready;
    }
    if (percent >= 70) {
      return ReadinessStatus.almostReady;
    }
    if (percent >= 40) {
      return ReadinessStatus.gettingReady;
    }
    return ReadinessStatus.notReady;
  }
}

