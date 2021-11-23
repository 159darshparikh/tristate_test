import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tristatetest/controller/utils.dart';
import 'package:tristatetest/model/loginData.dart';
import 'package:tristatetest/screen/login/loginController.dart';

class DetailsView extends StatefulWidget {
  final LoginData data;
  DetailsView(this.data);
  @override
  DetailsViewState createState() => DetailsViewState();
}

class DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details"),),
      body: SafeArea(
        child: GetBuilder<LoginController>(builder: (controller) {
          bool likeStatus =
              controller.favouriteContacts[widget.data.username] ?? false;
          return Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      controller.nameImage(name: widget.data.name ?? ""),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.name ?? "",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(widget.data.email ?? ""),
                            SizedBox(height: 5),
                            Text(widget.data.phone ?? "")
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.data.likeStatus = !widget.data.likeStatus!;

                            if (widget.data.likeStatus!) {
                              TriStatePreferences()
                                  .setBool(widget.data.username!, true);
                              controller.favouriteContacts[
                              widget.data.username!] = true;
                            } else {
                              TriStatePreferences()
                                  .removePreference(widget.data.username!);
                              controller.favouriteContacts
                                  .remove(widget.data.username!);
                            }
                            likeStatus = widget.data.likeStatus!;

                          });
                        },
                        child: Image.asset(
                          likeStatus
                              ? "asset/images/heart.png"
                              : "asset/images/heart_border.png",
                          width: 25,
                          height: 25,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
