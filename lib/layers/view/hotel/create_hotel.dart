import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hba_management/core/enum.dart';
import 'package:hba_management/core/loaders/loading_overlay.dart';
import 'package:hba_management/core/utils.dart';
import 'package:hba_management/core/utils/size_config.dart';
import 'package:hba_management/layers/bloc/hotel/hotel_cubit.dart';
import 'package:hba_management/layers/data/model/hotel_model.dart';
import 'package:hba_management/layers/view/widgets/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';
import '../../../core/ui/custom_dropdown.dart';
import '../../../injection_container.dart';
import '../../data/model/image_model.dart';
import '../widgets/custom_carousel_slider.dart';

class CreateHotelScreen extends StatefulWidget {
  final HotelModel? hotel;

  CreateHotelScreen({this.hotel});

  @override
  _CreateHotelScreenState createState() => _CreateHotelScreenState();
}

class _CreateHotelScreenState extends State<CreateHotelScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double _rating = 1.0;
  String? _selectedCity = null;
  List<XFile> _images = [];
  List<String> imagesNetworkUrl = [];
  bool isUpdating = false;

  final _hotelCubit = sl<HotelCubit>();

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
            _images = List.from(_images + selectedImages);
          }));
    }
  }

  List<ImageModel> getImages() {
    List<ImageModel> images = List.from(imagesNetworkUrl
        .map((e) => ImageModel(imageType: ImageType.NETWORK, imageUrl: e))
        .toList());
    images.addAll(_images
        .map((e) => ImageModel(imageType: ImageType.FILE, imageUrl: e.path))
        .toList());
    return images;
  }

  void deleteImage(ImageModel image) {
    if (image.imageType == ImageType.FILE) {
      _images.removeWhere((element) => element.path == image.imageUrl);
    } else {
      imagesNetworkUrl.removeWhere((element) => element == image.imageUrl);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.hotel != null) {
      isUpdating = true;
      _nameController.text = widget.hotel!.hotelsName!;
      _descriptionController.text = widget.hotel!.description!;
      _rating = widget.hotel!.rating!;
      _selectedCity = widget.hotel!.address!.split(",")[1].trim();
      if (widget.hotel!.imagesUrl != null) {
        imagesNetworkUrl = List.from(widget.hotel!.imagesUrl!);
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
                  onPressed: () =>
                      _hotelCubit.removeHotel(widget.hotel!.hotelsId!),
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
        child: BlocListener<HotelCubit, HotelState>(
          bloc: _hotelCubit,
          listener: (context, state) {
            if (state is HotelUploading) {
              LoadingOverlay.of(context).show();
            } else if (state is HotelUploaded) {
              LoadingOverlay.of(context).hide();
              _hotelCubit.getHotels();
              Navigator.of(context).pop();
            } else if (state is HotelUploadingError) {
              LoadingOverlay.of(context).hide();
              Utils.showSnackBar(context, state.error);
              _hotelCubit.getHotels();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _images.isNotEmpty || imagesNetworkUrl.isNotEmpty
                      ? CustomCarouselSlider(
                          images: getImages(),
                          onDelete: deleteImage,
                          withDelete: true,
                          startIndex: getImages().length - 1,
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
                    child: Text('Pick Images'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the hotel name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  CustomDropDown<String>(
                    hintText: "Choose City",
                    verticalDropdownPadding: 15,
                    inputDecoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    dropDownItems: Constants.cities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                    selectedValue: _selectedCity,
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
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
                        return 'Please enter the hotel description';
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
                  ElevatedButton(
                    onPressed: () {
                      if ((_formKey.currentState?.validate() ?? false) &&
                          _selectedCity != null &&
                          getImages().isNotEmpty) {
                        if (!isUpdating) {
                          _hotelCubit.addHotel(
                              HotelModel(
                                  hotelsName: _nameController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  rating: _rating,
                                  address: "Syria, ${_selectedCity}"),
                              _images.map((e) => File(e.path)).toList());
                        } else {
                          _hotelCubit.updateHotel(
                              widget.hotel!.copyWith(
                                  hotelsName: _nameController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  rating: _rating,
                                  address: "Syria, ${_selectedCity}"),
                              getImages());
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
