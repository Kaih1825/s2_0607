import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s2_0607/Methods/SqlMethod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommitDialog extends StatefulWidget {
  const CommitDialog({Key? key}) : super(key: key);

  @override
  State<CommitDialog> createState() => _CommitDialogState();
}

class _CommitDialogState extends State<CommitDialog> {
  var commitcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: const Icon(Icons.close),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "回覆",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10),
                child: Text(
                  "回覆內容",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey.shade100,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: commitcontroller,
                    maxLines: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey.shade100,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 50,right: 50,bottom: 10),
                child: InkWell(
                  onTap: ()async{
                    var jsonMap={};
                    var sp=await SharedPreferences.getInstance();
                    var email=sp.getString("email")??"";
                    var res=await UserSqlMethod().getUserInfo(email);
                    jsonMap["發布者"]=res[0]["nick"];
                    var now=DateTime.now().toString().split("-");
                    var date="${now[1]}/${now[2].split(" ")[0]}/${now[0]}";
                    jsonMap["回應日期"]=date;
                    jsonMap["回應內容"]=commitcontroller.text;
                    jsonMap["gender"]=res[0]["gender"];
                    Get.back(result: jsonMap);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 50, 95, 110),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Text(
                        "送出回覆",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
