import 'package:calorie_counter_app/data/daily_food_intake.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calorie_counter_app/data/user_info_of_calorie.dart';

class ShowCaloriesModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserInfoOfCalorie? userCalorieInfo;
  DailyFoodIntake? dailyIntake;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();

  ShowCaloriesModel() {
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading = true;
      notifyListeners();

      await Future.wait([
        loadLatestCalorieCalculation(),
        loadDailyFoodIntake(),
      ]);
    } catch (e) {
      throw Exception("Ошибка загрузки данных: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLatestCalorieCalculation() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Пользователь не авторизован");

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('calorie_history')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    userCalorieInfo = snapshot.docs.isEmpty
        ? null
        : UserInfoOfCalorie.fromMap(snapshot.docs.first.data());
  }

  Future<void> loadDailyFoodIntake() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Пользователь не авторизован");

    final dateStr = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('daily_intake')
        .doc(dateStr)
        .get();

    dailyIntake = snapshot.exists
        ? DailyFoodIntake.fromMap(snapshot.id, snapshot.data()!)
        : null;
  }

}