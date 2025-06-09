import 'package:calorie_counter_app/service/hive_service.dart';
import 'package:calorie_counter_app/service/navigator.dart';
import 'package:calorie_counter_app/service/theme_provider.dart';
import 'package:calorie_counter_app/view/entrance/entrance_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String initialRoute = NavigatorRouse.auth;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDrAsgxyjgJP8ja9GZjNG1su-cE53c93GI',
          appId: '1:919104180750:android:6703be87ee46d326e8a25f',
          messagingSenderId: '919104180750',
          projectId: 'calorie-counter-app-58a67'));
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    initialRoute = NavigatorRouse.hub;
  } else {
    initialRoute = NavigatorRouse.auth;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EntranceModel>(
          create: (context) => EntranceModel(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeModel, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: themeModel.theme,
            routerConfig: NavigatorApp().routerConfig,
          );
        },
      ),
    );
  }
}