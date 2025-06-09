import 'package:calorie_counter_app/view/entrance/entrance_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputEntranceWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  const InputEntranceWidget({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EntranceModel>(context);

    return TextField(
      controller: controller,
      obscureText: isPassword ? model.showPassword : false,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: model.setShowPassword,
          icon: Icon(
            model.showPassword ? Icons.visibility_off : Icons.visibility,
          ),
        )
            : null,
      ),
    );
  }
}
