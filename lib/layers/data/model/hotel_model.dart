import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

List<HotelModel> getHotelListFromListMap(List<QueryDocumentSnapshot> list) =>
    List<HotelModel>.from(
        list.map((x) => HotelModel.fromQueryDocumentSnapshot(x)));

class HotelModel extends Equatable {
  String? hotelsId;
  String? hotelsName;
  String? address;
  double? rating;
  String? hotelsNameAr;
  String? hotelsImage;
  List<String>? imagesUrl;
  String? description;
  String? hotelManagerId;

  @override
  // TODO: implement props
  List<Object?> get props => [
        this.hotelsId,
      ];

  HotelModel(
      {this.hotelsId,
      this.hotelsName,
      this.address,
      this.rating,
      this.hotelsNameAr,
      this.imagesUrl,
      this.description,
      this.hotelManagerId,
      this.hotelsImage});

  HotelModel.fromJson(Map<String, dynamic> json) {
    hotelsName = json['name'];
    address = json['address'];
    rating = json['rating'] is int ? json['rating'].toDouble() : json['rating'];
    imagesUrl = List<String>.from(json['imagesUrl']);
    description = json['description'];
  }

  HotelModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot json) {
    hotelsId = json.id;
    hotelsName = json['name'];
    address = json['address'];
    rating = json['rating'] is int ? json['rating'].toDouble() : json['rating'];
    hotelsNameAr = json['name'];
    imagesUrl = List<String>.from(json['imagesUrl']);
    hotelsImage = json['imagesUrl'][0];
    description = json['description'];
    hotelManagerId = json.data().toString().contains('hotelManagerId')
        ? json.get("hotelManagerId")
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.hotelsName,
      "address": this.address,
      "rating": this.rating,
      "imagesUrl": imagesUrl,
      "description": this.description,
      "hotelManagerId": this.hotelManagerId ?? ""
    };
  }

  @override
  String toString() {
    return 'HotelModel{hotelsId: $hotelsId, hotelsName: $hotelsName, address: $address, rating: $rating, hotelsNameAr: $hotelsNameAr, hotelsImage: $hotelsImage, imagesUrl: $imagesUrl, description: $description}';
  }

  HotelModel copyWith({
    String? hotelsId,
    String? hotelsName,
    String? address,
    double? rating,
    String? hotelsNameAr,
    String? hotelsImage,
    List<String>? imagesUrl,
    String? description,
    String? hotelManagerId,
  }) {
    return HotelModel(
      hotelsId: hotelsId ?? this.hotelsId,
      hotelsName: hotelsName ?? this.hotelsName,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      hotelsNameAr: hotelsNameAr ?? this.hotelsNameAr,
      hotelsImage: hotelsImage ?? this.hotelsImage,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      description: description ?? this.description,
      hotelManagerId: hotelManagerId ?? this.hotelManagerId,
    );
  }
}
