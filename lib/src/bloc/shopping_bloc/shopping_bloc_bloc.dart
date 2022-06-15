import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_mall_app/src/database/products_database.dart';
import 'package:shopping_mall_app/src/model/shopping_model.dart';
import 'package:shopping_mall_app/src/repository/shopping_repo.dart';
import '../../model/product.dart';
import 'shopping_bloc_event.dart';
import 'shopping_bloc_state.dart';

class ShoppingBloc extends Bloc<ShoppingBlocEvent, ShoppingBlocState> {
  //
  ShoppingRepo shoppingRepo = ShoppingRepo();
  //
  ShoppingBloc() : super(ShoppingBlocInitial()) {
    on<ShoppingBlocEvent>((event, emit) async {
      if (event is ShoppingInitializedEvent) {
        log('ShoppingBloc: ShopPageInitializedEvent');
        ShoppingModel shoppingModel = await shoppingRepo.getProductsList();
        log('ShoppingBloc: totalRecord: ${shoppingModel.totalRecord}');
        log('ShoppingBloc: totalPage: ${shoppingModel.totalPage}');
        log('ShoppingBloc: data length: ${shoppingModel.data.length}');
        //  We need to display Count on homePage's App Bar Cart
        int cartCount = await ProductsDatabase.instance.getCount();
        emit(ShopPageLoadedState(
            shoppingModel: shoppingModel, cartCount: cartCount));
      }
      if (event is ItemAddingCartEvent) {
        log('ShoppingBloc: ItemAddingCartEvent');
        // Add a product
        await ProductsDatabase.instance.create(event.product);
        // Get no. of products in db
        int cartItemsCount = await ProductsDatabase.instance.getCount();
        emit(ItemAddedCartState(cartItemsCount: cartItemsCount));
      }

      if (event is ItemsViewCartEvent) {
        log('ShoppingBloc: ItemsViewCartEvent');
        List<Product> products =
            await ProductsDatabase.instance.readAllProducts();
        emit(CartLoadedState(products: products));
      }
      if (event is DeleteItemFromCartEvent) {
        emit(ItemDeleteState());
        log('ShoppingBloc: DeleteItemFromCartEvent');
        await ProductsDatabase.instance.delete(event.product.name);
        emit(ItemDeletedState());
      }
    });

    add(ShoppingInitializedEvent());
  }
}
