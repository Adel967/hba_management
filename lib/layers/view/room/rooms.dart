import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hba_management/core/app/state/app_state.dart';
import 'package:hba_management/core/routing/route_path.dart';
import 'package:hba_management/core/ui/waiting_widget.dart';
import 'package:hba_management/layers/bloc/hotel/hotel_cubit.dart';
import 'package:hba_management/layers/data/model/room_model.dart';
import 'package:hba_management/layers/view/hotel/widgets/hotel_item.dart';
import 'package:hba_management/layers/view/room/widgets/room_item.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import '../../bloc/room/room_cubit.dart';
import '../../data/model/hotel_model.dart';
import '../widgets/custom_drawer.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final _roomCubit = sl<RoomCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!(_roomCubit.state is RoomLoaded)) {
      _roomCubit.getRooms(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(Provider.of<AppState>(context).hotel!.hotelsName!),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(RoutePaths.CreateRoomScreen),
      ),
      body: BlocBuilder<RoomCubit, RoomState>(
        bloc: _roomCubit,
        builder: (context, state) {
          if (state is RoomLoading) {
            return WaitingWidget();
          } else if (state is RoomError) {
            return Text(state.error);
          } else if (state is RoomLoaded) {
            if (state.rooms.isNotEmpty) {
              return AnimationLimiter(
                child: GridView.builder(
                    key: PageStorageKey("rooms"),
                    physics: const ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 7,
                        mainAxisSpacing: 7,
                        mainAxisExtent: 320.0),
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      RoomsModel room = state.rooms[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        duration: Duration(milliseconds: 500),
                        child: SlideAnimation(
                            delay: Duration(milliseconds: 275),
                            child: RoomItem(
                              onTapFavorite: () {
                                // setState(() {
                                //   features[index]["is_favorited"] =
                                //       !features[index]["is_favorited"];
                                // });
                              },
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    RoutePaths.CreateRoomScreen,
                                    arguments: {"room": room});
                              },
                              room: room,
                            )),
                      );
                    }),
              );
            }
            return Center(child: Text("There is not any rooms yet!"));
          }
          return SizedBox();
        },
      ),
    );
  }
}
