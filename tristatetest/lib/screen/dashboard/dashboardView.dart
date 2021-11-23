import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tristatetest/controller/utils.dart';
import 'package:tristatetest/model/loginData.dart';
import 'package:tristatetest/screen/details/detailsView.dart';
import 'package:tristatetest/screen/login/loginController.dart';
import 'package:tristatetest/screen/login/loginView.dart';

class DashboardView extends StatefulWidget {
  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  var _controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("Dashboard"),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_outlined),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              TriStatePreferences().removePreference("isLoggedIn");
              TriStatePreferences().removeAllPreference();
              _controller.favouriteContacts.clear();
              Get.to(LoginView());
            },
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: GetBuilder<LoginController>(builder: (controller) {
          return Container(
            margin: EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: controller.listLoginData.length,
                itemBuilder: (context, index) {
                  LoginData userData = controller.listLoginData[index];
                  bool likeStatus =
                      controller.favouriteContacts[userData.username] ?? false;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsView(userData)),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.nameImage(name: userData.name ?? ""),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData.name ?? "",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(userData.email ?? ""),
                                    SizedBox(height: 5),
                                    Text(userData.phone ?? "")
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    userData.likeStatus = !userData.likeStatus!;
                                    //Store in preferences
                                    if (userData.likeStatus!) {
                                      TriStatePreferences()
                                          .setBool(userData.username!, true);
                                      controller.favouriteContacts[
                                          userData.username!] = true;
                                    } else {
                                      TriStatePreferences()
                                          .removePreference(userData.username!);
                                      controller.favouriteContacts
                                          .remove(userData.username!);
                                    }
                                    likeStatus = userData.likeStatus!;
                                  });
                                },
                                child: Image.asset(
                                  likeStatus
                                      // userData.likeStatus!
                                      ? "asset/images/heart.png"
                                      : "asset/images/heart_border.png",
                                  width: 25,
                                  height: 25,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }),
      ),
    );
  }
}

Future<bool> isFavourite(LoginData userData) async {
  bool status = await TriStatePreferences().getBool(userData.username!);
  if (status) {
    return true;
  } else {
    return false;
  }
}
