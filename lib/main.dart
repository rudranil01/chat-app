import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/constants.dart';
import 'package:firebase_project/helper/helper_function.dart';
import 'package:firebase_project/pages/auth/home_page.dart';
import 'package:firebase_project/pages/auth/login_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value){
      if(value!=null){
        setState(() {
          _isSignedIn=value;

        });
        //_isSignedIn=value;


      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),

      debugShowCheckedModeBanner: false,
      home: _isSignedIn? const HomePage() :const LoginPage(),
    );
  }
}
