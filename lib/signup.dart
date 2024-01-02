import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:notepad/login.dart';
import 'dart:convert' as convert;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String? selectedGender;
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
              Image.network("Images/Noteicon.png",width: 100,height: 100,),
             Container(height: 5,),
              SizedBox(
                width: 700,
                child: TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black,width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
                      // border: OutlineInputBorder(),
                      hintText: "username"),
                      
                ),
              ),
             Container(height: 5,),
              SizedBox(
                width: 700,
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black,width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
                      // border: OutlineInputBorder(),
                      hintText: "Email"),
                ),
              ),
              Container(height: 5,),
              SizedBox(
                width: 700,
                child: TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black,width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
                      // border: OutlineInputBorder(),
                      hintText: "password"),
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(height: 5,),
                  ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          var name = _name.text;
                          var email = _email.text;
                          var password = _password.text;
                          

                          var url =
                              "https://hadi1412234.000webhostapp.com/API/signup.php";
                          var response = await post(Uri.parse(url),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: convert.jsonEncode(<String, String>{
                                'name': '$name',
                                'email': '$email',
                                'password': '$password',
                                
                              }));
                          if (response.statusCode == 200) {
                            var jsonResponse =
                                convert.jsonDecode(response.body);
                            if (jsonResponse['hasaccount'] == true) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('The Email you entered is already exists'),
                                    content:
                                        Text(' enter a different email to continue.'),
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
  MaterialPageRoute(builder: (context) => login()),
);
                            }
                          }
                        }
                      },
                      child: Text("Sign Up"))
                ],
              ),
              Container(height: 10,),
            InkWell(child: const Text("LogIn"),onTap: (){
              Navigator.push( context, MaterialPageRoute(builder: (context) => login()),);
            },)
            ],
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: SignUp(),
//   ));
// }
