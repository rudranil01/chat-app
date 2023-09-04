import 'package:firebase_project/helper/helper_function.dart';
import 'package:firebase_project/pages/auth/home_page.dart';
import 'package:firebase_project/pages/auth/login_page.dart';
import 'package:firebase_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/constants.dart';
import 'package:firebase_project/widgets/widgets.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey=GlobalKey<FormState>();
  String email="";
  String password="";
  String fullName="";
  bool _isLoading=false;
  AuthService authService=AuthService();



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //
      // ),
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) : SingleChildScrollView(
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
              Text("Create your account now to chat and explore",
                style:
                TextStyle(fontSize: 15,fontWeight: FontWeight.w400),

                // Image.asset("assets/login.png"),


              ),
              Image.asset("assets/register.png"),
              TextFormField(
                decoration: texInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,


                    )

                ),
                onChanged: (val){
                  setState(() {
                    fullName=val;
                  });

                },

                validator: (val){
                 if(val!.isNotEmpty){
                   return null;
                 }
                 else{
                   return "Name can not be empty";
                 }

                },




              ),
              SizedBox(
                height: 15,
              ),
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
                    return "password must be atleast 6 char long";

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
                    "Register",
                    style:
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    register();
                  },
                ),

              ),

              const SizedBox(
                height: 10,
              ),
              Text.rich(
                  TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black,fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login here',
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap=(){
                            // print('hello');
                            nextScreen(context, const LoginPage());

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

  register() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authService.registerUserWithEmailandPasword(fullName, email, password)
          .then((value) async{
            if(value==true){
              await HelperFunctions.saveUserLoggedInStatus(true);
              await HelperFunctions.saveUserEmailSF(email);
              await HelperFunctions.saveUserNameSF(fullName);
              nextScreenReplace(context, HomePage());



            }
            else{
              showSnackBar(context, Colors.red, value);
              setState(() {
                _isLoading=false;
              });
            }

      });

    }
    //stop
  }



}
