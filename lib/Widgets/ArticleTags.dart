import 'package:flutter/material.dart';

class ArticleTags extends StatefulWidget {
  final String tagName;
  final Color foregroundColor;

  const ArticleTags({Key? key, required this.tagName, required this.foregroundColor})
      : super(key: key);

  @override
  State<ArticleTags> createState() => _ArticleTagsState();
}

class _ArticleTagsState extends State<ArticleTags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.tagName == "全國技能競賽" || widget.tagName == "WorldSkills"
                ? Image.asset(
                  "res/${widget.tagName}.png",
              color: widget.foregroundColor,
              alignment: Alignment.bottomRight,
                )
                : Container(),
            Text(
              widget.tagName,
              style: TextStyle(fontSize: 8, color: widget.foregroundColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
