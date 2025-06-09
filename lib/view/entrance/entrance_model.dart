import 'package:calorie_counter_app/service/navigator.dart';
import 'package:calorie_counter_app/service/supa_base_services.dart';
import 'package:calorie_counter_app/service/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EntranceModel extends ChangeNotifier{
    final TextEditingController _email = TextEditingController();
    final TextEditingController _password = TextEditingController();
    final TextEditingController _configPassword = TextEditingController();

    TextEditingController get email => _email;
    TextEditingController get password => _password;
    TextEditingController get configPassword => _configPassword;

    final SupaBaseServices _supaBaseServices = SupaBaseServices();

    bool _showPassword = false;

    bool get showPassword => _showPassword;

    void setShowPassword() {
      _showPassword = !_showPassword;
      notifyListeners();
    }

    void _clearInfo() {
      _email.clear();
      _password.clear();
      _configPassword.clear();
      _showPassword = false;
    }

    void goAuth(BuildContext context) {
      _clearInfo();
      context.go(NavigatorRouse.auth);
    }

    void goRegistr(BuildContext context) {
      _clearInfo();
      context.push(NavigatorRouse.register);
    }

    void _goHub(BuildContext context) {
      _clearInfo();
      context.go(NavigatorRouse.hub);
    }

    void authUser(BuildContext context) async {
      try
      {
        ValidationService.validateEmail(_email.text);
        ValidationService.validatePassword(_password.text);
        await _supaBaseServices.login(_email.text, _password.text);
        ValidationService.showInfo(context, "Вход в аккаунт выполнен");
        _goHub(context);
      }
      catch(e){
        ValidationService.showError(context, e.toString());
        return;
      }
    }

    void registerUser(BuildContext context) async {
        try
        {
          ValidationService.validateEmail(_email.text);
          ValidationService.validatePassword(_password.text);
          ValidationService.validateConfigPassword(_password.text,_configPassword.text);
          await _supaBaseServices.register(_email.text, _password.text);
          ValidationService.showInfo(context, "Пользователь зарегистрирован");
          goAuth(context);
        }
        catch(e){
          ValidationService.showError(context, e.toString());
          return;
        }
    }

}