import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/register_page.dart';
import 'package:firebase_project/service/database_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/constants.dart';
import 'package:firebase_project/widgets/widgets.dart';
import 'package:firebase_project/helper/helper_function.dart';
import 'package:firebase_project/pages/auth/login_page.dart';
import 'package:firebase_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/constants.dart';
import 'package:firebase_project/widgets/widgets.dart';
import 'package:firebase_project/pages/auth/home_page.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey=GlobalKey<FormState>();
  String email="";
  String password="";
  bool _isLoading=false;
  AuthService authService=AuthService();
  String fullName="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,

      ),
      body:_isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 80) ,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("GROUPIE",
                style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),

              ),
              SizedBox(
                height: 10,

              ),
              Text("Login now to see what they are talking!",
                style:
                TextStyle(fontSize: 15,fontWeight: FontWeight.w400),

               // Image.asset("assets/login.png"),


              ),
              Image.asset("assets/login.png"),
              TextFormField(
                decoration: texInputDecoration.copyWith(
                  labelText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,


                  )

                ),
                onChanged: (val){
                  setState(() {
                    email=val;
                  });

              },

                validator: (val){
                  return RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val!)
                      ? null
                      : "Please enter a valid email";

                },




              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                obscureText: true,
                decoration: texInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,


                    )

                ),
                validator: (val){
                  if(val!.length <6){
                    return "password must be atleat 6 char long";

                  }
                  else{
                    return null;
                  }

                },







                onChanged: (val){
                  setState(() {
                    password=val;
                  });

                },


              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    "Sign In",
                    style:
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    login();
                  },
                ),

              ),

              const SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.black,fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Register here',
                      style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap=(){
                       // print('hello');
                        nextScreenReplace(context, const RegisterPage());

                      },

                    )
                  ]
                )

              ),

              // ElevatedButton(onPressed: (){
              //   login();
              //
              // }, child: Text('chlorine')),



            ],


          ),

        ),
      ),

      // body: Center(
      //   child: Text('Login page',style: TextStyle(fontSize: 40),)
      // ),
    );
  }

  login() async{
    // if(formKey.currentState!.validate()){
    //
    // }

    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.loginwithUserNameandPassword(email, password)
          .then((value) async{
        if(value==true){
          // await HelperFunctions.saveUserLoggedInStatus(true);
          // await HelperFunctions.saveUserEmailSF(email);
          // await HelperFunctions.saveUserNameSF(fullName);
          QuerySnapshot snapshot=await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);




          nextScreen(context, const HomePage());



        }
        else{
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading=false;
          });
        }

      });

    }

  }
}
