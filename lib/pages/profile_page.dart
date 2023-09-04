import 'package:firebase_project/pages/auth/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/helper/helper_function.dart';
import 'package:firebase_project/pages/auth/login_page.dart';
//import 'package:firebase_project/pages/profile_page.dart';
import 'package:firebase_project/pages/search_page.dart';
import 'package:firebase_project/service/auth_service.dart';
import 'package:firebase_project/widgets/widgets.dart';
class ProfilePage extends StatefulWidget {
  String userName;
  String email;

   ProfilePage({Key? key,required this.email,required this.userName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  AuthService authService=AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: Text(
      //     "profile page",style: TextStyle(
      //     color: Colors.indigo,
      //   ),
      //   ),
      // ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),

        ),

      ),

      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,


            ),
            SizedBox(
              height: 15,
            ),

            Text(widget.userName,textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),


            ),

            SizedBox(
              height: 15,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){
                nextScreen(context, const HomePage());


              },

              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(
                  color: Colors.black,
                ),

              ),
            ),
            ListTile(
              onTap: (){
                // authService.signOut().whenComplete((){
                //   nextScreenReplace(context, const ProfilePage());
                // }
                // );

               // nextScreen(context, const ProfilePage());

              },

              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                ),

              ),
            ),
            ListTile(
              onTap: () async{
                authService.signOut().whenComplete((){
                  nextScreenReplace(context, const LoginPage());
                }
                );

              },

              selectedColor: Theme.of(context).primaryColor,
              selected: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black,
                ),

              ),
            ),










          ],

        ),
      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,size: 200,color: Colors.grey[800]
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full name",style: TextStyle(fontSize: 17),),
                Text(widget.userName,style: TextStyle(fontSize: 17),),

              ],



            ),
            const Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email",style: TextStyle(fontSize: 17),),
                Text(widget.email,style: TextStyle(fontSize: 17),),

              ],



            ),



          ],
        ),
      ),





    );
  }
}
