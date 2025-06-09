import 'package:flutter/material.dart';

abstract class ValidationService {

  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showInfo(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.grey,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void validateEmail(String email) {
    if (email.isEmpty) {
      throw Exception("Email не может быть пустым");
    }

    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegExp.hasMatch(email)) {
      throw Exception("Некорректный формат email");
    }
  }

  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw Exception("Пароль не может быть пустым");
    }
    if (password.length < 8) {
      throw Exception("Пароль должен содержать не менее 8 символов");
    }

    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]+$');
    if (!passwordRegExp.hasMatch(password)) {
      throw Exception("Пароль должен содержать буквы, цифры и специальные символы");
    }
  }

  static void validateConfigPassword (String password, String configPassword) {
    if(password != configPassword)
    {
      throw Exception("Пароли не совпадают");
    }
  }

  // Валидация для подсчета калорий
  static void validateAge(String age) {
    if (age.isEmpty) {
      throw Exception("Возраст не может быть пустым");
    }

    final ageValue = int.tryParse(age);
    if (ageValue == null) {
      throw Exception("Возраст должен быть числом");
    }

    if (ageValue < 10 || ageValue > 120) {
      throw Exception("Возраст должен быть от 10 до 120 лет");
    }
  }

  static void validateWeight(String weight) {
    if (weight.isEmpty) {
      throw Exception("Вес не может быть пустым");
    }

    final weightValue = double.tryParse(weight);
    if (weightValue == null) {
      throw Exception("Вес должен быть числом");
    }

    if (weightValue < 20 || weightValue > 300) {
      throw Exception("Вес должен быть от 20 до 300 кг");
    }
  }

  static void validateHeight(String height) {
    if (height.isEmpty) {
      throw Exception("Рост не может быть пустым");
    }

    final heightValue = int.tryParse(height);
    if (heightValue == null) {
      throw Exception("Рост должен быть целым числом");
    }

    if (heightValue < 100 || heightValue > 250) {
      throw Exception("Рост должен быть от 100 до 250 см");
    }
  }
}