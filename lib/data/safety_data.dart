import 'package:flutter/material.dart';
import '../models/checklist_item.dart';

/// Representation of an emergency contact service.
class EmergencyContact {
  final String service;
  final String number;
  final IconData icon;
  final bool isPrimary;

  const EmergencyContact({
    required this.service,
    required this.number,
    required this.icon,
    this.isPrimary = false,
  });
}

/// Representation of a grouped category of safety tips.
class SafetyTipGroup {
  final String title;
  final List<String> tips;

  const SafetyTipGroup({
    required this.title,
    required this.tips,
  });
}

/// Emergency contacts in verbatim order (112 first).
const List<EmergencyContact> emergencyContacts = [
  EmergencyContact(
    service: 'Emergency',
    number: '112',
    icon: Icons.emergency_outlined,
    isPrimary: true,
  ),
  EmergencyContact(
    service: 'Police',
    number: '100',
    icon: Icons.local_police_outlined,
  ),
  EmergencyContact(
    service: 'Ambulance',
    number: '108',
    icon: Icons.local_hospital_outlined,
  ),
  EmergencyContact(
    service: 'Fire',
    number: '101',
    icon: Icons.local_fire_department_outlined,
  ),
];

/// Trek safety tips grouped by category.
const List<SafetyTipGroup> safetyTipGroups = [
  SafetyTipGroup(
    title: 'Before You Start',
    tips: [
      'Check weather conditions.',
      'Carry enough drinking water.',
      'Inform someone about your trek plan.',
      'Carry a charged phone and power bank.',
      'Carry basic first-aid supplies.',
    ],
  ),
  SafetyTipGroup(
    title: 'During the Trek',
    tips: [
      'Stay on marked trails.',
      'Avoid trekking alone in unfamiliar areas.',
      'Stay with your group.',
      'Do not take unnecessary risks near cliffs.',
      'Follow local instructions and warnings.',
    ],
  ),
  SafetyTipGroup(
    title: 'Weather',
    tips: [
      'Avoid exposed areas during thunderstorms.',
      'Be careful on slippery trails after rain.',
      'Carry rain protection during uncertain weather.',
    ],
  ),
];

/// Important warnings verbatim.
const List<String> importantWarnings = [
  'Weather can change quickly in mountainous areas.',
  'Do not continue if trail conditions become unsafe.',
  'Avoid isolated routes when trekking alone.',
  'Keep emergency contacts accessible.',
];

/// Local checklist items ("Before starting") using ChecklistItem model.
const List<ChecklistItem> safetyChecklistItems = [
  ChecklistItem(id: 'phone_charged', title: 'Phone charged'),
  ChecklistItem(id: 'power_bank_packed', title: 'Power bank packed'),
  ChecklistItem(id: 'water_packed', title: 'Water packed'),
  ChecklistItem(id: 'first_aid_packed', title: 'First-aid kit packed'),
  ChecklistItem(id: 'contact_informed', title: 'Emergency contact informed'),
  ChecklistItem(id: 'weather_checked', title: 'Weather checked'),
];

