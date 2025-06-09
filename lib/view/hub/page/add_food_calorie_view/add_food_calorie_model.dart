import 'package:calorie_counter_app/data/foodItem.dart';
import 'package:flutter/material.dart';
import 'package:calorie_counter_app/service/supa_base_services.dart';

class AddFoodCalorieModel extends ChangeNotifier {
  final SupaBaseServices supaBaseServices = SupaBaseServices();
  List<FoodItem> foodItems = [];
  bool isLoading = true;

  AddFoodCalorieModel() {
    loadFoodItems();
  }

  Future<void> loadFoodItems() async {
    try {
      isLoading = true;
      notifyListeners();

      foodItems = await supaBaseServices.loadFoodItems();
    } catch (e) {
      throw Exception("Ошибка загрузки блюд: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFoodItem(FoodItem foodItem) async {
    try {
      await supaBaseServices.saveFoodItem(foodItem);
      await loadFoodItems();
    } catch (e) {
      throw Exception("Ошибка добавления блюда: ${e.toString()}");
    }
  }

  Future<void> addFoodToDailyIntake(FoodItem foodItem) async {
    try {
      await supaBaseServices.addFoodToDailyIntake(foodItem, DateTime.now());
      // Обновить UI или показать уведомление об успешном добавлении
    } catch (e) {
      throw Exception("Ошибка добавления блюда в дневной рацион: ${e.toString()}");
    }
  }

  Future<void> deleteFoodItem(FoodItem foodItem) async {
    try {
      await supaBaseServices.removeFoodFromDailyIntake(foodItem, DateTime.now());
      await loadFoodItems();
    } catch (e) {
      throw Exception("Ошибка удаления блюда: ${e.toString()}");
    }
  }
}
