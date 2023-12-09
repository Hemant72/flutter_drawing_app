import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_app/core/route/app_route.dart';
import 'package:flutter_drawing_app/core/route/app_route_name.dart';
import 'package:flutter_drawing_app/core/theme/app_theme.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Drawing App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      initialRoute: AppRouteName.drawingRoom,
      onGenerateRoute: AppRoute.generate,
      navigatorObservers: [routeObserver],
    );
  }
}
