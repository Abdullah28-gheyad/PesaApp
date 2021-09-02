import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pesaapp/models/usermodel.dart';
import 'package:pesaapp/modules/login/cubit/states.dart';
import 'package:pesaapp/shared/constants.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  UserModel userModel ;
  userLoginWithGoogle() {
    emit(LoginWithGoogleLoadingState());
    googleSignIn.signIn().then((value) {
      value.authentication.then((value) {
        print(value.idToken);
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: value.idToken,
          accessToken: value.accessToken,
        );
        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          uId = value.user.uid ;
          userModel = UserModel(phone: '',name: value.user.displayName,password: '' ,email: value.user.email ,uId: value.user.uid,image: value.user.photoURL) ;
          FirebaseFirestore.instance
          .collection('users')
          .doc(value.user.uid)
          .set(userModel.toMap())
          .then((value){
            emit(LoginWithGoogleSuccessState());
          })
          .catchError((error){
            emit(LoginWithGoogleErrorState());
          }) ;
        }).catchError((error) {
          print(error.toString());
          emit(LoginWithGoogleErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        emit(LoginWithGoogleErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(LoginWithGoogleErrorState());
    });
  }

  // userLoginWithFacebook() {
  //   emit(LoginWithFacebookLoadingState());
  //   facebookLogin.logIn(['email']).then((value) {
  //     if (value.status == FacebookLoginStatus.loggedIn)
  //       {
  //         final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(value.accessToken.token);
  //         FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential)
  //         .then((value){
  //           print (value.user.displayName) ;
  //           emit(LoginWithFacebookSuccessState()) ;
  //         })
  //         .catchError((error){
  //           print (error.toString()) ;
  //           emit(LoginWithFacebookErrorState()) ;
  //         });
  //       }
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(LoginWithGoogleErrorState());
  //   });
  // }

  void userLoginWithEmail({
    @required String email,
    @required String password,
  }) {
    emit(LoginWithEmailLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          uId=value.user.uid;
      emit(LoginWithEmailSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LoginWithEmailErrorState());
    });
  }
}
