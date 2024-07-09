import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hba_management/core/ui/waiting_widget.dart';
import 'package:hba_management/core/validators/validators.dart';
import 'package:hba_management/layers/bloc/admin/admin_cubit.dart';
import 'package:hba_management/layers/bloc/hotel/hotel_cubit.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/data/model/user_model.dart';

import '../../../core/configuration/styles.dart';
import '../../../core/enum.dart';
import '../../../core/loaders/loading_overlay.dart';
import '../../../core/ui/custom_dropdown.dart';
import '../../../core/utils.dart';
import '../../../injection_container.dart';

class CreateHotelManager extends StatefulWidget {
  final UserModel? admin;

  CreateHotelManager({this.admin});

  @override
  _CreateHotelManagerState createState() => _CreateHotelManagerState();
}

class _CreateHotelManagerState extends State<CreateHotelManager> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _dateOfBirth = TextEditingController();
  bool isUpdating = false;
  bool isLoading = false;
  HotelModel? _selectedHotel;
  HotelModel? _adminHotel;
  List<HotelModel> hotels = [];

  Gender gender = Gender.Male;
  final _adminCubit = sl<AdminCubit>();
  final _hotelCubit = sl<HotelCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.admin != null) {
      isUpdating = true;
      if (_hotelCubit.state is HotelLoaded) {
        List<HotelModel> adminHotel = List.from(
            (_hotelCubit.state as HotelLoaded).hotels.where((element) =>
                element.hotelManagerId != null &&
                element.hotelManagerId! == widget.admin!.id));
        _adminHotel = adminHotel.isNotEmpty ? adminHotel.first : null;
        hotels = List.from((_hotelCubit.state as HotelLoaded).hotels.where(
            (element) =>
                element.hotelManagerId == null ||
                element.hotelManagerId!.isEmpty));
      } else {
        _hotelCubit.getHotels();
      }
      _firstNameController.text = widget.admin!.userName!.split(" ").first;
      _lastNameController.text = widget.admin!.userName!.split(" ")[1];
      _phoneNumberController.text = widget.admin!.phoneNumber!;
      _dateOfBirth.text = widget.admin!.birthDate!;
      _emailController.text = widget.admin!.email!;
      gender = widget.admin!.gender!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isUpdating ? "Update" : "Enter"} Admin Information'),
        actions: [
          isUpdating
              ? IconButton(
                  onPressed: () => _adminCubit.removeAdmin(widget.admin!.id!),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
              : SizedBox()
        ],
      ),
      body: BlocListener<AdminCubit, AdminState>(
        bloc: _adminCubit,
        listener: (context, state) {
          if (state is AdminUploading) {
            LoadingOverlay.of(context).show();
          } else if (state is AdminUploaded) {
            LoadingOverlay.of(context).hide();
            _adminCubit.getAdmins();
            if (isUpdating) {
              _hotelCubit.getHotels();
            }
            Navigator.of(context).pop();
          } else if (state is AdminUploadingError) {
            LoadingOverlay.of(context).hide();
            Utils.showSnackBar(context, state.error);
            _adminCubit.getAdmins();
          }
        },
        child: BlocListener<HotelCubit, HotelState>(
          bloc: _hotelCubit,
          listener: (context, state) {
            if (isUpdating) {
              if (state is HotelLoading) {
                isLoading = true;
              } else if (state is HotelLoaded) {
                List<HotelModel> adminHotel = List.from(state.hotels.where(
                    (element) =>
                        element.hotelManagerId != null &&
                        element.hotelManagerId! == widget.admin!.id));
                _adminHotel = adminHotel.isNotEmpty ? adminHotel.first : null;
                hotels = List.from(state.hotels.where((element) =>
                    element.hotelManagerId == null ||
                    element.hotelManagerId!.isEmpty));
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: isUpdating && isLoading
                ? WaitingWidget()
                : Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailController,
                          readOnly: isUpdating,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email address';
                            }
                            if (!Validators.isValidEmail(value!)) {
                              return "This email address is not valid";
                            }
                          },
                        ),
                        SizedBox(height: 16.0),
                        Visibility(
                          visible: !isUpdating,
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              if (!Validators.isValidPassword(value!)) {
                                return "Password should be between 6 and 26";
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: isUpdating,
                          child: CustomDropDown<HotelModel>(
                            hintText: _adminHotel != null
                                ? _adminHotel!.hotelsName!
                                : "Choose Hotel",
                            verticalDropdownPadding: 15,
                            inputDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            dropDownItems: hotels.map((HotelModel value) {
                              return DropdownMenuItem<HotelModel>(
                                value: value,
                                child: Text(
                                  value.hotelsName!,
                                ),
                              );
                            }).toList(),
                            selectedValue: _selectedHotel,
                            onChanged: (value) {
                              setState(() {
                                _selectedHotel = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the phone number';
                            }
                            if (value.length < 10) {
                              return "This phone number is not valid";
                            }
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _dateOfBirth,
                          keyboardType: TextInputType.datetime,
                          validator: (text) {
                            if (text != null) {
                              if (!Validators.isNotEmptyString(text)) {
                                return "Please select the date of birth";
                              }
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          onTap: () => selectDate(),
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Date of birth",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.date_range)),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    gender = Gender.Male;
                                  });
                                },
                                child: Text("Male",
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(color: Colors.white),
                                    backgroundColor: gender == Gender.Male
                                        ? Colors.blue
                                        : Colors.blue.withOpacity(0.4)),
                              ),
                            ),
                            CommonSizes.hSmallSpace,
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      gender = Gender.Female;
                                    });
                                  },
                                  child: Text(
                                    "Female",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: gender == Gender.Female
                                          ? Colors.pink
                                          : Colors.pink.withOpacity(0.4))),
                            )
                          ],
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (isUpdating) {
                                _adminCubit.updateAdmin(
                                    widget.admin!.copyWith(
                                      email: _emailController.text,
                                      userName:
                                          _firstNameController.text.trim() +
                                              " " +
                                              _lastNameController.text.trim(),
                                      phoneNumber:
                                          _phoneNumberController.text.trim(),
                                      birthDate: _dateOfBirth.text,
                                      gender: gender,
                                    ),
                                    _selectedHotel != null
                                        ? _selectedHotel!.hotelsId
                                        : null);
                              } else {
                                _adminCubit.addAdmin(UserModel(
                                    email: _emailController.text,
                                    userName: _firstNameController.text.trim() +
                                        " " +
                                        _lastNameController.text.trim(),
                                    phoneNumber:
                                        _phoneNumberController.text.trim(),
                                    birthDate: _dateOfBirth.text,
                                    gender: gender,
                                    password: _passwordController.text,
                                    createdAt: DateTime.now().toString(),
                                    pushToken: "",
                                    role: 2));
                              }
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
        initialDate: DateTime.now());

    if (picked != null) {
      _dateOfBirth.text = picked.toString().split(" ")[0];
    }
  }
}
