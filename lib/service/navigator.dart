import 'package:calorie_counter_app/view/entrance/auth_view.dart';
import 'package:calorie_counter_app/view/entrance/registr_view.dart';
import 'package:calorie_counter_app/view/hub/hub_view.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/add_food_view/add_food_view.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/calorie_counter/calorie_counter_view.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/hictory_weight/history_weight_view.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/history_page/history_view.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

abstract class NavigatorRouse {
  static const String auth = "/";
  static const String register = "/register";
  static const String hub = "/hub";
  static const String addFood = "/hub/addFood";
  static const String history = "/hub/history";
  static const String calorieCounter = "/hub/calorieCounter";
  static const String historyWeight = "/hub/historyWeight";
}

class NavigatorApp {
  factory NavigatorApp() {
    return _instance;
  }

  NavigatorApp._internal();

  static final NavigatorApp _instance = NavigatorApp._internal();

  static final GoRouter _router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(path: NavigatorRouse.auth, builder: (context, state) => AuthView()),
      GoRoute(path: NavigatorRouse.register, builder: (context, state) => RegistrView()),
      GoRoute(path: NavigatorRouse.hub, builder: (context, state) => HubView()),
      GoRoute(path: NavigatorRouse.addFood, builder: (context, state) => AddFoodView()),
      GoRoute(path: NavigatorRouse.history, builder: (context, state) => HistoryView()),
      GoRoute(path: NavigatorRouse.calorieCounter, builder: (context, state) => CalorieCounterView()),
      GoRoute(path: NavigatorRouse.historyWeight, builder: (context, state) => HistoryWeightView()),
    ],
  );
  GoRouter get routerConfig => _router;
}