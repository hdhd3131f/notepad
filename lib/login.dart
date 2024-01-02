import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:notepad/view.dart';
import 'dart:convert' as convert;

import 'package:notepad/signup.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "Images/Noteicon.png",
                width: 150,
                height: 150,
              ),
              Container(
                height: 25,
              ),
              SizedBox(
                width: 700,
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // border: OutlineInputBorder(),
                      hintText: "Email"),
                ),
              ),
              Container(
                height: 5,
              ),
              SizedBox(
                width: 700,
                child: TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // border: OutlineInputBorder(),
                      hintText: "password"),
                ),
              ),
              Container(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          var email = _email.text;
                          var password = _password.text;

                          var url =
                              "https://hadi1412234.000webhostapp.com/API/login.php";
                          var response = await post(Uri.parse(url),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: convert.jsonEncode(<String, String>{
                                'email': '$email',
                                'password': '$password',
                              }));
                          if (response.statusCode == 200) {
                            var jsonResponse =
                                convert.jsonDecode(response.body);
                            if (jsonResponse['hasaccount'] == false) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Password or email is invalid'),
                                    content: Text('Please try again.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        notepad(email: email)),
                              );
                            }
                          }
                        }
                      },
                      child: Text("login"))
                ],
              ),
              Container(
                height: 10,
              ),
              InkWell(
                child: const Text("Sign up"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: login(),
//   ));
// }
