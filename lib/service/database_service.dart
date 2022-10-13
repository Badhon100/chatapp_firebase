import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = 
  FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection = 
  FirebaseFirestore.instance.collection("groups");


  Future savingUserData (String fullName, String email)async{
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  Future gettingUserData(String email) async{
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }


  //get user groups
  getUserGroups() async{
    return userCollection.doc(uid).snapshots();
  }
  
  //creating a group

  createGroup(String userName, String id, String groupName)async{
    DocumentReference groupDocumentReference = await groupCollection.add(
     {
       "groupName": groupName,
      "groupIcon": "",
      "admin": '${id}_$userName',
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      }
    );
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion((["${groupDocumentReference.id}_$groupName"]))
    });
  }

  //getting the chat
  getChats(String groupId)async{
    return groupCollection.doc(groupId).collection("message").orderBy("time").snapshots();
  }

  //get group admin
  Future getGroupAdmin(String groupId)async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }


  //get group members

  getGroupMembers(groupId)async{
    return groupCollection.doc(groupId).snapshots();
  }

  //search group
  searchGroup(String groupName){
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  //check if the user is already joined the group

  Future<bool> isUserJoined(
    String groupName,
    String groupId,
    String userName,
  )async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupName")){
      return true;
    }else{
      return false;
    }
  }


  //group join or exit

  Future toggleGroupJoin(String groupId, String userName, String groupName) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if(groups.contains("${groupId}_$groupName")){
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });

      await groupDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    }else{
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });

      await groupDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }
}