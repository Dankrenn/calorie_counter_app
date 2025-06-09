import 'package:flutter/material.dart';
import 'package:calorie_counter_app/data/user_info_of_calorie.dart';
import 'package:calorie_counter_app/service/supa_base_services.dart';

class HistoryWeightModel extends ChangeNotifier {
  final SupaBaseServices supaBaseServices = SupaBaseServices();
  List<UserInfoOfCalorie> history = [];
  bool isLoading = true; // Флаг для отслеживания состояния загрузки

  HistoryWeightModel() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      history = await supaBaseServices.loadCalorieHistory();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
