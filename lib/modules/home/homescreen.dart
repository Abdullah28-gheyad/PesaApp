import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/models/categorymodel.dart';
import 'package:pesaapp/models/productmodel.dart';
import 'package:pesaapp/modules/categorysearch/categorysearchscreen.dart';
import 'package:pesaapp/modules/productdetails/detailsscreen.dart';
import 'package:pesaapp/shared/components.dart';

class HomeScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
     listener: (context,state){
       if (state is SearchCategoryLoadingState)
         {
           Navigateto(context, SearchScreen()) ;
         }
     },
     builder: (context,state){
       var cubit = AppCubit.get(context) ;
       return SafeArea(
         child: Container(
           color: Colors.grey[100],
           child: Padding(
             padding: const EdgeInsets.all(20.0),
             child: SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(height: 30,),
                   Container(
                     clipBehavior: Clip.antiAliasWithSaveLayer,
                     decoration: BoxDecoration(
                       color: Colors.grey[200],
                       borderRadius: BorderRadius.circular(25),
                     ),
                     child: customTextFormField(
                         controller: searchController,
                         function: (String value) {
                           if (value.isEmpty) return 'please enter search word';
                           return null;
                         },
                         label: 'Search',
                         prefixIcon: Icons.search),
                   ),
                   SizedBox(
                     height: 40.0,
                   ),
                   Text(
                     'Categories',
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Container(
                     height: 100,
                     child: ListView.separated(
                       shrinkWrap: true,
                       itemBuilder: (context, index) => categoryItem(cubit.categories[index],context),
                       scrollDirection: Axis.horizontal,
                       physics: BouncingScrollPhysics(),
                       separatorBuilder: (context, index) => SizedBox(
                         width: 10,
                       ),
                       itemCount: cubit.categories.length,
                     ),
                   ),
                   SizedBox(
                     height: 30,
                   ),
                   Row(
                     children: [
                       Text(
                         'Best Selling',
                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                       ),
                       Spacer(),
                       Text(
                         'See All',
                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 30,
                   ),
                   Container(
                     height: 400,
                     child: ListView.separated(
                       shrinkWrap: true,
                       itemBuilder: (context, index) => productItem(cubit.products[index] , context),
                       scrollDirection: Axis.horizontal,
                       physics: BouncingScrollPhysics(),
                       separatorBuilder: (context, index) => SizedBox(
                         width: 20,
                       ),
                       itemCount: cubit.products.length,
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       );
     },
    );
  }

  Widget categoryItem(CategoryModel model,context) => InkWell(
    onTap: (){
      AppCubit.get(context).searchByCategory(categoryName: model.name) ;
    },
    child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              fit: BoxFit.fill,
              image: NetworkImage(
                  model.image),
              height: 60,
              width: 60,
            ),
            SizedBox(
              height: 5,
            ),
            Text(model.name),
          ],
        ),
  );

  Widget productItem(ProductModel model ,context) => InkWell(
    onTap: (){
      Navigateto(context, DetailsScreen(productModel: model,)) ;
    },
    child: Container(
      width: 200,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      model.image),
                  width: 200,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                model.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                model.description,
                style: TextStyle(fontSize: 15, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$ ${model.price}',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              )
            ],
          ),
    ),
  );
}
