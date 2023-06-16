import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s2_0607/Screens/HomeScreen.dart';
import 'package:s2_0607/Widgets/ResDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginDialog.dart';


var islogin = false.obs;
class HeaderWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HeaderWidget({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getSP()async{
    var sp=await SharedPreferences.getInstance();
    islogin.value=sp.getBool("isLogin")??false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () => widget.scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(Icons.menu)),
        Image.asset(
          "res/logo.png",
          width: 100,
        ),
        Expanded(
          child: Container(
            height: 30,
            decoration: BoxDecoration(
                color: Color(0xffE9ECF2),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "搜尋",
                    hintStyle: TextStyle(fontSize: 13),
                    icon: Icon(
                      Icons.search,
                      size: 13,
                    ),
                    contentPadding: EdgeInsets.only(left: -15, top: -20),
                    prefixIconColor: Colors.grey,
                    border: InputBorder.none),
                onChanged: (value) async {
                  var jsonText = await DefaultAssetBundle.of(context)
                      .loadString("res/Data.json");
                  var articles = jsonDecode(jsonText)["文章"] as List;
                  var searchedArticle = List.empty(growable: true);
                  if (value == "") {
                    newsList.value = articles;
                    return;
                  }
                  for (int i = 0; i < articles.length; i++) {
                    if (articles[i]["標題"]
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      searchedArticle.add(articles[i]);
                    }
                  }
                  newsList(searchedArticle.obs);
                },
              ),
            ),
          ),
        ),
        Obx(() => !islogin.value?Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            child: Text("註冊"),
            onTap: () {
              Get.dialog(ResDialog());
            },
          ),
        ):Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            child: Text("登出"),
            onTap: () async{
              var sp=await SharedPreferences.getInstance();
              sp.setBool("isLogin", false);
              islogin.value=false;
            },
          ),
        )),
        Obx(() => !islogin.value? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            child: Text("登入"),
            onTap: (){
              Get.dialog(LoginDialog());
            },
          ),
        ):Container())
      ],
    );
  }
}
