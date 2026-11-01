import '../../models/checklist_item.dart';

/// Default 13-item trek preparation checklist grouped into 4 categories.
const List<ChecklistCategory> defaultChecklist = [
  ChecklistCategory(
    name: 'Essentials',
    items: [
      ChecklistItem(
        id: 'water',
        title: 'Water',
        description: 'Carry enough drinking water',
      ),
      ChecklistItem(
        id: 'trekking_shoes',
        title: 'Trekking shoes',
        description: 'Good grip for trail terrain',
      ),
      ChecklistItem(
        id: 'first_aid',
        title: 'First-aid kit',
        description: 'Bandages and antiseptic wipes',
      ),
      ChecklistItem(
        id: 'power_bank',
        title: 'Power bank',
        description: 'Keep your phone charged',
      ),
      ChecklistItem(
        id: 'id_proof',
        title: 'ID proof',
        description: 'Government-issued photo ID',
      ),
    ],
  ),
  ChecklistCategory(
    name: 'Clothing',
    items: [
      ChecklistItem(
        id: 'comfortable_clothes',
        title: 'Comfortable clothes',
        description: 'Quick-drying breathable fabrics',
      ),
      ChecklistItem(
        id: 'rain_jacket',
        title: 'Rain jacket',
        description: 'Protection against sudden showers',
      ),
      ChecklistItem(
        id: 'extra_socks',
        title: 'Extra socks',
        description: 'Spare pair for wet conditions',
      ),
    ],
  ),
  ChecklistCategory(
    name: 'Food',
    items: [
      ChecklistItem(
        id: 'snacks',
        title: 'Snacks',
        description: 'Dry fruits, nuts, or trail mix',
      ),
      ChecklistItem(
        id: 'energy_bars',
        title: 'Energy bars',
        description: 'Quick nutrition on the trail',
      ),
    ],
  ),
  ChecklistCategory(
    name: 'Safety',
    items: [
      ChecklistItem(
        id: 'torch',
        title: 'Torch',
        description: 'Flashlight or headlamp with batteries',
      ),
      ChecklistItem(
        id: 'basic_medicines',
        title: 'Basic medicines',
        description: 'Personal travel essentials',
      ),
      ChecklistItem(
        id: 'emergency_contact',
        title: 'Emergency contact information',
        description: 'Saved numbers and written card',
      ),
    ],
  ),
];

/// Optional per-trek checklist overrides.
const Map<String, List<ChecklistCategory>> _trekChecklistOverrides = {};

/// Returns the checklist categories and items for a specific trek.
List<ChecklistCategory> checklistFor(String trekId) {
  return _trekChecklistOverrides[trekId] ?? defaultChecklist;
}

