import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tristatetest/screen/dashboard/dashboardView.dart';
import 'package:tristatetest/screen/login/loginController.dart';

class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  var _controller = Get.put(LoginController());

  @override
  void initState() {
    _controller.callAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String emailVerification =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email"),
              SizedBox(height: 5),
              TextFormField(
                controller: emailTextController,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter email",
                    hintStyle: TextStyle(fontSize: 14)),
                validator: (value) {
                  if (value.toString().isNotEmpty) {
                    if (RegExp(emailVerification)
                        .hasMatch(value.toString())) {
                      return null;
                    } else {
                      return "Kindly enter valid email!";
                    }
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 10),
              Text("Password"),
              SizedBox(height: 5),
              TextFormField(
                controller: passwordTextController,
                autocorrect: false,
                style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter password",
                    hintStyle: TextStyle(fontSize: 14)),
                validator: (value) {
                  if (value.toString().isNotEmpty) {
                  } else {
                    return "Kindly enter valid passoword!";
                  }
                },
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                 _controller.checkAuthentication(email: emailTextController.text,enterPassword: passwordTextController.text);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 60),
                  padding: EdgeInsets.all(10),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                  child: Center(
                      child: Text(
                        "SUBMIT",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
