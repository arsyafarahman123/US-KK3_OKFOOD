import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:okfoodd/auth/Register.dart';

import '../home_screen.dart';
import '../service/AuthService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();

  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 180),
        children: [
          Text(
            "Welcome",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 35,
            ),
          ),
          SizedBox(height: 5,),
          Text(
            "Sign in to continue",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700
            ),
          ),
          SizedBox(height: 70,),
          Text(
            "Email",
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Color.fromRGBO(224, 224, 224, 0.6),
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              controller: EmailController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Karinatania@gmail.com"
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text(
            "Password",
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
                color: Color.fromRGBO(224, 224, 224, 0.6),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                      controller: PasswordController,
                        obscureText: hidden,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "**********",
                        )
                    ),
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      hidden = !hidden;
                    });
                  },
                  icon: hidden ? Icon(CupertinoIcons.eye_slash_fill) : Icon(CupertinoIcons.eye_fill),
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          InkWell(
            onTap: () async {
              final message = await AuthService().login(
                  email: EmailController.text,
                  password: PasswordController.text,
              );
              if(message!.contains('Success')){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            child: Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(204, 255, 1, 1),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text("Don't you have an account?", textAlign: TextAlign.center,),
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text("Sign Up from here", style: TextStyle( color: Color.fromRGBO(204, 255, 1, 1),),)
          )
        ],
    ));
  }
}
