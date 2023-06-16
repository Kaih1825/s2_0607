import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:s2_0607/Methods/SqlMethod.dart';
import 'package:s2_0607/Screens/ArticleScreen.dart';
import 'package:s2_0607/Widgets/DrawerWidget.dart';
import 'package:s2_0607/Widgets/HeaderWidget.dart';
import 'package:s2_0607/Widgets/HomeListTags.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var newsList = [].obs;
var starArray = [].obs;
var commentCountArray=[].obs;
var commentArray=[].obs;

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _sortByalue = "最新貼文";
  var tagsColor = {
    "WorldSkills": Colors.blue.shade900,
    "全國技能競賽": Colors.purple.shade900,
    "WorldSkills 2022 Special Edition": Colors.red,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parseJson();
  }

  void parseJson() async {
    var jsonText =
        await DefaultAssetBundle.of(context).loadString("res/Data.json");
    newsList.value = jsonDecode(jsonText)["文章"];
    commentCountArray.value = List.filled(newsList.length, 0);
    commentArray.value =
        List.generate(newsList.length, (index) => List.empty(growable: true));
    starArray.value = List.filled(newsList.length, false);
    var tisCommentList = jsonDecode(jsonText)["回應"] as List;
    for (int i = 0; i < tisCommentList.length; i++) {
      commentCountArray[tisCommentList[i]["文章編號"] - 1] += 1;
      commentArray[tisCommentList[i]["文章編號"] - 1].add(tisCommentList[i]);
    }
    newsList.sort((b,a){
      if(a["發文日期"]!=null && b["發文日期"]!=null){
        var aDate=a["發文日期"].toString().split("/");
        var bDate=b["發文日期"].toString().split("/");
        return "${aDate[2]}${aDate[0]}${aDate[1]}".compareTo("${bDate[2]}${bDate[0]}${bDate[1]}");
      }
      else {
        return 0;
      }
    });
    getStar();
    setState(() {});
  }

  void getStar() async {
    for (int i = 0; i < starArray.length; i++) {
      starArray[i] = await ArticleSqlMethod().check(i + 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          key: _scaffoldKey,
          drawer: DrawerWidget(),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                HeaderWidget(scaffoldKey: _scaffoldKey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Color(0xffE9ECF2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: "最後回覆",
                                  child: Row(
                                    children: [
                                      Icon(_sortByalue == "最後回覆"
                                          ? Icons.check
                                          : null),
                                      const Text(
                                        "最後回覆",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: "最熱貼文",
                                  child: Row(
                                    children: [
                                      Icon(_sortByalue == "最熱貼文"
                                          ? Icons.check
                                          : null),
                                      const Text(
                                        "最熱貼文",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: "最新貼文",
                                  child: Row(
                                    children: [
                                      Icon(_sortByalue == "最新貼文"
                                          ? Icons.check
                                          : null),
                                      const Text(
                                        "最新貼文",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: "最舊貼文",
                                  child: Row(
                                    children: [
                                      Icon(_sortByalue == "最舊貼文"
                                          ? Icons.check
                                          : null),
                                      const Text(
                                        "最舊貼文",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            offset: const Offset(0, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onSelected: (value) {
                              _sortByalue = value;
                              if(_sortByalue=="最舊貼文"){
                                newsList.sort((a,b){
                                  if(a["發文日期"]!=null && b["發文日期"]!=null){
                                    var aDate=a["發文日期"].toString().split("/");
                                    var bDate=b["發文日期"].toString().split("/");
                                    return "${aDate[2]}${aDate[0]}${aDate[1]}".compareTo("${bDate[2]}${bDate[0]}${bDate[1]}");
                                  }
                                  else {
                                    return 0;
                                  }
                                });
                              }
                              else if(_sortByalue=="最新貼文"){
                                newsList.sort((b,a){
                                  if(a["發文日期"]!=null && b["發文日期"]!=null){
                                    var aDate=a["發文日期"].toString().split("/");
                                    var bDate=b["發文日期"].toString().split("/");
                                    return "${aDate[2]}${aDate[0]}${aDate[1]}".compareTo("${bDate[2]}${bDate[0]}${bDate[1]}");
                                  }
                                  else {
                                    return 0;
                                  }
                                });
                              }
                              else if(_sortByalue=="最熱貼文"){
                                newsList.sort((a,b){
                                  print(a["文章編號"]);
                                  // print("$count x${commentCountArray[newsList.indexOf(a)]} y ${commentCountArray[newsList.indexOf(b)]}");
                                  // var x=commentCountArray[newsList.indexOf(a)];
                                  // var y=commentCountArray[newsList.indexOf(b)];
                                  if(newsList.indexOf(a)!=-1){
                                    var x=commentCountArray[newsList.indexOf(a)];
                                    var y=commentCountArray[newsList.indexOf(b)];
                                    return x.compareTo(y);
                                  }
                                  return 0;
                                });
                                print(commentCountArray.length);
                              }

                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(_sortByalue),
                                  Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          )),
                      Spacer(),
                      Container(
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Color(0xffE9ECF2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.refresh)))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (newsList[index]["標題"] == null) return Container();
                      var date = newsList[index]["發文日期"].toString().split("/");
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          newsList[index]["標題"],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 5),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 80),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  HomeListTags(
                                                    tagName: newsList[index]
                                                    ["主分類"],
                                                    backgroundColor: tagsColor[
                                                    newsList[index]
                                                    ["主分類"]] ??
                                                        Colors.black,
                                                  ),
                                                  newsList[index]["子分類"] != null
                                                      ? HomeListTags(
                                                    tagName:
                                                    newsList[index]
                                                    ["子分類"],
                                                    backgroundColor:
                                                    tagsColor[newsList[
                                                    index]
                                                    [
                                                    "子分類"]] ??
                                                        Colors.black,
                                                  )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.messenger_outline_rounded,
                                              size: 12,
                                            ),
                                            Obx(() => Text(commentCountArray == null
                                                ? "s"
                                                : commentCountArray[newsList[index]["文章編號"]-1]
                                                .toString()),)
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          newsList[index]["發布者"] ?? "未知",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 8),
                                        ),
                                        Text(
                                          "  發布於${date[2]}年${date[0]}月${date[1]}日",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 8),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: GestureDetector(
                                  child: Obx(
                                        () => starArray[newsList[index]["文章編號"] - 1]
                                        ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                        : const Icon(Icons.favorite_border),
                                  ),
                                  onTap: () {
                                    if (starArray[
                                    newsList[index]["文章編號"] - 1]) {
                                      ArticleSqlMethod()
                                          .remove(newsList[index]["文章編號"]);
                                      getStar();
                                    } else {
                                      ArticleSqlMethod().insert(
                                          newsList[index]["文章編號"],
                                          jsonEncode(newsList[index]),
                                          jsonEncode(commentArray[index]));
                                      getStar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text("已加入我的最愛")));
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Get.to(ArticleScreen(
                            articalId: newsList[index]["文章編號"],
                            articleMap: newsList[index],
                            commentMap: commentArray[index],
                          ));
                        },
                      );
                    },
                    itemCount: newsList.length,
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
