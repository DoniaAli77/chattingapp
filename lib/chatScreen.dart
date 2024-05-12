import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
 
class ChatScreen extends StatefulWidget { 
  @override 
  _ChatScreenState createState() => _ChatScreenState(); 
} 
 
class _ChatScreenState extends State<ChatScreen> { 
  var messageController = TextEditingController(); 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var fbm = FirebaseMessaging.instance; 
    fbm.requestPermission(); 
  }
  @override 
  Widget build(BuildContext context) { 
    var chatsInstance = FirebaseFirestore.instance 
        .collection("chats") 
        .orderBy("timeCreated", descending: true); 
    var myStream = chatsInstance.snapshots(); 
 
    return Scaffold( 
        appBar: AppBar( 
          backgroundColor: Colors.deepPurple[50],
          title: Text("Chat"), 
          actions: [ 
            Container( 
              margin: EdgeInsets.only(right: 30), 
              child: IconButton( 
                  onPressed: () { 
                    FirebaseAuth.instance.signOut(); 
                  }, 
                  icon: Icon(Icons.logout_rounded)), 
            ) 
          ], 
        ), 
        body: Column(children: [ 
          Expanded( 
            child: StreamBuilder<QuerySnapshot>( 
              stream: myStream, 
              builder: (ctx, strSnapshot) { 
                if (strSnapshot.connectionState == ConnectionState.waiting) { 
                  return Center( 
                    child: CircularProgressIndicator(), 
                  ); 
                } 
                 var myDocuments= [];
                if(strSnapshot.hasData){
                 myDocuments = strSnapshot.data!.docs; 
                }
               
 
                return ListView.builder( 
                  reverse: true, 
                  itemBuilder: (itemCtx, index) { 
                    var document = myDocuments[index].data() as Map; 
                    return ListTile( 
                      title: Text(document["username"]), 
                      subtitle: Text(document['text']), 
                    ); 
                  }, 
                  itemCount: myDocuments.length, 
                ); 
              }, 
            ), 
          ), 
          Container( 
            color: Colors.blueGrey, 
            padding: EdgeInsets.all(5), 
            child: Row( 
              children: [ 
                Expanded( 
                    child: TextField( 
                        controller: messageController, 
                        style: TextStyle(color: Colors.white), 
                        decoration: InputDecoration( 
                            hintText: "Enter your message", 
                            hintStyle: TextStyle(color: Colors.white)))), 
                ElevatedButton( 
                  onPressed: addChat, 
                  child: Text("Send"), 
                )],),)]));
  } 
 
  void addChat() async { 
    var currentUserId = FirebaseAuth.instance.currentUser!.uid; 
    var userData = await 
FirebaseFirestore.instance.collection("users").doc(currentUserId).get(); 
    FirebaseFirestore.instance.collection("chats").doc().set({ 
      "text": messageController.text, 
      "userId": currentUserId, 
      "username": userData.data()!["username"], 
      "timeCreated": Timestamp.now() 
    }); 
    messageController.clear(); 
  }}