import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/helper/helper_function.dart';
import 'package:firebase_project/pages/auth/login_page.dart';
import 'package:firebase_project/pages/profile_page.dart';
import 'package:firebase_project/pages/search_page.dart';
import 'package:firebase_project/service/auth_service.dart';
import 'package:firebase_project/service/database_service.dart';
import 'package:firebase_project/widgets/group_tile.dart';
import 'package:firebase_project/widgets/widgets.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String userName="";
  String email="";
  bool _isLoading=false;
  String groupName="";

  AuthService authService=AuthService();
  Stream? groups;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }
  //string manipulation
  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }



  gettingUserData () async{
    await HelperFunctions.getUserEmailFromSF().then((value){
      setState(() {
        email=value!;
      });
    } );
    await HelperFunctions.getUserNameFromSF().then((value){
      setState(() {
        userName=value!;
      });
    } );
    //getting list of snapshots in the stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups=snapshot;


      });
    }

    );




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions: [
          IconButton(onPressed:(){
            nextScreen(context, const SearchPage());

          }, icon: const Icon(
            Icons.search,
          ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Groups",
          style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white),

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

            Text(userName,textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),


            ),
            SizedBox(
              height: 15,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){},

              selectedColor: Theme.of(context).primaryColor,
              selected: true,
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
                nextScreenReplace(context,  ProfilePage(userName: userName,email: email,));

              },

              selectedColor: Theme.of(context).primaryColor,
              selected: false,
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
      body: groupList(),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);

        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,

        ),


      ),

      //start coding char screen now





    );
  }

  popUpDialog(BuildContext context){

    showDialog(
      barrierDismissible: true,

        context: context,
        builder: (context){
      return AlertDialog(
        title: const Text(
          "Create a group",
          textAlign: TextAlign.center,


        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isLoading==true ? Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
            )
                : TextField(

              onChanged: (val){
                groupName=val;

              },


              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,


                  ),
                  borderRadius: BorderRadius.circular(20),



                ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,


                    ),
                    borderRadius: BorderRadius.circular(20),



                  ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,


                  ),
                  borderRadius: BorderRadius.circular(20),



                ),



              ),
            ),


          ],




        ),
        actions: [

          ElevatedButton(onPressed: (){
            Navigator.of(context).pop();



          }, child: Text("Cancel",
          style: TextStyle(




            color: Colors.white,
          ),),

          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,

          ),),
          ElevatedButton(onPressed: () async {
            if(groupName!=""){
              setState(() {
                _isLoading=true;
              });
              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete((){
                _isLoading=false;
              } );
              Navigator.of(context).pop();
              showSnackBar(context, Colors.green, "hey your group is created successfully");



            }




          }, child: Text("Create",
            style: TextStyle(



              color: Colors.white,
            ),),

            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,

            ),)



        ],




      );


        }

    );



  }


  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData){

          if(snapshot.data['groups']!=null && snapshot.data['groups'].length!=0){
            return ListView.builder(
              itemCount: snapshot.data['groups'].length,
              itemBuilder: (context,index){
                return GroupTile(userName: snapshot.data['fullName'], groupId: getId(snapshot.data['groups'][index]), groupName: getName(snapshot.data['groups'][index]));

              },

            );


          }
          else{

            return noGroupWidget();


          }

        }
        else{
          return  Center(
            child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
          );
        }
      },

    );

  }
  noGroupWidget(){

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },


              child: Icon(Icons.add_circle,color: Colors.grey[75],size: 75,)),
          const SizedBox(
            height: 20,
          ),
          Text("you are not part of any group till now,click on the add icon to create a group",

          textAlign: TextAlign.center,),



        ],

        //Icon(Icons.add_circle,color: Colors.white,size: 75,)
      ),


    );

  }


}
