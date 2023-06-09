import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:s2_0607/Methods/SqlMethod.dart';
import 'package:s2_0607/Widgets/HeaderWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  var _sortByalue = "最後回覆";
  var newsList = [];
  var commentCountArray;
  var commentArray;
  List<bool> starArray = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parseJson();
  }

  void parseJson() async {
    var jsonText =
        await DefaultAssetBundle.of(context).loadString("res/Data.json");
    newsList = jsonDecode(jsonText)["文章"];
    commentCountArray = List.filled(newsList.length, 0);
    commentArray = List.generate(newsList.length, (index) => List.empty(growable: true));
    starArray = List.filled(newsList.length,false);
    var tisCommentList = jsonDecode(jsonText)["回應"] as List;
    for (int i = 0; i < tisCommentList.length; i++) {
      commentCountArray[tisCommentList[i]["文章編號"]] += 1;
      commentArray[tisCommentList[i]["文章編號"]].add(tisCommentList[i]);
    }
    getStar();
    setState(() {});
  }

  void getStar() async {
    for (int i = 0; i < starArray.length; i++) {
      starArray[i] = await SqlMethod().check(i + 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [Text("SS"), Text("ssss")],
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            HeaderWidget(
                scaffoldKey: _scaffoldKey, controller: _searchController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Color(0xffE9ECF2),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
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
                                    "最新貼文回覆",
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
                          setState(() {
                            _sortByalue = value;
                          });
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
                          borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                                        color: Colors.black, fontSize: 12),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.messenger_outline_rounded,
                                    size: 12,
                                  ),
                                  Text(commentCountArray == null
                                      ? "0"
                                      : commentCountArray[index].toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newsList[index]["發布者"] ?? "未知",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                  Text(
                                    "  發布於${date[2]}年${date[0]}月${date[1]}日",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            child: starArray[index]
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(Icons.favorite_border),
                            onTap: () {
                              if (starArray[index]) {
                                SqlMethod().remove(newsList[index]["文章編號"]);
                                getStar();
                              } else {
                                SqlMethod().insert(newsList[index]["文章編號"],
                                    jsonEncode(newsList[index]), jsonEncode(commentArray[index]));
                                getStar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("已加入我的最愛")));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: newsList.length,
              ),
            )
          ],
        ),
      )),
    );
  }
}
