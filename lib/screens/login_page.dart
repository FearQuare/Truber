import 'package:flutter/material.dart';
import 'package:truber/main.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(){
    if(_usernameController.text == 'admin' && _passwordController.text == 'admin'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Truber')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Something is wrong'),
          content: Text('The username or password is wrong'),
          actions: <Widget>[
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('close'))
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 112.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'C:/dev/projects/Truber/images/truber-truck.jpeg',
                  width: 200,
                  height: 100,
                ),
              ),
              SizedBox(height: 44.0),

              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'enter your username',
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0,),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),

                ),
              ),
              SizedBox(height: 24.0,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: _login,
                child: Text('Log in', style: TextStyle(fontSize: 18.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

