import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/modules/editprofile/editprofile.dart';
import 'package:pesaapp/modules/login/loginscreen.dart';
import 'package:pesaapp/modules/order/orderScreen.dart';
import 'package:pesaapp/shared/components.dart';

class AccountScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if (state is GetAllOrdersLoadingState)
          {
            Navigateto(context, OrderScreen()) ;
          }
      },
      builder: (context,state){
        var cubit = AppCubit.get(context) ;
        return ConditionalBuilder(
          condition: cubit.userModel!=null,
          builder: (BuildContext context)=>Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300])
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(cubit.userModel.image),
                              radius: 50,
                            ),
                          ) ,
                          SizedBox(width: 20,) ,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30,) ,
                                Text(cubit.userModel.name , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis , maxLines: 1,textAlign: TextAlign.center,)
                                ,Text(cubit.userModel.email , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis , maxLines: 1,textAlign: TextAlign.center)
                              ],
                            ),
                          )
                        ],
                      ),
                    ) ,
                    SizedBox(height: 100,) ,
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigateto(context, EditProfileScreen()) ;
                        },
                        child: Row(
                          children: [
                            Icon(Icons.edit,color: Colors.black,) ,
                            SizedBox(width: 10,) ,
                            Text('Edit Profile',style: TextStyle(fontSize: 18 ,),) ,
                            Spacer() ,
                            Icon(Icons.arrow_forward_ios) ,
                            SizedBox(width: 5,),

                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          cubit.getAllOrders() ;
                        },
                        child: Row(
                          children: [
                            Icon(Icons.history,color: Colors.black,) ,
                            SizedBox(width: 10,) ,
                            Text('Order History',style: TextStyle(fontSize: 18 ,),) ,
                            Spacer() ,
                            Icon(Icons.arrow_forward_ios) ,
                            SizedBox(width: 5,),

                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          cubit.currentIndex=0 ;
                          Navigatetoandremove(context, LoginScreen()) ;
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout,color: Colors.black,) ,
                            SizedBox(width: 10,) ,
                            Text('Log Out',style: TextStyle(fontSize: 18 ,),) ,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context)=>Center(child: CircularProgressIndicator()),
        ) ;
      },
    );
  }
}
