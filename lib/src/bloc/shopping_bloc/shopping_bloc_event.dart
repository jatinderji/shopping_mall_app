import 'package:equatable/equatable.dart';
import 'package:shopping_mall_app/src/model/product.dart';

abstract class ShoppingBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ShoppingInitializedEvent extends ShoppingBlocEvent {}

class ItemAddingCartEvent extends ShoppingBlocEvent {
  final Product product;
  ItemAddingCartEvent({required this.product});
}

class ItemsViewCartEvent extends ShoppingBlocEvent {
  ItemsViewCartEvent();
}

class DeleteItemFromCartEvent extends ShoppingBlocEvent {
  final Product product;
  DeleteItemFromCartEvent({required this.product});
}
