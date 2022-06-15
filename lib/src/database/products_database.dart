import 'package:path/path.dart' as pp;
import 'package:sqflite/sqflite.dart';
import '../../src/model/product.dart';

class ProductsDatabase {
  // Calling Constructor
  static final ProductsDatabase instance = ProductsDatabase._init();

  // Reference to DB
  static Database? _database;

  // Private Constructor
  ProductsDatabase._init();

  // Open Connection for DB
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('products.db');
    return _database!;
  }

  //  init database with path
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = pp.join(dbPath, filePath);
    // Opening DB
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $tableName ( 
  ${ProductFields.id} $idType, 
  ${ProductFields.name} $textType,
  ${ProductFields.quantity} $integerType,
  ${ProductFields.imageUrl} $textType,
  ${ProductFields.price} $realType
  )
''');
  }

  // insert product into DB
  Future<Product> create(Product product) async {
    final db = await instance.database;

    int count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $tableName WHERE ${ProductFields.name}='${product.name}'"))!;
    if (count > 0) {
      Product newProduct = Product(
          name: product.name,
          quantity: (product.quantity + count),
          price: product.price,
          imageUrl: product.imageUrl);
      // Delete Existing and Add new Entry with updated Quantity
      await delete(product.name);
      final id = await db.insert(tableName, newProduct.toJson());
      return product.copy(
        id: id,
        name: newProduct.name,
        quantitiy: newProduct.quantity,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      );
    } else {
      final id = await db.insert(tableName, product.toJson());
      return product.copy(
        id: id,
        name: product.name,
        quantitiy: product.quantity,
        price: product.price,
        imageUrl: product.imageUrl,
      );
    }
  }

  // Count products from DB
  Future<int> getCount() async {
    final db = await instance.database;
    List<Map<String, Object?>> result = await db.rawQuery(
        "SELECT SUM(${ProductFields.quantity})as total FROM $tableName");
    var count = result.toList()[0]['total'];
    // If not null get count
    if (count != null) {
      int? intCount = count as int;
      return intCount;
    }
    // If null return 0
    return 0;
  }

// Read all cart products
  Future<List<Product>> readAllProducts() async {
    final db = await instance.database;

    const orderBy = '${ProductFields.name} ASC';

    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((json) => Product.fromJson(json)).toList();
  }

  // Delete a Product from Cart
  Future<int> delete(String name) async {
    final db = await instance.database;
    int deletedCount = await db.delete(
      tableName,
      where: '${ProductFields.name} = ?',
      whereArgs: [name],
    );
    return deletedCount;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
