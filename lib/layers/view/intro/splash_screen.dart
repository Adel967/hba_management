import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hba_management/core/configuration/assets.dart';
import 'package:hba_management/core/exception/app_exceptions.dart';
import 'package:hba_management/core/routing/route_path.dart';
import 'package:hba_management/core/shared_preferences/shared_preferences_instance.dart';
import 'package:hba_management/core/shared_preferences/shared_preferences_key.dart';
import 'package:hba_management/layers/view/auth/login_screen.dart';
import 'package:hba_management/layers/view/home_page.dart';
import 'package:hba_management/layers/view/hotel/hotels.dart';
import 'package:provider/provider.dart';

import '../../../core/app/state/app_state.dart';
import '../../../core/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  getData(int? time) {
    Future.delayed(Duration(seconds: time ?? 3), () async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await Provider.of<AppState>(context, listen: false).init();
        if (SharedPreferencesInstance.pref
                .getInt(SharedPreferencesKeys.UserRole) ==
            1) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutePaths.HotelsScreen, (route) => false);
        } else {
          try {
            await Provider.of<AppState>(context, listen: false).setHotel();
          } on AppException catch (e) {
            if (e.message!.contains("No Hotels")) {
              FirebaseAuth.instance.signOut();
              getData(0);
              return;
            }
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutePaths.RoomsScreen, (route) => false);
        }

        //home page
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutePaths.LogIn, (route) => false); //login
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = ColorTween(begin: Colors.blue.shade400, end: Colors.white)
        .animate(_animationController);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    getData(null);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: _animation.value,
        body: Center(
          child: Image.asset(AssetsLink.appLogo),
        ));
  }
}
