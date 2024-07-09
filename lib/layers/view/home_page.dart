import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hba_management/core/constants.dart';
import 'package:hba_management/layers/view/hotel/hotels.dart';
import 'package:hba_management/layers/view/hotel_managers/hotel_managers.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants.appName),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Hotels",
              ),
              Tab(text: "Managers"),
            ],
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: Colors.blue),
                insets: EdgeInsets.symmetric(horizontal: 0.0)),
            indicatorWeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          children: [HotelsScreen(), HotelManagers()],
        ),
      ),
    );
  }
}
