import 'package:calorie_counter_app/data/user_info_of_calorie.dart';
import 'package:calorie_counter_app/service/supa_base_services.dart';
import 'package:calorie_counter_app/service/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalorieCounterModel extends ChangeNotifier {
  final SupaBaseServices supaBaseServices = SupaBaseServices();
  final List<Map<String, dynamic>> activities = [
    {"title": "Сидячий", "desc": "Минимум", "value": 1.2},
    {"title": "Легкая", "desc": "1-3 тренировки в неделю", "value": 1.375},
    {"title": "Средняя", "desc": "3-5 тренировок в неделю", "value": 1.55},
    {"title": "Высокая", "desc": "6-7 тренировок в неделю", "value": 1.725},
  ];

  final TextEditingController _age = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _height = TextEditingController();
  bool _isMaleSelected = true;
  int _selectedActivityIndex = 0;
  int _mifflinResult = 0;
  late UserInfoOfCalorie _userInfoOfCalorie;
  bool _isLoading = true;

  TextEditingController get age => _age;
  TextEditingController get weight => _weight;
  TextEditingController get height => _height;
  bool get isMaleSelected => _isMaleSelected;
  int get selectedActivityIndex => _selectedActivityIndex;
  String get mifflinResult => _mifflinResult.toString();
  bool get isLoading => _isLoading;

  CalorieCounterModel() {
    _loadCalorieInfo();
  }

  Future<void> _loadCalorieInfo() async {
    UserInfoOfCalorie? userInfo = await supaBaseServices.loadLatestCalorieCalculation();

    if (userInfo != null) {
      _userInfoOfCalorie = userInfo;
      _age.text = _userInfoOfCalorie.age.toString();
      _weight.text = _userInfoOfCalorie.weight.toString();
      _height.text = _userInfoOfCalorie.height.toString();
      _isMaleSelected = _userInfoOfCalorie.isMen;

      _selectedActivityIndex = activities.indexWhere(
              (activity) => activity['value'] == _userInfoOfCalorie.activityIndex);
      _mifflinResult = _userInfoOfCalorie.mifflinResult;
    }
    _isLoading = false;
    notifyListeners();
  }

  void setIsMaleSelected(bool isMen) {
    _isMaleSelected = isMen;
    notifyListeners();
  }

  void setSelectedActivityIndex(int index) {
    _selectedActivityIndex = index;
    notifyListeners();
  }

  void counterCalorie(BuildContext context) {
    try {
      ValidationService.validateAge(_age.text);
      ValidationService.validateWeight(_weight.text);
      ValidationService.validateHeight(_height.text);

      int age = int.parse(_age.text);
      int weight = int.parse(_weight.text);
      int height = int.parse(_height.text);
      double activityIndex = activities[_selectedActivityIndex]["value"] as double;

      if (_isMaleSelected) {
        _mifflinResult = ((10 * weight + 6.25 * height - 5 * age + 5) * activityIndex).toInt();
      } else {
        _mifflinResult = ((10 * weight + 6.25 * height - 5 * age - 161) * activityIndex).toInt();
      }

      _userInfoOfCalorie = UserInfoOfCalorie(
        isMen: _isMaleSelected,
        age: age,
        weight: weight,
        height: height,
        activityIndex: activityIndex,
        mifflinResult: _mifflinResult,
      );

      notifyListeners();
      addServerCalorieInfo(context);
    } catch (e) {
      ValidationService.showError(context, e.toString());
    }
  }

  void addServerCalorieInfo(BuildContext context) {
    try {
      supaBaseServices.saveCalorieInfo(_userInfoOfCalorie);
      ValidationService.showInfo(context, "Ваши данные успешно загружены на сервер");
    } catch (e) {
      ValidationService.showError(context, e.toString());
    }
  }
}
