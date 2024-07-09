import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hba_management/core/app/state/app_state.dart';
import 'package:hba_management/core/enum.dart';
import 'package:hba_management/core/loaders/loading_overlay.dart';
import 'package:hba_management/core/utils.dart';
import 'package:hba_management/core/utils/size_config.dart';
import 'package:hba_management/layers/bloc/hotel/hotel_cubit.dart';
import 'package:hba_management/layers/bloc/room/room_cubit.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/data/model/room_model.dart';
import 'package:hba_management/layers/view/widgets/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../core/ui/custom_dropdown.dart';
import '../../../injection_container.dart';
import '../../data/model/image_model.dart';
import '../widgets/custom_carousel_slider.dart';

class CreateRoomScreen extends StatefulWidget {
  final RoomsModel? room;

  CreateRoomScreen({this.room});

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  bool withOffer = false;
  double _rating = 2.0;
  String? _selectedRoomType = null;
  ImageModel? image;
  bool isUpdating = false;

  final _roomCubit = sl<RoomCubit>();

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImages =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
            image = ImageModel(
                imageType: ImageType.FILE, imageUrl: selectedImages.path);
          }));
    }
  }

  void deleteImage(ImageModel imageModel) {
    image = null;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.room != null) {
      isUpdating = true;
      _roomNumberController.text = widget.room!.roomNumber!;
      _descriptionController.text = widget.room!.description!;
      _offerController.text = widget.room!.offer!.toString();
      _priceController.text = widget.room!.price!.toString();
      _rating = widget.room!.rating!;
      withOffer = widget.room!.withOffer!;
      _selectedRoomType = widget.room!.type!;
      if (widget.room!.imageUrl != null) {
        image = ImageModel(
            imageType: ImageType.NETWORK, imageUrl: widget.room!.imageUrl!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isUpdating ? "Update" : "Enter"} Hotel Information'),
        actions: [
          isUpdating
              ? IconButton(
                  onPressed: () => _roomCubit.removeRoom(widget.room!),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
              : SizedBox()
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocListener<RoomCubit, RoomState>(
          bloc: _roomCubit,
          listener: (context, state) {
            if (state is RoomUploading) {
              LoadingOverlay.of(context).show();
            } else if (state is RoomUploaded) {
              LoadingOverlay.of(context).hide();
              _roomCubit.getRooms(context);
              Navigator.of(context).pop();
            } else if (state is RoomUploadingError) {
              LoadingOverlay.of(context).hide();
              Utils.showSnackBar(context, state.error);
              _roomCubit.getRooms(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  image != null
                      ? CustomCarouselSlider(
                          images: [image!],
                          onDelete: deleteImage,
                          withDelete: true,
                          startIndex: 0,
                          height: SizeConfig.screenHeight * 0.35,
                          autoScroll: false)
                      : Container(
                          height: SizeConfig.screenHeight * 0.35,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 30,
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: Text('${isUpdating ? "Change" : "Pick"} Image'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _roomNumberController,
                    decoration: InputDecoration(
                      labelText: 'Room Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the room number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Room Price',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the room price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  CustomDropDown<String>(
                    hintText: "Choose Type",
                    verticalDropdownPadding: 15,
                    inputDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    dropDownItems: Constants.room_type.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                    selectedValue: _selectedRoomType,
                    onChanged: (value) {
                      setState(() {
                        _selectedRoomType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the room description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text('Rating', style: TextStyle(fontSize: 16)),
                  Center(
                    child: RatingBar.builder(
                      initialRating: _rating / 2,
                      minRating: 1,
                      glow: false,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating * 2;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text("With Offer", style: TextStyle(fontSize: 16)),
                      Checkbox(
                          value: withOffer,
                          onChanged: (value) {
                            setState(() {
                              withOffer = value!;
                            });
                          }),
                    ],
                  ),
                  Visibility(
                    visible: withOffer,
                    child: TextFormField(
                      controller: _offerController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Offer (%)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the room offer';
                        }
                        if (value == null || int.tryParse(value)! > 90) {
                          return 'Room offer could not be more than 90%';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if ((_formKey.currentState?.validate() ?? false) &&
                          _selectedRoomType != null &&
                          image != null) {
                        if (!isUpdating) {
                          _roomCubit.addRoom(
                              RoomsModel(
                                roomNumber: _roomNumberController.text.trim(),
                                hotelId: Provider.of<AppState>(context,
                                        listen: false)
                                    .hotel
                                    .hotelsId,
                                withOffer: withOffer,
                                offer: withOffer
                                    ? int.tryParse(_offerController.text)
                                    : 0,
                                price:
                                    int.tryParse(_priceController.text.trim()),
                                description: _descriptionController.text.trim(),
                                rating: _rating,
                                type: _selectedRoomType,
                              ),
                              File(image!.imageUrl!));
                        } else {
                          _roomCubit.updateRoom(
                              widget.room!.copyWith(
                                roomNumber: _roomNumberController.text.trim(),
                                hotelId: Provider.of<AppState>(context,
                                        listen: false)
                                    .hotel
                                    .hotelsId,
                                withOffer: withOffer,
                                offer: withOffer
                                    ? int.tryParse(_offerController.text)
                                    : 0,
                                price:
                                    int.tryParse(_priceController.text.trim()),
                                description: _descriptionController.text.trim(),
                                rating: _rating,
                                type: _selectedRoomType,
                              ),
                              image!);
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
}
