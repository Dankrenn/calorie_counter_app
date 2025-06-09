import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoOfCalorie {
  final bool isMen;
  final int age;
  final int weight;
  final int height;
  final double activityIndex;
  final int mifflinResult;
  final DateTime timestamp;

  UserInfoOfCalorie({
    required this.isMen,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityIndex,
    required this.mifflinResult,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'isMen': isMen,
      'age': age,
      'weight': weight,
      'height': height,
      'activityIndex': activityIndex,
      'mifflinResult': mifflinResult,
      'timestamp': timestamp,
    };
  }

  factory UserInfoOfCalorie.fromMap(Map<String, dynamic> map) {
    return UserInfoOfCalorie(
      isMen: map['isMen'] as bool? ?? false,
      age: map['age'] as int? ?? 0,
      weight: map['weight'] as int? ?? 0,
      height: map['height'] as int? ?? 0,
      activityIndex: (map['activityIndex'] as num?)?.toDouble() ?? 0.0,
      mifflinResult: map['mifflinResult'] as int? ?? 0,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}