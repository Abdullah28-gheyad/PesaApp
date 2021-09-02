import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/modules/delivery/cubit/states.dart';

class DeliveryCubit extends Cubit <DeliveryStates>
{
  DeliveryCubit():super(DeliveryInitialState()) ;
  static DeliveryCubit get(context)=>BlocProvider.of(context) ;
  String deliveryValue = 'Standard Delivery' ;
  void changDeleveryChoice (value)
  {
    deliveryValue = value ;
    emit(ChangeRadioButtonChoice()) ;
  }
}