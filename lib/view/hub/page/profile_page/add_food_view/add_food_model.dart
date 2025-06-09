import 'package:calorie_counter_app/data/foodItem.dart';
import 'package:calorie_counter_app/service/supa_base_services.dart';
import 'package:calorie_counter_app/service/validation_service.dart';
import 'package:flutter/material.dart';

class AddFoodModel extends ChangeNotifier {
  final SupaBaseServices supaBaseServices = SupaBaseServices();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController compositionController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  Future<void> saveFoodItem(BuildContext context) async {
    try {
      final foodItem = FoodItem(
        name: nameController.text,
        weight: double.parse(weightController.text),
        composition: compositionController.text,
        calories: int.parse(caloriesController.text),
      );

      await supaBaseServices.saveFoodItem(foodItem);
      nameController.clear();
      weightController.clear();
      compositionController.clear();
      caloriesController.clear();
      ValidationService.showInfo(context, 'Блюдо успешно сохранено!');
    } catch (e) {
      ValidationService.showInfo(context, e.toString());
    }
  }
}