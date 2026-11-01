/// Trek difficulty levels.
enum TrekDifficulty {
  easy('Easy'),
  moderate('Moderate'),
  hard('Hard');

  final String label;
  const TrekDifficulty(this.label);
}

/// Experience level required for a trek.
enum ExperienceLevel {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  final String label;
  const ExperienceLevel(this.label);
}

/// Domain model representing a trekking trail.
class Trek {
  final String id;
  final String name;
  final String location;
  final TrekDifficulty difficulty;
  final ExperienceLevel experienceLevel;
  final double distanceKm;
  final String duration;
  final double rating;
  final String description;

  const Trek({
    required this.id,
    required this.name,
    required this.location,
    required this.difficulty,
    required this.experienceLevel,
    required this.distanceKm,
    required this.duration,
    required this.rating,
    required this.description,
  });
}

