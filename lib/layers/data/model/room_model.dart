import 'package:cloud_firestore/cloud_firestore.dart';

List<RoomsModel> getRoomListFromListMap(List<QueryDocumentSnapshot> list) =>
    List<RoomsModel>.from(
        list.map((x) => RoomsModel.fromQueryDocumentSnapshot(x)));

class RoomsModel {
  String? id;
  String? imageUrl;
  String? type;
  int? price;
  String? hotelId;
  double? rating;
  String? description;
  String? roomNumber;
  bool? withOffer;
  int? offer;

  RoomsModel(
      {this.id,
      this.imageUrl,
      this.price,
      this.hotelId,
      this.type,
      this.rating,
      this.roomNumber,
      this.withOffer,
      this.offer,
      this.description});

  RoomsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    hotelId = json['hotelId'];
    rating = json['rating'];
    imageUrl = json['imageUrl'];
    type = json['type'];
  }

  RoomsModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot json) {
    id = json.id!;
    price = json['price'];
    hotelId = json['hotelId'];
    rating = json['rating'] is int ? json['rating'].toDouble() : json['rating'];
    imageUrl = json['imageUrl'];
    type = json['type'];
    roomNumber = json['roomNumber'];
    description = json['description'];
    withOffer = json['withOffer'];
    offer = json['offer'];
  }

  Map<String, dynamic> toJson() {
    return {
      "imageUrl": this.imageUrl,
      "type": this.type,
      "price": this.price,
      "hotelId": this.hotelId,
      "rating": this.rating,
      "description": this.description,
      "roomNumber": this.roomNumber,
      "withOffer": this.withOffer,
      "offer": this.withOffer != null && this.withOffer! ? this.offer : 0,
    };
  }

  RoomsModel copyWith({
    String? id,
    String? imageUrl,
    String? type,
    int? price,
    String? hotelId,
    double? rating,
    String? description,
    String? roomNumber,
    bool? withOffer,
    int? offer,
  }) {
    return RoomsModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      price: price ?? this.price,
      hotelId: hotelId ?? this.hotelId,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      roomNumber: roomNumber ?? this.roomNumber,
      withOffer: withOffer ?? this.withOffer,
      offer: offer ?? this.offer,
    );
  }
}
