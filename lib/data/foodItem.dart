import 'package:cloud_firestore/cloud_firestore.dart';


class FoodItem {
  final String name;
  final double weight;
  final String composition;
  final int calories;

  FoodItem({
    required this.name,
    required this.weight,
    required this.composition,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'weight': weight,
      'composition': composition,
      'calories': calories,
    };
  }

  factory FoodItem.fromMap(String id, Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'] ?? '',
      weight: map['weight'] ?? 0.0,
      composition: map['composition'] ?? '',
      calories: map['calories'] ?? 0,
    );
  }
}
