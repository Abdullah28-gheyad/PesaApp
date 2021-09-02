import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/layout/home/homescreen.dart';
import 'package:pesaapp/models/productmodel.dart';
import 'package:pesaapp/modules/home/homescreen.dart';
import 'package:pesaapp/shared/components.dart';

class SummaryScreen extends StatelessWidget {
  final String street;
  final String city;
  final String states;
  final String country;
  final String time;
  SummaryScreen({this.states,this.time,this.city,this.country,this.street}) ;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if (state is OrderModelSuccessState )
          {
            Fluttertoast.showToast(msg: 'Order is Submitted Successfully' ,
              fontSize: 20,
              backgroundColor: Colors.green ,
              textColor: Colors.white ,
            )  ;
            AppCubit.get(context).currentIndex=0 ;
            Navigateto(context, LayoutScreen()) ;
          }
      },
      builder: (context,state){
        var cubit = AppCubit.get(context) ;
        return Scaffold(
          appBar: AppBar(
            title: Text('Summary' , style: TextStyle(fontSize: 20,color: Colors.black),),
            elevation: 0.0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 190,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index)=>buildProductItem(cubit.shopData[index],cubit.counters[index]),
                        separatorBuilder: (context,index)=>SizedBox(width: 15,),
                        itemCount: cubit.shopData.length
                    ),
                  ) ,
                  SizedBox(
                    height: 20,
                  ) ,
                  Text('Shipping Address',style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),) ,
                  SizedBox(height: 20,) ,
                  Text(street+',') ,
                  Text(city+',') ,
                  Text(states+','+country) ,
                  SizedBox(height: 20,) ,
                  Text('Delivery Time: ' +time) ,
                  Text('Price is : ' +cubit.resultTotal.toString()) ,
                  SizedBox(height: 30,) ,
                  customButton(function: (){
                    DateTime now = DateTime.now();
                    cubit.submitOrder(street: street, city: city, state: states, country: country, deliveryTime: time, timeNow: now.day.toString()+'-'+now.month.toString()+'-'+now.year.toString(), totalPrice:cubit.resultTotal.toString() ) ;
                  }, text: 'SUBMIT ORDER')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildProductItem(ProductModel model,int count)=>Container(
    width: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(image: NetworkImage(model.image),height: 150,width: 150,fit: BoxFit.fill,),
        SizedBox(height: 5,) ,
        Text(model.name, maxLines: 1,overflow: TextOverflow.ellipsis,) ,
        Row(
          children: [
            Text('\$ ${model.price}' ,style: TextStyle(color: Colors.green), maxLines: 1,overflow: TextOverflow.ellipsis,),
            Spacer() ,
            Text(count.toString())
          ],
        ) ,

      ],
    ),
  ) ;
}
