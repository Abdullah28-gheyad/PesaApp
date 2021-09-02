import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/cubit/cubit.dart';
import 'package:pesaapp/layout/home/cubit/states.dart';
import 'package:pesaapp/shared/components.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = AppCubit.get(context) ;
        nameController.text = cubit.userModel.name ;
        phoneController.text = cubit.userModel.phone ;
        passwordController.text = cubit.userModel.password ;
        emailController.text = cubit.userModel.email ;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Image(
                              image:  NetworkImage(cubit.userModel.image),
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                            CircleAvatar(
                                child: IconButton(
                                    onPressed: () {

                                    },
                                    icon: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ))),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 40,
                      ),
                      if (state is UpdateUserDataLoadingState)
                          LinearProgressIndicator(),
                      if (state is UpdateUserDataLoadingState)
                        SizedBox(height: 10,),
                      customTextFormField(
                          controller: nameController,
                          function: (String value) {
                            if (value.isEmpty) return ' Name cannot be empty';
                            return null;
                          },
                          label: 'Name',
                          prefixIcon: Icons.person),
                      SizedBox(
                        height: 10,
                      ),
                      customTextFormField(
                          controller: phoneController,
                          function: (String value) {
                            if (value.isEmpty) return ' Phone cannot be empty';
                            return null;
                          },
                          label: 'Phone',
                          prefixIcon: Icons.phone,
                          type: TextInputType.number),
                      SizedBox(
                        height: 10,
                      ),
                      customTextFormField(
                          controller: emailController,
                          function: (String value) {
                            if (value.isEmpty) return ' Email cannot be empty';
                            return null;
                          },
                          label: 'Email',
                          prefixIcon: Icons.email,
                          type: TextInputType.emailAddress),
                      SizedBox(
                        height: 10,
                      ),
                      customTextFormField(
                          controller: passwordController,
                          function: (String value) {
                            if (value.isEmpty) return ' Password cannot be empty';
                            return null;
                          },
                          label: 'Password',
                          prefixIcon: Icons.lock,
                          type: TextInputType.visiblePassword,
                          ),
                    SizedBox(
                      height: 20,
                    ) ,
                      OutlinedButton(onPressed: (){
                        if (formkey.currentState.validate())
                          {
                            cubit.updateProfileData(name: nameController.text, phone: phoneController.text, password: passwordController.text , email: emailController.text) ;
                          }
                      }, child: Row(
                        children: [
                          Icon(Icons.edit),
                          Expanded(child: Text('Update Profile Data' , textAlign: TextAlign.center,))
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
