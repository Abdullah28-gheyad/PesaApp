import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/modules/login/loginscreen.dart';
import 'package:pesaapp/shared/blocobserver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized() ;
  await Firebase.initializeApp() ;
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..getCategories()..getProducts()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.blue ,
            unselectedItemColor: Colors.grey ,
            elevation: 15 ,
            backgroundColor: Colors.white ,
            selectedIconTheme: IconThemeData(
              color: Colors.black
            ),
            unselectedIconTheme: IconThemeData(
              color: Colors.grey
            ),

          )
        ),
        home: LoginScreen(),
      ),
    );
  }
}
