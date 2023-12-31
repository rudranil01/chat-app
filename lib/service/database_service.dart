import 'package:cloud_firestore/cloud_firestore.dart';



class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});
  //final CollectionReference userCollection= FirebaseFirestore.instance.collection("users");
  final CollectionReference userCollection=FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection=FirebaseFirestore.instance.collection("groups");

//saving the user data
  Future savingUserData(String fullName,String email) async{
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic":"",
      "uid":uid,




    });





  }
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot=await userCollection.where("email", isEqualTo: email).get();
    return snapshot;





  }
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();

  }

  //creating a group


Future createGroup(String userName,String id,String groupName) async{
    DocumentReference groupDocumentReference = await groupCollection.add(
      {

        "groupName": groupName,
        "groupIcon": "",
        "admin": "${id}_$userName",
        "members": [],
        "groupId": "",
        "recentMessage": "",
        "recentMessageSender": "",

      }
    );
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,

    });

    DocumentReference userDocumentReference = await userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });

  //   //getting the chats
  // getChats(String groupId) async










}
//getting chats
getChats(String groupId) async{
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();

    

}
Future getGroupAdmin(String groupId) async{

    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot['admin'];


}
//get group members
getGroupMembers(groupId) async{
    return groupCollection.doc(groupId).snapshots();


  }
  searchByName(String groupName){
    return groupCollection.where("groupName",isEqualTo: groupName).get();

  }

  Future<bool> isUserJoined(

      String groupName,String groupId,String userName) async {
   // DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference userDocumentReference=userCollection.doc(uid);
    DocumentSnapshot documentSnapshot=await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName")){
      return true;

    }
    else{
      return false;

    }








  }


  //toggling the group join or exit
Future toggleGroupJoin(String groupId,String userName,String groupName) async{

    DocumentReference userDocumentReference= userCollection.doc(uid);
    DocumentReference groupDocumentReference= userCollection.doc(groupId);
    DocumentSnapshot documentSnapshot= await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if(groups.contains("${groupId}_$groupName")){

      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])

      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])

      });



    }

    else{


      await userDocumentReference.update({"groups": FieldValue.arrayUnion(["${groupId}_$groupName"])});
      await userDocumentReference.update({"members": FieldValue.arrayUnion(["${uid}_$userName"])});




    }



}

sendMessage(String groupId, Map<String,dynamic> chatmap) async{
    groupCollection.doc(groupId).collection("messages").add(chatmap);
    groupCollection.doc(groupId).update(
      {

        "recentMessage": chatmap['message'],
        "recentMessageSender": chatmap['sender'],
        "recentMessageTime": chatmap['time'].toString(),






      }



    );


}









}