import 'package:calorie_counter_app/view/hub/page/add_food_calorie_view/add_food_calorie_view.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/profile_page.dart';
import 'package:calorie_counter_app/view/hub/page/show_calorie_view/show_calorie_view.dart';
import 'package:flutter/material.dart';

class HubModel extends ChangeNotifier{
  int _currentIndex = 1;
  final List<Widget> _tabs = [
    AddFoodCalorieView(),
    ShowCalorieView(),
    ProfilePage(),
  ];

  int get currentIndex => _currentIndex;
  List<Widget> get tabs => _tabs;


  void updateCurrentIndex(int index){
    _currentIndex = index;
    notifyListeners();
  }
}