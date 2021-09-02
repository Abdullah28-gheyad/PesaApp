import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/layout/home/homescreen.dart';
import 'package:pesaapp/models/orderModel.dart';
import 'package:pesaapp/shared/components.dart';

class OrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = AppCubit.get(context) ;
        return ConditionalBuilder(
              builder: (context)=> Scaffold(
                appBar: AppBar(
                  leading: IconButton(onPressed: (){
                    AppCubit.get(context).currentIndex=2 ;
                    Navigatetoandremove(context, LayoutScreen())  ;
                  },
                  icon: Icon(Icons.arrow_back_ios),),
                  title: Text('Your Orders' , style: TextStyle(color: Colors.black),),
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0.0,
                  backgroundColor: Colors.white,

                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                          Expanded(
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                                itemBuilder: (context,index)=>buildOrderItem(orderModel: cubit.orders[index]),
                                separatorBuilder: (context,index)=>SizedBox(height: 20,),
                                itemCount: cubit.orders.length
                            ),
                          )
                    ],
                  ),
                ),
              ),
          condition: cubit.orders!=null,
          fallback: (context)=>Column(
            children: [
              Expanded(flex: 2,
                  child: Image(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNDR88qoMiHftlQkQvDIn74o4KB_vgTb4mhQ&usqp=CAU'))),
              Expanded(
                child: Text('YOU DON\'T HAVE ORDERS !!\N'
                    'GO AND SHOP NOW ' , style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold),),
              )
            ],
          ),
        ) ;
      },
    );
  }

  Widget buildOrderItem(
  {
  @required OrderModel orderModel
}
      )=> Card(
    elevation: 10,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('To: '),
              SizedBox(width: 5,) ,
              Expanded(child: Text(orderModel.ownerName)) ,
            ],
          ) ,
          SizedBox(height: 5,) ,
          Row(
            children: [
              Text('Address:'),
              SizedBox(width: 5,) ,
              Expanded(child: Text('${orderModel.country}/${orderModel.state}/${orderModel.city}/${orderModel.street}')) ,
            ],

          )  ,
          SizedBox(height: 5,) ,
          Row(
            children: [
              Text('Order Time:'),
              SizedBox(width: 5,),
              Expanded(child: Text('${orderModel.dateTime}')),
            ],
          ),
          SizedBox(height: 5,) ,
          Row(
            children: [
              Text('Total Price :'),
              SizedBox(width: 5,),
              Expanded(child: Text('${orderModel.totalPrice}')),
            ],
          ),
          SizedBox(height: 5,) ,
          Row(
            children: [
              Text('Delivery will be in :'),
              SizedBox(width: 5,),
              Expanded(child: Text('${orderModel.deliveryTime}')),
            ],
          ),
        ],
      ),
    ),
  );
}
