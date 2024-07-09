import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hba_management/core/shared_preferences/shared_preferences_instance.dart';
import 'package:provider/provider.dart';

import 'core/app/state/app_state.dart';
import 'core/routing/route_path.dart';
import 'core/routing/router.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initInjection();
  await SharedPreferencesInstance().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sl<AppState>()),
      ],
      builder: (context, state) {
        return ScreenUtilInit(
            designSize: Size(1080, 1920),
            minTextAdapt: true,
            useInheritedMediaQuery: true,
            // Use builder only if you need to use library outside ScreenUtilInit context

            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
                useMaterial3: true,
              ),
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: RoutePaths.SplashScreen,
            ));
      },
    );
  }
}
