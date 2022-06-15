import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/bloc/shopping_bloc/shopping_bloc_bloc.dart';
import 'src/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Mall App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: BlocProvider(
        create: (context) => ShoppingBloc(),
        child: const HomePage(),
      ),
    );
  }
}
