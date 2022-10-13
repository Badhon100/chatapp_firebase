import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({super.key, required this.groupId, required this.groupName, required this.adminName});


  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers()async{
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).
    getGroupMembers(widget.groupId).
    then((value){
      setState(() {
        members = value;
      });
    });
  }

  String getName(String res){
    return res.substring( res.indexOf("_")+1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2)
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0,1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getName(widget.adminName),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                      const Text(
                        "Admin",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                        ),
                      )
                    ],
                  )    
                ],
              ),
            ),
            memberList()
          ],

        ),
      )
    );
  }

  memberList(){
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['members'] != null){
            if(snapshot.data['members'].length != 0){
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['members'].length,
                itemBuilder: (context, index){
                  return (getName(snapshot.data['members'][index]) == getName(widget.adminName))?Container():
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0),
                    child: Container(
                      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2)
              ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:20.0, horizontal: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              getName(snapshot.data['members'][index]).
                              substring(0,1).
                              toUpperCase()
                            ),
                          ),
                          title: Text(getName(snapshot.data['members'][index]),
                          style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black
                        ),
                          ),
                          subtitle: const Text("Member"),
                        ),
                      ),
                    ),
                  );
                }
              );
            }else{
            return const Center(
              child: Text("No members added yet"),
            );
          }
        }
          else{
            return const Center(
              child: Text("No members added yet"),
            );
          }
        }else{
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      }
    );
  }
}