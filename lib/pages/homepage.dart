import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/shared/constant.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async{
    await HelperFunction.getUserEmailFromSF().then((value){
      setState(() {
        email = value!;
      });
    });

    await HelperFunction.getUserNameFromSF().then((value){
      setState(() {
        userName = value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName,style: const TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.bold
        ),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: (){
              nextScreen(context, const SearchPage());
          }, icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50,),
          children: [
            Icon(Icons.account_circle, size: 150, color: Colors.grey[700],),
            Text(userName, textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 30),
            const Divider(height: 2,),
            ListTile(
              onTap: (){},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading:  const Icon(Icons.group),
              title: const Text("Groups", style: TextStyle(
                color: Colors.black
              ),),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, ProfilePage(email: email, userName: userName,));
              },
              selectedColor: Theme.of(context).primaryColor,
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
    );
  }
}