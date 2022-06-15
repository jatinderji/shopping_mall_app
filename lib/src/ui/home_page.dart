import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_mall_app/src/bloc/shopping_bloc/shopping_bloc_event.dart';
import 'package:shopping_mall_app/src/model/product.dart';
import 'package:shopping_mall_app/src/model/shopping_model.dart';
import 'package:shopping_mall_app/src/ui/cart_page.dart';
import 'package:shopping_mall_app/src/utils/my_constants.dart';
import '../bloc/shopping_bloc/shopping_bloc_bloc.dart';
import '../bloc/shopping_bloc/shopping_bloc_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  bool loadingData = true;
  List<ShoppingModel> cartItems = List.empty(growable: true);
  late ShoppingModel shopItems;
  late Size size;
  int cartCount = 0;
  bool isCartLoading = true;
  int productCount = 5;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      log('ScrollListener position.pixels: ${_scrollController.position.pixels}');
      log('ScrollListener.offset: ${_scrollController.offset}');

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //   // Bottom poistion
        if (productCount + 5 <= shopItems.data.length) {
          setState(() {
            productCount += 5;
          });
        } else {
          setState(() {
            productCount =
                productCount + (shopItems.data.length - productCount);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log('HomePage build called..');
    size = MediaQuery.of(context).size;
    return BlocListener<ShoppingBloc, ShoppingBlocState>(
      listener: (context, state) {
        if (state is ShoppingBlocInitial) {
          log("HomePage: ShoppingBlocInitial");
          loadingData = true;
        } else if (state is ShopPageLoadedState) {
          log("HomePage: ShopPageLoadedState");
          shopItems = state.shoppingModel;
          if (productCount > shopItems.data.length) {
            productCount = shopItems.data.length;
          }
          cartCount = state.cartCount;
          loadingData = false;
        }
        if (state is ItemAddedCartState) {
          cartCount = state.cartItemsCount;
          isCartLoading = false;
        }
      },
      child: BlocBuilder<ShoppingBloc, ShoppingBlocState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Shopping Mall"),
                elevation: 0,
                backgroundColor: appBarColor,
                actions: [
                  loadingData
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Stack(children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              // Go to Cart Page
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: BlocProvider.of<ShoppingBloc>(
                                              context)
                                            ..add(ItemsViewCartEvent()),
                                          child: const CartPage(),
                                        ),
                                      ))
                                  .then((value) =>
                                      BlocProvider.of<ShoppingBloc>(context)
                                        ..add(ShoppingInitializedEvent()));
                              //
                            },
                          ),
                          Positioned(
                            top: 3.0,
                            right: 10.0,
                            child: Text(
                              cartCount.toString(),
                              style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                ],
              ),
              body: loadingData
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : homeBody());
        },
      ),
    );
  }

  Widget homeBody() {
    return OrientationBuilder(builder: (context, orientation) {
      return Padding(
        // Bottom Padding is added because of only 5 products don't make scroll good
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: GridView.builder(
          controller: _scrollController,
          itemCount: productCount,
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: orientation == Orientation.portrait
                ? size.width / 2
                : size.width / 3,
            mainAxisExtent: size.width / 2,
            mainAxisSpacing: 35,
            crossAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                color: secondarColor,
                image: DecorationImage(
                    image: NetworkImage(shopItems.data[index].featuredImage),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                  ), //BoxShadow
                ]),
            alignment: Alignment.bottomCenter,
            child: Container(
              height: (size.width / 2) / 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        shopItems.data[index].title,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                            onPressed: () {
                              Product product = Product(
                                name: shopItems.data[index].title,
                                quantity: 1,
                                price: shopItems.data[index].price.toDouble(),
                                imageUrl: shopItems.data[index].featuredImage,
                              );
                              BlocProvider.value(
                                value: BlocProvider.of<ShoppingBloc>(context)
                                  ..add(
                                    ItemAddingCartEvent(product: product),
                                  ),
                              );
                              //
                            },
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.black,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
