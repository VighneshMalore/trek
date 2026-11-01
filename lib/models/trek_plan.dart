import 'trek.dart';

/// Supported transport modes for reaching trek starting point.
enum Transport {
  car('Car'),
  bus('Bus'),
  train('Train'),
  bike('Bike');

  final String label;
  const Transport(this.label);
}

/// Domain model for a user's planned trek.
class TrekPlan {
  final Trek trek;
  final DateTime date;
  final String startingPoint;
  final Transport transport;

  const TrekPlan({
    required this.trek,
    required this.date,
    required this.startingPoint,
    required this.transport,
  });
}

