import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_realtime_detection/login_screen.dart';
import 'package:http/http.dart' as http;
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailC= new TextEditingController(text:"");
  TextEditingController passwordC=new TextEditingController(text: "");
  TextEditingController nameC= new TextEditingController(text:"");

  @override

    Widget build(BuildContext context) {
      final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
//        child: Image.asset('assets/logo.png'),
        ),
      );


      final name= TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
//      initialValue: 'safeer@gmail.com',
        style: TextStyle(color: Colors.black),
        controller: nameC,
        decoration: InputDecoration(
          hintText: 'Name',
          labelText: "Name",
          labelStyle: TextStyle(color: Colors.black),

          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),borderSide: BorderSide(color: Colors.black)),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),borderSide: BorderSide(color: Colors.black)),
        ),
      );

      final email = TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
//      initialValue: 'safeer@gmail.com',
        style: TextStyle(color: Colors.black),
        controller: emailC,
        decoration: InputDecoration(
          hintText: 'Email',
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.black),

          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),borderSide: BorderSide(color: Colors.black)),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),borderSide: BorderSide(color: Colors.black)),
        ),
      );

      final password = TextFormField(
        controller: passwordC,
        autofocus: false,
//      initialValue: '',
        obscureText: true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: '',
          labelStyle: TextStyle(color: Colors.black),

          labelText: "Password",
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),borderSide: BorderSide(color: Colors.black)),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );

      final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            loginGetter();
//          Navigator.of(context).pushNamed(HomePage.tag);
          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
          child: Text('Sign Up', style: TextStyle(color: Colors.white)),
        ),
      );

      final forgotLabel = FlatButton(
        child: Text(
          'Sign In',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
//        loginGetter();
          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
            return LoginPage();
          }));
        },
      );

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              name,
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              forgotLabel
            ],
          ),
        ),
      );
    }

  loginGetter(){
    print("herer");
    http.post("https://pure-brushlands-09650.herokuapp.com/users/register",body: json.encode({
      'name':nameC.text,
      "email":emailC.text,
      "password":passwordC.text,
    }),headers: {HttpHeaders.contentTypeHeader:'application/json'}).then((value) {
      print(value.body);
      print("here " +value.statusCode.toString())  ;
      if(value.statusCode==200 && json.decode(value.body)['success']==true){
        print("mazey");
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){
          return LoginPage();
        }));
      }
    });
  }

}
