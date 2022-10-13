import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/homepage.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  const ProfilePage({super.key, required this.email, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text("Profile", style: TextStyle( color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50,),
          children: [
            Icon(Icons.account_circle, size: 150, color: Colors.grey[700],),
            Text(widget.userName, textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 30),
            const Divider(height: 2,),
            ListTile(
              onTap: (){
                nextScreenReplace(context, const HomePage());

              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading:  const Icon(Icons.group),
              title: const Text("Groups", style: TextStyle(
                color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){
                
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading:  const Icon(Icons.person),
              title: const Text("Profile", style: TextStyle(
                color: Colors.black
              ),),
            ),
            ListTile(
              onTap: ()async{
                authService.signout().whenComplete(() => 
                  nextScreenReplace(context, const LoginPage())
                );
              },
              selectedColor: Theme.of(context).primaryColor,
              
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading:  const Icon(Icons.exit_to_app),
              title: const Text("Logout", style: TextStyle(
                color: Colors.black
              ),),
            )

          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:40.0,vertical: 170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                color: Colors.grey[700],
                size: 200,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Full Name:", style: TextStyle(fontSize: 17)),
                  Text(widget.userName, style: const TextStyle(fontSize: 17))
                ],
              ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Email:", style: TextStyle(fontSize: 17)),
                  Text(widget.email, style: const TextStyle(fontSize: 17))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}