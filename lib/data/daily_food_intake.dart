import 'package:calorie_counter_app/data/foodItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyFoodIntake {
  final String id;
  final List<FoodItem> foodItems;
  final int totalCalories;
  final DateTime date;

  DailyFoodIntake({
    required this.id,
    required this.foodItems,
    required this.totalCalories,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodItems': foodItems.map((food) => food.toMap()).toList(),
      'totalCalories': totalCalories,
      'date': date,
    };
  }

  factory DailyFoodIntake.fromMap(String id, Map<String, dynamic> map) {
    List<FoodItem> foodItems = (map['foodItems'] as List<dynamic>?)
        ?.map((item) => FoodItem.fromMap('', item))
        .toList() ?? [];

    return DailyFoodIntake(
      id: id,
      foodItems: foodItems,
      totalCalories: map['totalCalories'] ?? 0,
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
