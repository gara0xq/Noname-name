class Child {
  final String name;
  final String code;
  final String gender;
  final DateTime birthDate;
  final int points;
  final int pendingTask;
  final int completedTask;
  final int expiredTask;
  final int submittedTask;
  final int declinedTask;
  final double progress;

  Child({
    required this.name,
    required this.code,
    required this.gender,
    required this.birthDate,
    required this.points,
    required this.pendingTask,
    required this.completedTask,
    required this.expiredTask,
    required this.submittedTask,
    required this.declinedTask,
    required this.progress,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: DateTime.parse(json['birth_date']),
      points: json['points'] ?? 0,
      pendingTask: json['pendingTask'] ?? 0,
      completedTask: json['completedTask'] ?? 0,
      expiredTask: json['expiredTask'] ?? 0,
      submittedTask: json['submittedTask'] ?? 0,
      declinedTask: json['declinedTask'] ?? 0,
      progress: json['progress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'gender': gender,
      'birth_date': birthDate.toIso8601String(),
      'points': points,
      'pendingTask': pendingTask,
      'completedTask': completedTask,
      'expiredTask': expiredTask,
      'submittedTask': submittedTask,
      'declinedTask': declinedTask,
      'progress': progress,
    };
  }
}
