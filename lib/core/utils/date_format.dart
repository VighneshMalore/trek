const List<String> _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Formats DateTime in '15 Nov 2026' style.
String formatTrekDate(DateTime date) {
  return '${date.day} ${_months[date.month - 1]} ${date.year}';
}

