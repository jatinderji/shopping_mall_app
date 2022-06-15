const String tableName = 'products';

// Define db column names
class ProductFields {
  static final List<String> values = [
    id,
    name,
    quantity,
    price,
    imageUrl,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String quantity = 'quantity';
  static const String price = 'price';
  static const String imageUrl = 'imageUrl';
}

class Product {
  final int? id;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  const Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  Product copy({
    int? id,
    required String name,
    required int quantitiy,
    required double price,
    required String imageUrl,
  }) =>
      Product(
        id: id ?? this.id,
        name: name,
        quantity: quantity,
        price: this.price,
        imageUrl: this.imageUrl,
      );

  static Product fromJson(Map<String, Object?> json) => Product(
        id: json[ProductFields.id] as int?,
        name: json[ProductFields.name] as String,
        quantity: json[ProductFields.quantity] as int,
        price: json[ProductFields.price] as double,
        imageUrl: json[ProductFields.imageUrl] as String,
      );

  Map<String, Object?> toJson() => {
        ProductFields.id: id,
        ProductFields.name: name,
        ProductFields.quantity: quantity,
        ProductFields.price: price,
        ProductFields.imageUrl: imageUrl,
      };
}
