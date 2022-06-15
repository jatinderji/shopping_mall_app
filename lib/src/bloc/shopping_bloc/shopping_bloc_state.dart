import 'package:shopping_mall_app/src/model/product.dart';
import 'package:shopping_mall_app/src/model/shopping_model.dart';

abstract class ShoppingBlocState {}

class ShoppingBlocInitial extends ShoppingBlocState {}

class ShopPageLoadedState extends ShoppingBlocState {
  final ShoppingModel shoppingModel;
  final int cartCount;
  ShopPageLoadedState({required this.shoppingModel, required this.cartCount});
}

class ItemAddingCartState extends ShoppingBlocState {
  final Product product;
  ItemAddingCartState({required this.product});
}

class ItemAddedCartState extends ShoppingBlocState {
  final int cartItemsCount;

  ItemAddedCartState({required this.cartItemsCount});
}

class CartLoadedState extends ShoppingBlocState {
  final List<Product> products;
  CartLoadedState({required this.products});
}

class ItemDeleteState extends ShoppingBlocState {
  ItemDeleteState();
}

class ItemDeletedState extends ShoppingBlocState {
  ItemDeletedState();
}
