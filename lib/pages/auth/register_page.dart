import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/homepage.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/shared/constant.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_isLoading == true)?
      Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):
      SingleChildScrollView(
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
                  "Create your account to chat and explore", 
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
                  labelText: "Full name",
                  prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor,)
                ),
                onChanged: (val){
                  setState(() {
                    fullName = val;
                  });
                },

                validator: (val){
                  return (val!.isNotEmpty) ?
                  null : "Please enter your full name";
                },
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
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                  onPressed: (){
                    register();
                  }, 
                  child: const Text("Register")
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Login now",
                      style: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        nextScreen(context, const LoginPage());
                      }
                    )
                  ]
                )
              )
              ],
            ),
          ),
        ),
      ),
    );
  }

  register() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerWithEmailAndPassword(fullName, email, password).then((value)async{

        if(value == true){
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUSerEmailSF(email);
          await HelperFunction.saveUserNameSF(fullName);
          nextScreen(context, const HomePage());
        }else{
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}