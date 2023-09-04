import 'package:firebase_project/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({Key? key,
    required this.userName,
    required this.groupId,
    required this.groupName}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: Text(widget.groupId),
    //  subtitle: Text(widget.groupName),
    //
    //  // color: Colors.green,
    // );
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName));
        // nextScreen(context, const ChatPage(
        //   groupId: widget.groupId,
        //
        //   // groupId: widget.groupId,
        //   // groupName: widget.groupName,
        //   // userName: widget.userName,
        //
        //
        //
        //
        //
        // ));
      },
      child: Container(

        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0,1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,fontWeight: FontWeight.w500,

              ),


            ),

          ),

          title: Text(
            widget.groupName,
            style: TextStyle(fontWeight: FontWeight.bold),

          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: TextStyle(
              fontSize: 13,
             // fontWeight: FontWeight.bold,
            ),
          ),
        ),

      ),
    );
  }
}
