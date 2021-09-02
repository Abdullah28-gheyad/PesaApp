import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/models/productmodel.dart';
import 'package:pesaapp/modules/productdetails/detailsscreen.dart';
import 'package:pesaapp/shared/components.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          builder: (BuildContext context) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              elevation: 0.0,
              title: Text('Search Category',style: TextStyle(color: Colors.black),),
            ),
            body: Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    physics: BouncingScrollPhysics(),
                    children: List.generate(cubit.searchProducts.length,
                        (index) => buildProductItem(cubit.searchProducts[index],context)),
                  ),
                )
              ],
            ),
          ),
          condition: cubit.searchProducts != null,
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildProductItem(ProductModel productModel,context) => InkWell(
    onTap: (){
      Navigateto(context, DetailsScreen(productModel: productModel,)) ;
    },
    child: Container(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start ,
              children: [
                Image(
                  image: NetworkImage(productModel.image),
                  height: 100,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  productModel.name,
                  style: TextStyle(fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  productModel.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '\$ ${productModel.price}',
                  style:
                      TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
  );
}
