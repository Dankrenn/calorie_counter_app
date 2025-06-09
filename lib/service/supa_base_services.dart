import 'package:calorie_counter_app/data/daily_food_intake.dart';
import 'package:calorie_counter_app/data/foodItem.dart';
import 'package:calorie_counter_app/data/user_info_of_calorie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupaBaseServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Регистрация пользователя
  Future<void> register(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      throw Exception("Пользователь с таким email уже существует");
    } catch (e) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        throw Exception("Ошибка при регистрации пользователя: ${e.toString()}");
      }
    }
  }

  // Вход в систему
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw Exception("Пользователя не существует");
        } else if (e.code == 'wrong-password') {
          throw Exception("Неверный пароль");
        }
        if (e.code == 'invalid-credential') {
          throw Exception("Неверный логин или пароль");
        }
      }
      throw Exception("Ошибка при входе пользователя: ${e.toString()}");
    }
  }

  // Метод для получения текущего пользователя
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Выход из системы
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Ошибка при выходе из аккаунта: ${e.toString()}");
    }
  }

  // Сохранение информации о рассчетах
  Future<void> saveCalorieInfo(UserInfoOfCalorie info) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('calorie_history')
          .add(info.toMap());
    } catch (e) {
      throw Exception("Ошибка сохранения: ${e.toString()}");
    }
  }

  // Загрузка всей истории
  Future<List<UserInfoOfCalorie>> loadCalorieHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('calorie_history')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => UserInfoOfCalorie.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception("Ошибка Firestore: ${e.message}");
    } catch (e) {
      throw Exception("Ошибка загрузки истории: ${e.toString()}");
    }
  }

  // Загрузка последнего расчета
  Future<UserInfoOfCalorie?> loadLatestCalorieCalculation() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('calorie_history')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      return snapshot.docs.isEmpty
          ? null
          : UserInfoOfCalorie.fromMap(snapshot.docs.first.data());
    } on FirebaseException catch (e) {
      throw Exception("Ошибка Firestore: ${e.message}");
    } catch (e) {
      throw Exception("Ошибка загрузки данных: ${e.toString()}");
    }
  }

// Метод для сохранения информации о блюде
  Future<void> saveFoodItem(FoodItem foodItem) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('food_items')
          .add(foodItem.toMap());
    } catch (e) {
      throw Exception("Ошибка сохранения блюда: ${e.toString()}");
    }
  }

  // Метод для загрузки блюд
  Future<List<FoodItem>> loadFoodItems() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('food_items')
          .get();

      return snapshot.docs
          .map((doc) => FoodItem.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Ошибка загрузки блюд: ${e.toString()}");
    }
  }

  // Метод для добавления блюда в дневной рацион
  Future<void> addFoodToDailyIntake(FoodItem foodItem, DateTime date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");

      final dateStr = "${date.year}-${date.month}-${date.day}";
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('daily_intake')
          .doc(dateStr);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          transaction.set(docRef, {
            'foodItems': [foodItem.toMap()],
            'totalCalories': foodItem.calories,
            'date': date,
          });
        } else {
          final data = snapshot.data()!;
          final List<dynamic> foodItems = data['foodItems'] ?? [];
          final int totalCalories = data['totalCalories'] ?? 0;

          transaction.update(docRef, {
            'foodItems': [...foodItems, foodItem.toMap()],
            'totalCalories': totalCalories + foodItem.calories,
          });
        }
      });
    } catch (e) {
      throw Exception("Ошибка добавления блюда в дневной рацион: ${e.toString()}");
    }
  }

  // Метод для удаления одного конкретного блюда из дневного рациона
  Future<void> removeFoodFromDailyIntake(FoodItem foodItem, DateTime date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");

      final dateStr = "${date.year}-${date.month}-${date.day}";
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('daily_intake')
          .doc(dateStr);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (snapshot.exists) {
          final data = snapshot.data()!;
          final List<dynamic> foodItems = List.from(data['foodItems'] ?? []);
          final int totalCalories = data['totalCalories'] ?? 0;

          // Находим индекс первого совпадающего блюда
          final index = foodItems.indexWhere((item) =>
          item['name'] == foodItem.name &&
              item['weight'] == foodItem.weight &&
              item['calories'] == foodItem.calories);

          if (index != -1) {
            // Удаляем только одно блюдо по индексу
            foodItems.removeAt(index);

            transaction.update(docRef, {
              'foodItems': foodItems,
              'totalCalories': totalCalories - foodItem.calories,
            });
          }
        }
      });
    } catch (e) {
      throw Exception("Ошибка удаления блюда из дневного рациона: ${e.toString()}");
    }
  }


  // Метод для загрузки дневного рациона
  Future<DailyFoodIntake?> loadDailyFoodIntake(DateTime date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Пользователь не авторизован");

      final dateStr = "${date.year}-${date.month}-${date.day}";
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('daily_intake')
          .doc(dateStr)
          .get();

      if (!snapshot.exists) {
        return null;
      }

      return DailyFoodIntake.fromMap(snapshot.id, snapshot.data()!);
    } catch (e) {
      throw Exception("Ошибка загрузки дневного рациона: ${e.toString()}");
    }
  }
}
