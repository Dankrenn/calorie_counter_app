import 'package:calorie_counter_app/service/navigator.dart';
import 'package:calorie_counter_app/service/supa_base_services.dart';
import 'package:calorie_counter_app/service/validation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileModel extends ChangeNotifier {
  final SupaBaseServices _supaBaseServices = SupaBaseServices();

  late String _email;
  String get email => _email;
  ProfileModel(){
    getEmailUser();
  }
  void getEmailUser() {
    User? user = _supaBaseServices.getCurrentUser();
    _email = user!.email!;
  }

  void logout(BuildContext context) {
    try {
      _supaBaseServices.logout();
      ValidationService.showInfo(context, "Выход из аккаунта успешен");
      context.go(NavigatorRouse.auth);
    } catch (e) {
      ValidationService.showError(context, e.toString());
    }
  }

  void goAddFoodView(BuildContext context){
    context.push(NavigatorRouse.addFood);
  }

  void goHistoryView(BuildContext context){
    context.push(NavigatorRouse.history);
  }

  void goHistoryWeightView(BuildContext context){
    context.push(NavigatorRouse.historyWeight);
  }

  void goCalorieCounterView(BuildContext context){
    context.push(NavigatorRouse.calorieCounter);
  }
}
