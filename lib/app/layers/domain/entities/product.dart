import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String? description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? brand;
  final String? category;
  final String thumbnail;
  final List<String> images;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    this.description = "",
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.brand = "",
    this.category = "",
    required this.thumbnail,
    required this.images,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    String? brand,
    String? category,
    String? thumbnail,
    List<String>? images,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
