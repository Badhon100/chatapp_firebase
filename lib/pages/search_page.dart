import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/chat_page.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapShot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName()async{
    await HelperFunction.getUserNameFromSF().then((value){
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String res){
    return res.substring( res.indexOf("_")+1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text("Search",
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
        ),
      ),

      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16)
                    ),
                  )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearchMethod();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading == true? Center(
            child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
          ):
          groupList()
        ],
      ),
    );
  }
  initiateSearchMethod()async{
    if(searchController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await DatabaseService().
      searchGroup(searchController.text).then((snapShot){
        setState(() {
          searchSnapShot = snapShot;
        isLoading = false;
        hasUserSearched = true;
        });
      });

    }
  }

  groupList(){
    return hasUserSearched ?
      ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapShot!.docs.length,
        itemBuilder: (context, index){
          return groupTile(
            userName,
            searchSnapShot!.docs[index]['groupId'],
            searchSnapShot!.docs[index]['groupName'],
            searchSnapShot!.docs[index]['admin']
          );
        }
        ): Container();
  }
  joinedOrNot(String userName, String groupId, String groupName, String admin)async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined = value;
      });
    });
  }

Widget groupTile(
  String userName, String groupId, String groupName, String admin
){
  joinedOrNot(userName, groupId, groupName, admin);
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
    leading: CircleAvatar(
      radius: 30,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        groupName.substring(0,1).toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    ),
    title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold),),
    subtitle: Text("Admin: ${getName(admin)}"),
    trailing: InkWell(
      onTap: ()async{
        await DatabaseService(uid: user!.uid).
        toggleGroupJoin(groupId, userName, groupName);
        if(isJoined){
          setState(() {
            isJoined = !isJoined;
            showSnackBar(context, Colors.green, "Joined the group");
          });
          
          Future.delayed(const Duration(seconds: 2), (){
            nextScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
          });
        }else{
          setState(() {
            isJoined = !isJoined;
            showSnackBar(context, Colors.green, "Left the group $groupName");
          });
        }
      },
      child: isJoined ?
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:  Text(
            "Joined",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ): Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:  Text(
            "Join now",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      )
    ),
  );
}
}



