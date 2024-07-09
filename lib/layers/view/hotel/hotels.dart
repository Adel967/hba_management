import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hba_management/core/routing/route_path.dart';
import 'package:hba_management/core/ui/waiting_widget.dart';
import 'package:hba_management/layers/bloc/hotel/hotel_cubit.dart';
import 'package:hba_management/layers/view/hotel/widgets/hotel_item.dart';

import '../../../injection_container.dart';
import '../../data/model/hotel_model.dart';
import '../widgets/custom_drawer.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final _hotelCubit = sl<HotelCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!(_hotelCubit.state is HotelLoaded)) {
      _hotelCubit.getHotels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Hotels"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(RoutePaths.CreateHotelScreen),
      ),
      body: BlocBuilder<HotelCubit, HotelState>(
        bloc: _hotelCubit,
        builder: (context, state) {
          if (state is HotelLoading) {
            return WaitingWidget();
          } else if (state is HotelError) {
            return Text(state.error);
          } else if (state is HotelLoaded) {
            if (state.hotels.isNotEmpty) {
              return AnimationLimiter(
                child: GridView.builder(
                    key: PageStorageKey("hotels"),
                    physics: const ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 7,
                        mainAxisSpacing: 7,
                        mainAxisExtent: 320.0),
                    itemCount: state.hotels.length,
                    itemBuilder: (context, index) {
                      HotelModel hotel = state.hotels[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        duration: Duration(milliseconds: 500),
                        child: SlideAnimation(
                            delay: Duration(milliseconds: 275),
                            child: HotelItem(
                              onTapFavorite: () {
                                // setState(() {
                                //   features[index]["is_favorited"] =
                                //       !features[index]["is_favorited"];
                                // });
                              },
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    RoutePaths.CreateHotelScreen,
                                    arguments: {"hotel": hotel});
                              },
                              hotelModel: hotel,
                            )),
                      );
                    }),
              );
            }
            return Text("There is not any hotels yet!");
          }
          return SizedBox();
        },
      ),
    );
  }
}
