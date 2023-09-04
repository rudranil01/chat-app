import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/helper/helper_function.dart';
import 'package:firebase_project/service/database_service.dart';

class AuthService{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  //login
  Future loginwithUserNameandPassword(String email,String password) async{
    try{
      User user=(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        //await DatabaseService(uid: user.uid).updateUserData(fullName, email);



        //don't need to be save

        return true;
      }

    }
    on FirebaseAuthException catch(e){
      //print(e);
      return e.message;
    }

  }






//register
Future registerUserWithEmailandPasword(String fullName,String email,String password) async{
  try{
    User user=(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
    if(user!=null){
      await DatabaseService(uid: user.uid).savingUserData(fullName, email);



      //call database service to update user data now
      return true;
    }

  }
  on FirebaseAuthException catch(e){
    //print(e);
    return e.message;
  }

}

//sign out
Future signOut() async{
  try{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserEmailSF("");
    await HelperFunctions.saveUserNameSF("");
    await firebaseAuth.signOut();






  }
  catch(e){
    return null;

  }

}



}