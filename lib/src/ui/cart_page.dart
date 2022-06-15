import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_mall_app/src/model/product.dart';
import 'package:shopping_mall_app/src/utils/my_constants.dart';
import '../bloc/shopping_bloc/shopping_bloc_bloc.dart';
import '../bloc/shopping_bloc/shopping_bloc_event.dart';
import '../bloc/shopping_bloc/shopping_bloc_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //
  // bool loadingData = true;
  late Size size;
  int totalItems = 0;
  double grandTotal = 0;
  bool cartLoading = true;
  bool isDeleting = false;

  List<Product> products = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    log('CartPage build called..');
    size = MediaQuery.of(context).size;
    return BlocBuilder<ShoppingBloc, ShoppingBlocState>(
        builder: (context, state) {
      if (state is CartLoadedState) {
        cartLoading = false;
        products = state.products;
        // Calculating Total Items
        for (Product product in products) {
          totalItems += product.quantity;
        }
        // Calculating Grand Total
        for (Product product in products) {
          grandTotal += product.quantity * product.price;
        }
      }
      if (state is ShopPageLoadedState) {
        cartLoading = false;
        // cartItems = state.cartData.shopitems;
        // calculateTotalAmount(cartItems);
      }
      if (state is ItemDeleteState) {
        isDeleting = true;
      }
      if (state is ItemDeletedState) {
        log('CartPage: ItemDeletedState');
        isDeleting = false;
      }
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("My Cart"),
          elevation: 0,
          backgroundColor: appBarColor,
        ),
        body: cartLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  cartBody(),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      color: secondarColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Items: $totalItems',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Grand Total: $grandTotal',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      );
    });
  }

  Widget cartBody() {
    return SizedBox(
      // color: Colors.amber,
      height: (size.height - size.height / 12) - 70,
      child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 5),
          // physics: const AlwaysScrollableScrollPhysics(),
          itemCount: products.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => getItem(products[index])),
    );
  }

  // Item for ListView
  Widget getItem(Product product) {
    return isDeleting
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : OrientationBuilder(
            builder: (context, orientation) {
              //
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: orientation == Orientation.portrait
                            ? size.width / 2.5
                            : size.width / 3.5,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(1.0, 2.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                ), //BoxShadow
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(product.imageUrl),
                                      fit: BoxFit.fitWidth,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15)),
                                  ),
                                  // width: size.width / 2.5,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  // width: size.width / 0.70,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          // shopItems.data[index].title,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Price',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '\$${product.price}',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Quantity',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${product.quantity}',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 2,
                          child: IconButton(
                              onPressed: () {
                                // Add event and remove from DB as well
                                log('CartPage: Delete');
                                BlocProvider.value(
                                  value: BlocProvider.of<ShoppingBloc>(context)
                                    ..add(
                                      DeleteItemFromCartEvent(product: product),
                                    ),
                                );
                                setState(() {
                                  products.remove(product);
                                  totalItems -= product.quantity;
                                  grandTotal -=
                                      product.quantity * product.price;
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              )))
                    ],
                  ));
              //
            },
          );
  }
}
