import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hba_management/layers/bloc/admin/admin_cubit.dart';
import 'package:hba_management/layers/data/model/user_model.dart';

import '../../../core/routing/route_path.dart';
import '../../../core/ui/waiting_widget.dart';
import '../../../injection_container.dart';
import '../widgets/custom_drawer.dart';

class HotelManagers extends StatefulWidget {
  HotelManagers({super.key});

  @override
  State<HotelManagers> createState() => _HotelManagersState();
}

class _HotelManagersState extends State<HotelManagers> {
  final _adminCubit = sl<AdminCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!(_adminCubit.state is AdminLoaded)) {
      _adminCubit.getAdmins();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Hotel Managers"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(RoutePaths.CreateHotelManager),
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        bloc: _adminCubit,
        builder: (context, state) {
          print(state);
          if (state is AdminLoading) {
            return WaitingWidget();
          } else if (state is AdminError) {
            return Text(state.error);
          } else if (state is AdminLoaded) {
            if (state.admins.isNotEmpty) {
              return ListView.builder(
                itemCount: state.admins.length,
                itemBuilder: (context, index) {
                  UserModel admin = state.admins[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                        RoutePaths.CreateHotelManager,
                        arguments: {"admin": admin}),
                    child: Card(
                        child: ListTile(
                      title: Text(admin.userName!),
                      subtitle: Text(admin.email!),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    )),
                  );
                },
              );
            } else {
              return Center(
                child: Text("There is not any admins yet!"),
              );
            }
          }
          return SizedBox();
        },
      ),
    );
  }
}
