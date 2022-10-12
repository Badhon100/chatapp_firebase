import 'package:chatapp_firebase/shared/constant.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Constants.appName, 
                  style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  "Login now to connect with people", 
                  style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor,)
                ),
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },

                validator: (val){
                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").
                  hasMatch(val!) ?
                  null : "Please enter a valid email";
                },
              ),
              const SizedBox(
                height: 15,
              ),

              TextFormField(
                decoration: textInputDecoration.copyWith(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),
                ),
                obscureText: true,
                validator: (val){
                  if(val!.length < 6){
                    return "Password must be atleast 6 characters";
                  }else{
                    return null;
                  }
                },
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}