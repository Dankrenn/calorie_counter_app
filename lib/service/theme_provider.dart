import 'package:calorie_counter_app/service/hive_service.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final HiveService hiveService = HiveService();
  late bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await hiveService.getIsDaskMode() ?? false;
    notifyListeners();
  }

  Future<void> updateTheme() async {
    _isDarkMode = !_isDarkMode;
    await hiveService.setIsDaskMode(_isDarkMode);
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode ? ThemeData.dark() : ThemeData.light();
}
