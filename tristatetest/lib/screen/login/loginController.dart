import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:tristatetest/controller/utils.dart';
import 'package:tristatetest/model/loginData.dart';
import 'package:tristatetest/screen/dashboard/dashboardView.dart';

class LoginController extends GetxController {
  List<LoginData> listLoginData = [];
  LoginData selectData = LoginData();

  Map<String, bool> favouriteContacts = {};

  Future<dynamic> callAPI() async {
    String strURL = "https://jsonplaceholder.typicode.com/users";
    Uri requestedURL = Uri.parse(strURL);

    Response response = await get(requestedURL);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> listData = jsonDecode(response.body);
      listLoginData = listData.map((e) => LoginData.fromJson(e)).toList();
      for (LoginData login in listLoginData){
        bool likeStatus = await TriStatePreferences().getBool(login.username!);
        if (likeStatus) {
          favouriteContacts[login.username!] = likeStatus;
        }
      }
    } else {
      print("ERROR");
    }
    //Check Logged IN
    bool isLoggedIn = await TriStatePreferences().getBool("isLoggedIn");
    if (isLoggedIn) {
      Get.to(DashboardView());
    }
    update();
  }

  void checkAuthentication({String email = "", String enterPassword = ""}) {
    selectData = listLoginData.where((element) => element.email == email).first;
    if (selectData.username != null && selectData.phone != null) {
      String txt = selectData.username!.substring(0, 4);
      String phone = selectData.phone!
          .substring(selectData.phone!.length - 4, selectData.phone!.length);
      String password = txt + phone;
      if (password == enterPassword) {
        Get.to(DashboardView());
        TriStatePreferences().setBool("isLoggedIn", true);
      } else {
        showSnackBar(title: "Error",msg: "Wrong password!");
        print("Wrong password!");
      }
    } else {
      print("Invalid Data");
    }
  }

  Widget nameImage({String name = ""}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Colors.grey[300],
      ),
      alignment: Alignment.center,
      height: 50,
      width: 50,
      child: Text(
        getNameText(name),
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  String getNameText(String name) {
    if (name.isNotEmpty) {
      var nameArray = name.trim().toUpperCase().split(' ');
      if (nameArray.length > 1)
        return '${nameArray[0].substring(0, 1)}${nameArray[1].substring(0, 1)}';
      else
        return '${nameArray[0].substring(0, 1)}';
    } else
      return '';
  }

  void showSnackBar({required String title, required String msg}) {
    Get.snackbar(
      title,
      msg,
      titleText: Text(title,style: TextStyle(fontSize: 16,color: Colors.white),),
      messageText: Text(msg,style: TextStyle(fontSize: 16,color: Colors.white),),
      backgroundColor: Colors.black,
      snackPosition: SnackPosition.TOP,
      borderColor: Colors.indigo,
      borderRadius: 0,
      borderWidth: 2,
      barBlur: 0,
    );
    update();
  }
}
