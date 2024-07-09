
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hba_management/core/routing/route_path.dart';
import 'package:hba_management/layers/view/auth/login_screen.dart';
import 'package:hba_management/layers/view/home_page.dart';
import 'package:hba_management/layers/view/hotel/create_hotel.dart';
import 'package:hba_management/layers/view/hotel/hotels.dart';
import 'package:hba_management/layers/view/hotel_managers/create_hotel_manager.dart';
import 'package:hba_management/layers/view/hotel_managers/hotel_managers.dart';
import 'package:hba_management/layers/view/room/create_room.dart';
import 'package:hba_management/layers/view/room/rooms.dart';

import '../../layers/view/intro/splash_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.LogIn:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutePaths.SplashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case RoutePaths.HotelsScreen:
        return MaterialPageRoute(builder: (_) => HotelsScreen());
      case RoutePaths.HotelManagersScreen:
        return MaterialPageRoute(builder: (_) => HotelManagers());
      case RoutePaths.RoomsScreen:
        return MaterialPageRoute(builder: (_) => RoomsScreen());
      case RoutePaths.CreateRoomScreen:
        final arguments = settings.arguments ?? <String, dynamic>{} as Map;
        return MaterialPageRoute(
            builder: (_) => CreateRoomScreen(
                  room: (arguments as Map)["room"],
                ));
      case RoutePaths.CreateHotelScreen:
        final arguments = settings.arguments ?? <String, dynamic>{} as Map;
        return MaterialPageRoute(
            builder: (_) => CreateHotelScreen(
                  hotel: (arguments as Map)["hotel"],
                ));
      case RoutePaths.CreateHotelManager:
        final arguments = settings.arguments ?? <String, dynamic>{} as Map;
        return MaterialPageRoute(
            builder: (_) => CreateHotelManager(
                  admin: (arguments as Map)["admin"],
                ));

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
                // child: Text('No route defined for ${settings.name}'),
                ),
          ),
        );
    }
  }
}
