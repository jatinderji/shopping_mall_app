import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shopping_mall_app/src/model/shopping_model.dart';

class ShoppingRepo {
  static const String productListUrl =
      'http://205.134.254.135/~mobile/MtProject/public/api/product_list.php';

  static const String headerToken =
      'eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz';
  //
  Future<ShoppingModel> getProductsList() async {
    //
    Uri url = Uri.parse(productListUrl);

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'token': headerToken
        },
        body: json.encode({"page": 1, "perPage": 5}),
      );

      if (response.statusCode == 200) {
        ShoppingModel shoppingModel = shoppingModelFromJson(response.body);
        return shoppingModel;
      } else {
        return ShoppingModel(
            status: response.statusCode,
            message: response.body,
            totalRecord: 0,
            totalPage: 0,
            data: []);
      }
      //
    } catch (e) {
      log('ShoppingRepo: $e');
      throw Exception('$e');
    }
    //
  }
  //
}
