import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:s2_0607/Methods/SqlMethod.dart';
import 'package:s2_0607/Screens/ArticleScreen.dart';
import '../Screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  var tagList = [];
  var oriTag = [
    "公告",
    "WorldSkills",
    "全國技能競賽",
    "全國高中技藝競賽",
    "技術交流",
    "問答",
    "建議",
    "閒聊"
  ];
  var imgTag = {
    "公告":"icon1.png",
    "WorldSkills":"WorldSkills.png",
    "全國技能競賽":"全國技能競賽.png",
    "全國高中技藝競賽":"icon4.png",
    "技術交流":"icon5.png",
    "問答":"icon6.png",
    "建議":"icon7.png",
    "閒聊":"icon8.png"
  };
  var isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTagsName();
  }

  void getTagsName() async {
    tagList = await TagsSqlMethod().getAll();
    var sp = await SharedPreferences.getInstance();
    isLogin = sp.getBool("isLogin") ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xffDEEBF7),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      orderByTag.value = "全部貼文";
                      var jsonText = await DefaultAssetBundle.of(context)
                          .loadString("res/Data.json");
                      newsList.value = jsonDecode(jsonText)["文章"];
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "res/AllIcon.png",
                          alignment: Alignment.bottomRight,
                          width: 50,
                        ),
                        const Text(
                          "全部貼文",
                          style:
                              TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  for(var i in oriTag) InkWell(
                    onTap: () async {
                      orderByTag.value = i;
                      var jsonText = await DefaultAssetBundle.of(context)
                          .loadString("res/Data.json");
                      newsList.value = (jsonDecode(jsonText)["文章"] as List)
                          .where((element) =>
                      element["主分類"] == i ||
                          (element["子分類"] != null &&
                              element["子分類"] == i))
                          .toList();
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "res/${imgTag[i]??"AllIcon.png"}",
                          alignment: Alignment.bottomRight,
                          width: 50,
                        ),
                        Text(
                          i,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  for (var i in tagList)
                    isLogin
                        ? InkWell(
                            onTap: () async {
                              orderByTag.value = i["name"];
                              var jsonText = await DefaultAssetBundle.of(context)
                                  .loadString("res/Data.json");
                              newsList.value = (jsonDecode(jsonText)["文章"] as List)
                                  .where((element) =>
                                      element["主分類"] == i["name"] ||
                                      (element["子分類"] != null &&
                                          element["子分類"] == i["name"]))
                                  .toList();
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "res/${imgTag[i["name"]]??"AllIcon.png"}",
                                  alignment: Alignment.bottomRight,
                                  width: 50,
                                ),
                                Text(
                                  i["name"],
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
