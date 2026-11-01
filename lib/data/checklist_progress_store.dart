import 'package:flutter/foundation.dart';

/// In-memory store mapping trek ID to the set of completed checklist item IDs.
final ValueNotifier<Map<String, Set<String>>> checklistProgress =
    ValueNotifier<Map<String, Set<String>>>(<String, Set<String>>{});

/// Toggles an item's completion state for a specific trek.
/// Creates new collection copies so ValueNotifier listeners trigger.
void toggleChecklistItem(String trekId, String itemId) {
  final currentMap = Map<String, Set<String>>.from(checklistProgress.value);
  final currentSet = Set<String>.from(currentMap[trekId] ?? <String>{});

  if (currentSet.contains(itemId)) {
    currentSet.remove(itemId);
  } else {
    currentSet.add(itemId);
  }

  currentMap[trekId] = currentSet;
  checklistProgress.value = currentMap;
}

/// Returns the set of completed item IDs for the given trek.
Set<String> completedIdsFor(String trekId) {
  return checklistProgress.value[trekId] ?? const <String>{};
}

