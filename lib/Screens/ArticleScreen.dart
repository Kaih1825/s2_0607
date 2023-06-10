import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:s2_0607/Screens/HomeScreen.dart';
import 'package:s2_0607/Widgets/ArticleTags.dart';
import 'package:s2_0607/Widgets/DrawerWidget.dart';
import 'package:s2_0607/Widgets/HeaderWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Methods/SqlMethod.dart';

class ArticleScreen extends StatefulWidget {
  final articalId;
  final articleMap;
  final commentMap;

  const ArticleScreen(
      {Key? key,
      required this.articalId,
      required this.articleMap,
      required this.commentMap})
      : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final _key = GlobalKey<ScaffoldState>();
  var tagsColor = {
    "WorldSkills": Colors.blue.shade900,
    "全國技能競賽": Colors.purple.shade900,
    "WorldSkills 2022 Special Edition": Colors.red,
  };
  var date = [];
  var deepBlue = Color.fromARGB(255, 12, 47, 107);
  var isHeart = false.obs;
  var showAddFriendPopup = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = widget.articleMap["發文日期"].toString().split("/");
    setState(() {});
    getStar();
  }

  void getStar() async {
    isHeart.value = await SqlMethod().check(widget.articalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(scaffoldKey: _key),
            Container(
              width: double.infinity,
              color: Color.fromARGB(255, 12, 47, 107),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 3.0),
                        child: ArticleTags(
                            tagName: widget.articleMap["主分類"],
                            foregroundColor:
                                tagsColor[widget.articleMap["主分類"]] ??
                                    Colors.black),
                      ),
                      widget.articleMap["子分類"] != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, right: 3.0),
                              child: ArticleTags(
                                  tagName: widget.articleMap["子分類"],
                                  foregroundColor:
                                      tagsColor[widget.articleMap["子分類"]] ??
                                          Colors.black),
                            )
                          : Container(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      widget.articleMap["標題"],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(360),
                                      border: Border.all(
                                          color: deepBlue, width: 1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(
                                      "res/girl.png",
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.articleMap["發布者"] ?? "未知",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            "${date[2]}年${date[0]}月${date[1]}日",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    widget.articleMap["文章內容"] != null
                                        ? Text(
                                            widget.articleMap["文章內容"],
                                            style: TextStyle(fontSize: 12),
                                          )
                                        : GestureDetector(
                                            onTap: () async {
                                              await launchUrl(
                                                  Uri.parse(
                                                      widget.articleMap["連結"]),
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            },
                                            child: Text(
                                              widget.articleMap["連結顯示文字"],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (var i in widget.commentMap)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, right: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        border: Border.all(
                                            color: deepBlue, width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.asset(
                                        "res/girl.png",
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            i["發布者"] ?? "未知",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Text(
                                              "${i["回應日期"].toString().split("/")[2]}年${i["回應日期"].toString().split("/")[0]}月${i["回應日期"].toString().split("/")[1]}日",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: deepBlue),
                                            ),
                                          ),
                                        ],
                                      ),
                                      i["回應內容"] != null
                                          ? Text(
                                              i["回應內容"],
                                              style: TextStyle(fontSize: 12),
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                await launchUrl(
                                                    Uri.parse(widget
                                                        .articleMap["連結"]),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              },
                                              child: Text(
                                                widget.articleMap["連結顯示文字"],
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      showAddFriendPopup = !showAddFriendPopup;
                      setState(() {});
                    },
                  ),
                  showAddFriendPopup && widget.articleMap["發布者"] != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 20),
                          child: Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          border: Border.all(
                                              color: deepBlue, width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.asset(
                                          "res/girl.png",
                                          width: 60,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showAddFriendPopup = !showAddFriendPopup;
                                    setState(() {});
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.articleMap["發布者"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      ElevatedButton(
                                        child: Text(
                                          "加入好友",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ]),
              ),
            ),
            Container(
              width: double.infinity,
              color: deepBlue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("res/message.png", width: 20),
                            Obx(
                              () => GestureDetector(
                                child: Image.asset(
                                  "res/heart.png",
                                  width: 20,
                                  color:
                                      isHeart.value ? Colors.red : Colors.white,
                                ),
                                onTap: () {
                                  if (isHeart.value) {
                                    SqlMethod().remove(widget.articalId);
                                  } else {
                                    SqlMethod().insert(widget.articalId,
                                        widget.articleMap, widget.commentMap);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("已加入我的最愛")));
                                  }
                                  isHeart.value = !isHeart.value;
                                  starArray[widget.articalId - 1] =
                                      isHeart.value;
                                },
                              ),
                            ),
                            Image.asset("res/add.png", width: 20),
                            Image.asset("res/friend.png", width: 20),
                            Image.asset("res/member.png", width: 20),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
