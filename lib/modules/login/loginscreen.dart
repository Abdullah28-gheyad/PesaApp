import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesaapp/layout/home/homescreen.dart';
import 'package:pesaapp/modules/login/cubit/cubit.dart';
import 'package:pesaapp/modules/login/cubit/states.dart';
import 'package:pesaapp/modules/register/registerscreen.dart';
import 'package:pesaapp/shared/components.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginWithEmailSuccessState||state is LoginWithFacebookSuccessState||state is LoginWithGoogleSuccessState)
            {
              Navigatetoandremove(context, LayoutScreen()) ;
            }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text(
                              'Welcome,',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: (){
                                Navigateto(context, RegisterScreen()) ;
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.green, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        customTextFormField(
                          controller: emailController,
                          function: (String value) {
                            if (value.isEmpty) return 'email cannot be empty';
                            return null;
                          },
                          secure: false,
                          label: 'Email',
                          prefixIcon: Icons.email,
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        customTextFormField(
                          controller: passwordController,
                          function: (String value) {
                            if (value.isEmpty) return 'password cannot be empty';
                            return null;
                          },
                          secure: true,
                          label: 'Password',
                          prefixIcon: Icons.lock,
                          type: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Text(
                              'Forget Password?',
                              textAlign: TextAlign.end,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          builder: (BuildContext context)=>customButton(function: () {
                            if (formKey.currentState.validate())
                            {
                              cubit.userLoginWithEmail(email: emailController.text, password: passwordController.text) ;
                            }
                          }, text: 'SIGN IN'),
                          condition: state is!LoginWithEmailLoadingState,
                          fallback: (context)=>Center(child: CircularProgressIndicator()),

                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              '-OR-',
                              style: TextStyle(fontSize: 20),
                            )),
                        SizedBox(
                          height: 20,
                        ),

                        ConditionalBuilder(
                          builder: (BuildContext context) => MaterialButton(
                              onPressed: () {
                                cubit.userLoginWithGoogle();
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(
                                        'https://kgo.googleusercontent.com/profile_vrt_raw_bytes_1587515358_10512.png'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Sign in with Google',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )),
                          condition: state is! LoginWithGoogleLoadingState,
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
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
