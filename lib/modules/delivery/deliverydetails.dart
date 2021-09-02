import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/modules/delivery/cubit/cubit.dart';
import 'package:pesaapp/modules/delivery/cubit/states.dart';
import 'package:pesaapp/modules/summary/summaryscreen.dart';
import 'package:pesaapp/shared/components.dart';

class DeliveryDetails extends StatelessWidget {
  var streetController = TextEditingController() ;
  var cityController = TextEditingController() ;
  var stateController = TextEditingController() ;
  var countryController = TextEditingController() ;
  var timeController = TextEditingController() ;
  var formKey = GlobalKey<FormState>() ;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>DeliveryCubit(),
      child: BlocConsumer<DeliveryCubit,DeliveryStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = DeliveryCubit.get(context) ;
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image(
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.fill,
                          image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2VDsw-Jv7Spy4Ph2eWcnX26DLCmsB4iPTvgQzLYLDePEwnpqWd2jBhOeIOcZ-hIn5HfI&usqp=CAU')) ,
                      SizedBox(height: 10,) ,
                      Card(
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Delivery Time' , style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
                              ) ,
                              SizedBox(height: 10,) ,
                              RadioListTile(
                                value: 'Standard Delivery',
                                groupValue: cubit.deliveryValue,
                                onChanged: (value) {
                                  cubit.changDeleveryChoice(value) ;
                                },
                                activeColor: Colors.green,
                                title: Text('Standard Delivery',style: TextStyle(fontSize: 24),),
                                subtitle: Text('Order will be delivered between 3 - 5 business days'),
                              ) ,
                              SizedBox(height: 10,),
                              RadioListTile(
                                value: 'Next Day Delivery',
                                groupValue: cubit.deliveryValue,
                                onChanged: (value) {
                                  cubit.changDeleveryChoice(value) ;
                                },
                                activeColor: Colors.green,
                                title: Text('Next Day Delivery',style: TextStyle(fontSize: 24),),
                                subtitle: Text('place your order before 6pm and your items will be delivered the next day'),
                              ) ,
                              SizedBox(height: 10,),
                              RadioListTile(
                                value: 'Nominated Delivery',
                                groupValue: cubit.deliveryValue,
                                onChanged: (value) {
                                  cubit.changDeleveryChoice(value) ;
                                },
                                activeColor: Colors.green,
                                title: Text('Nominated Delivery',style: TextStyle(fontSize: 24),),
                                subtitle: Text('pick a particular date from the calender and order will be delivered on selected date'),
                              ),
                            ],
                          ),
                        ),
                      ) ,
                      SizedBox(height: 10,) ,
                      Card(
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Address', style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
                              ) ,
                              SizedBox(height: 20,) ,
                              customTextFormField(
                                  controller: streetController,
                                  function: (String value)
                                  {
                                    if (value.isEmpty||value=='null')
                                      return 'Please Enter Your Street' ;
                                    if (value.length<15)
                                      return 'Please Enter specific location' ;
                                    return null ;
                                  },
                                  label: 'Street' ,
                                prefixIcon: Icons.streetview
                              ) ,
                              SizedBox(height: 10,) ,
                              customTextFormField(
                                  controller: cityController,
                                  function: (String value)
                                  {
                                    if (value.isEmpty||value=='null')
                                      return 'Please Enter Your City' ;
                                    return null ;
                                  },
                                  label: 'City' ,
                                  prefixIcon: Icons.location_city
                              ) ,
                              SizedBox(height: 10,) ,
                              customTextFormField(
                                  controller: stateController,
                                  function: (String value)
                                  {
                                    if (value.isEmpty||value=='null')
                                      return 'Please Enter Your State' ;
                                    return null ;
                                  },
                                  label: 'State' ,
                                  prefixIcon: Icons.home
                              ) ,
                              SizedBox(height: 10,) ,
                              customTextFormField(
                                  controller: countryController,
                                  function: (String value)
                                  {
                                    if (value.isEmpty||value=='null')
                                      return 'Please Enter Your Country' ;
                                    return null ;
                                  },
                                  label: 'Country' ,
                                  prefixIcon: Icons.flag
                              ) ,
                              if (cubit.deliveryValue=='Nominated Delivery')
                                 SizedBox(height: 10,) ,
                              if (cubit.deliveryValue=='Nominated Delivery')
                              customTextFormField(
                                  controller: timeController,
                                  function: (String value)
                                  {
                                    if (value.isEmpty||value=='null')
                                      return 'Please Enter Time You need to deliver items' ;
                                    return null ;
                                  },
                                  label: 'Time' ,
                                  prefixIcon: Icons.lock_clock,
                                type: TextInputType.datetime,
                                  onTap: (){
                                    showDatePicker(context: context,
                                        initialDate: DateTime.now(), firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2025-05-03')).then((value) => {
                                      timeController.text = value.toString()
                                    });
                                  }
                              ) ,
                                SizedBox(
                                  height: 20,
                                ) ,
                              customButton(function: (){
                                if (formKey.currentState.validate())
                                   {
                                     if (cubit.deliveryValue=='Next Day Delivery')
                                       {
                                          timeController.text = 'The Products will be delivered tomorrow';
                                       }

                                     if (cubit.deliveryValue=='Standard Delivery')
                                     {
                                       timeController.text = 'The Delivery will be in 3-5 days';
                                     }
                                        Navigateto(context, SummaryScreen(city: cityController.text,country: countryController.text,states: stateController.text,street: streetController.text,time: timeController.text,)) ;
                                  }
                              }, text: 'Submit Order') ,
                              SizedBox(
                                height: 50,
                              ) ,

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
