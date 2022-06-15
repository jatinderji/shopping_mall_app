// To parse this JSON data, do
//
//     final shoppingModel = shoppingModelFromJson(jsonString);

import 'dart:convert';

ShoppingModel shoppingModelFromJson(String str) =>
    ShoppingModel.fromJson(json.decode(str));

String shoppingModelToJson(ShoppingModel data) => json.encode(data.toJson());

class ShoppingModel {
  ShoppingModel({
    required this.status,
    required this.message,
    required this.totalRecord,
    required this.totalPage,
    required this.data,
  });

  final int status;
  final String message;
  final int totalRecord;
  final int totalPage;
  final List<Datum> data;

  factory ShoppingModel.fromJson(Map<String, dynamic> json) => ShoppingModel(
        status: json["status"],
        message: json["message"],
        totalRecord: json["totalRecord"],
        totalPage: json["totalPage"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalRecord": totalRecord,
        "totalPage": totalPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.price,
    required this.featuredImage,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final String slug;
  final String title;
  final String description;
  final int price;
  final String featuredImage;
  final String status;
  final DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        featuredImage: json["featured_image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "title": title,
        "description": description,
        "price": price,
        "featured_image": featuredImage,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}
