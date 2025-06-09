import 'package:calorie_counter_app/view/entrance/entrance_model.dart';
import 'package:calorie_counter_app/view/entrance/reused_widgets/button_entrance_widget.dart';
import 'package:calorie_counter_app/view/entrance/reused_widgets/input_entrance_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<EntranceModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Авторизация',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 28),
                InputEntranceWidget(
                  hintText: 'Email',
                  isPassword: false,
                  controller: model.email,
                ),
                const SizedBox(height: 16),
                InputEntranceWidget(
                  hintText: 'Пароль',
                  isPassword: true,
                  controller: model.password,
                ),
                const SizedBox(height: 24),
                ButtonEntranceWidget(
                  text: 'Войти',
                  callback: () => model.authUser(context),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => model.goRegistr(context),
                  child: Text(
                    'Нет аккаунта? Зарегистрируйтесь',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
