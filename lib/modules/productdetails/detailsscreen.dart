import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/models/productmodel.dart';
import 'package:pesaapp/shared/components.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel productModel;

  DetailsScreen({this.productModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddProductToCartSuccessState) {
          Fluttertoast.showToast(
              msg: 'Product is added to shop cart successfully',
              backgroundColor: Colors.green,
              textColor: Colors.white ,
            fontSize: 18 ,

          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: NetworkImage(productModel.image),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          productModel.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Text(productModel.description,
                                    style: TextStyle(
                                      fontSize: 15,
                                    )))),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  Text(
                                    '\$ ${productModel.price}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            ConditionalBuilder(
                              condition: state is! AddProductToCartLoadingState,
                              builder: (BuildContext context) {
                                return Expanded(
                                    child: customButton(
                                        function: () {
                                          cubit.addToCart(
                                              productModel: productModel);
                                        },
                                        text: 'ADD'));
                              },
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator()),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
