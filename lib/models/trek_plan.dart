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

/// Lifecycle status for a saved trek plan.
enum PlanStatus {
  planned,
  completed,
}

/// Domain model for a user's planned trek.
class TrekPlan {
  final Trek trek;
  final DateTime date;
  final String startingPoint;
  final Transport transport;
  final PlanStatus status;

  const TrekPlan({
    required this.trek,
    required this.date,
    required this.startingPoint,
    required this.transport,
    this.status = PlanStatus.planned,
  });

  TrekPlan copyWith({
    PlanStatus? status,
  }) {
    return TrekPlan(
      trek: trek,
      date: date,
      startingPoint: startingPoint,
      transport: transport,
      status: status ?? this.status,
    );
  }
}
