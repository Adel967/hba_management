import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hba_management/core/configuration/assets.dart';
import 'package:hba_management/core/routing/route_path.dart';
import 'package:hba_management/layers/bloc/auth/auth_cubit.dart';
import 'package:provider/provider.dart';

import '../../../core/app/state/app_state.dart';
import '../../../core/loaders/loading_overlay.dart';
import '../../../core/shared_preferences/shared_preferences_instance.dart';
import '../../../core/shared_preferences/shared_preferences_key.dart';
import '../../../core/utils.dart';
import '../../../injection_container.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _authCubit = sl<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<AuthCubit, AuthState>(
          bloc: _authCubit,
          listener: (context, state) async {
            if (state is AuthLoading) {
              LoadingOverlay.of(context).show();
            } else if (state is AuthLoaded) {
              await Provider.of<AppState>(context, listen: false).init();
              if (SharedPreferencesInstance.pref
                      .getInt(SharedPreferencesKeys.UserRole) ==
                  1) {
                LoadingOverlay.of(context).hide();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutePaths.HotelsScreen, (route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutePaths.RoomsScreen, (route) => false);
              }
            } else if (state is AuthError) {
              LoadingOverlay.of(context).hide();
              Utils.showSnackBar(context, state.error);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    AssetsLink.appLogo,
                    height: 140.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _authCubit.login(_emailController.text.trim(),
                            _passwordController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.blue.shade400,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
