import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/models/categorymodel.dart';
import 'package:pesaapp/models/orderModel.dart';
import 'package:pesaapp/models/productmodel.dart';
import 'package:pesaapp/models/usermodel.dart';
import 'package:pesaapp/modules/account/accountscreen.dart';
import 'package:pesaapp/modules/cart/cartscreen.dart';
import 'package:pesaapp/modules/home/homescreen.dart';
import 'package:pesaapp/shared/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    HomeScreen(),
    CartScreen(),
    AccountScreen(),
  ];
  int currentIndex = 0;

  void changeBottomBar(int index) {
    if (index == 1) {
      getShopCart();
    }
    currentIndex = index;
    emit(AppChangeNavigationBarState());
  }

  List<CategoryModel> categories = [];

  void getCategories() {
    emit(GetCategoriesLoadingState());
    FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        categories.add(CategoryModel.FromJson(element.data()));
      });
      emit(GetCategoriesSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(GetCategoriesErrorState());
    });
  }

  List<ProductModel> products = [];

  void getProducts() {
    emit(GetProductsLoadingState());
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        products.add(ProductModel.FromJson(element.data()));
      });
      emit(GetProductsSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(GetProductsErrorState());
    });
  }


  void addToCart({
    @required ProductModel productModel
  }) {
    emit(AddProductToCartLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('shoppingcart')
        .doc(productModel.id)
        .set(productModel.toMap())
        .then((value) {
      emit(AddProductToCartSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(AddProductToCartErrorState());
    });
  }

  List<int> counters = [];

  List<ProductModel> shopData = [];

  double resultTotal;

  void getShopCart() {
    resultTotal = 0;
    shopData = [];
    counters = [];
    emit(GetShopCartDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('shoppingcart')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        counters.add(1);
        shopData.add(ProductModel.FromJson(element.data()));
        String check = element.data()['price'];
        resultTotal += double.parse(check);
      });
      emit(GetShopCartDataSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(GetShopCartDataErrorState());
    });
  }

  void plusNumber(int index) {
    counters[index]++;
    calcTotal();
    emit(PlusNumberState());
  }

  void minNumber(index) {
    if (counters[index] > 1) {
      counters[index] --;
      calcTotal();
      emit(MinNumberState());
    }
  }

  void calcTotal() {
    resultTotal = 0;
    for (int i = 0; i < counters.length; i++) {
      resultTotal += counters[i] * double.parse(shopData[i].price);
    }
    emit(CalcTotalState());
  }

  void removeItemShopCart({
    @required ProductModel productModel
  }) {
    emit(RemoveProductLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('shoppingcart')
        .doc(productModel.id)
        .delete()
        .then((value) {
      getShopCart();
    })
        .catchError((error) {
      print(error.toString());
      emit(RemoveProductErrorState());
    });
  }

  UserModel userModel;

  void getUserData() {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(GetUserDataSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState());
    });
  }

  void updateProfileData({
    @required String name,
    @required String phone,
    @required String password,
    @required String email,
  }) {
    userModel.name = name;
    userModel.phone = phone;
    userModel.password = password;
    userModel.email = email;
    emit(UpdateUserDataLoadingState());
    FirebaseAuth.instance
        .currentUser
        .updatePassword(password)
        .then((value) {
      FirebaseAuth.instance
          .currentUser
          .updateEmail(email)
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .update(userModel.toMap())
            .then((value) {
          getUserData();
        })
            .catchError((error) {
          print(error.toString());
          emit(UpdateUserDataErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        emit(UpdateUserDataErrorState());
      });
    })
        .catchError((error) {
      print(error.toString());
      emit(UpdateUserDataErrorState());
    });
  }


  void removeAllShopCart() {
    shopData = [];
    emit(RemoveShopCartALLLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('shoppingcart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
      getShopCart();
      emit(RemoveShopCartALLSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(RemoveShopCartALLErrorState());
    });
  }

  List<ProductModel> searchProducts;

  void searchByCategory({
    @required String categoryName,
  }) {
    emit(SearchCategoryLoadingState());
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((value) {
      searchProducts = [];
      value.docs.forEach((element) {
        if (element.data()['categoryName'] == categoryName) {
          searchProducts.add(ProductModel.FromJson(element.data()));
        }
      });
      emit(SearchCategorySuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(SearchCategoryErrorState());
    });
  }

  OrderModel orderModel ;
  void submitOrder({
  @required String street,
  @required String city,
  @required String state,
  @required String country,
  @required String deliveryTime,
  @required String timeNow,
  @required String totalPrice,
})
  {
    orderModel = OrderModel(totalPrice: totalPrice,dateTime: timeNow,city: city,country: country,deliveryTime: deliveryTime,ownerName: userModel.name,state: state,street: street) ;
        emit(OrderModelLoadingState()) ;
        FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('order')
        .add(orderModel.toMap())
        .then((value){
          removeAllShopCart();
          emit(OrderModelSuccessState()) ;
        })
        .catchError((error)
        {
          print (error.toString()) ;
          emit(OrderModelErrorState()) ;
        }) ;
  }

  List<OrderModel> orders;
  void getAllOrders()
  {

    emit(GetAllOrdersLoadingState()) ;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('order')
        .get()
        .then((value){
          orders=[] ;
          value.docs.forEach((element) {
            orders.add(OrderModel.FromJson(element.data())) ;
          });
          emit(GetAllOrdersSuccessState()) ;
    })
        .catchError((error){
          print (error.toString()) ;
       emit(GetAllOrdersErrorState ()) ;
    });
  }
}
