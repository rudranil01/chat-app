import 'package:flutter/material.dart';
import 'package:firebase_project/service/auth_service.dart';
 

class MessageTile extends StatefulWidget {

  final String message;
  final String sender;
  final bool sentByMe;




  const MessageTile({Key? key,required this.message,required this.sender,required this.sentByMe}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.only(top:5,bottom: 5,left: widget.sentByMe ? 0:24,right: widget.sentByMe ? 24:0),

      alignment: widget.sentByMe ? Alignment.centerRight: Alignment.centerLeft,

      child: Container(
        //width: 300,
       // margin: EdgeInsets.only(top: 20),

        margin: widget.sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17,bottom: 17,left: 20,right: 20),

        decoration: BoxDecoration(
          borderRadius: widget.sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),



          )
              :  BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),



          ),
          color: widget.sentByMe ? Colors.green[700] : Colors.grey[600],
        ),



        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(widget.sender.toUpperCase(),textAlign: TextAlign.start,style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,

            ),),


            SizedBox(
              height: 6,
            ),
            Text(widget.message,textAlign: TextAlign.start,style: TextStyle(

                fontSize: 15,
              color: Colors.white,

            ),),




          ],

        ),



      ),
    );
  }
}
