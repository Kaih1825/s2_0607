import 'package:flutter/material.dart';

class HomeListTags extends StatefulWidget {
  final String tagName;
  final Color backgroundColor;

  const HomeListTags({Key? key, required this.tagName, required this.backgroundColor})
      : super(key: key);

  @override
  State<HomeListTags> createState() => _HomeListTagsState();
}

class _HomeListTagsState extends State<HomeListTags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13,
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.tagName == "全國技能競賽" || widget.tagName == "WorldSkills"
                ? Image.asset(
                  "res/${widget.tagName}.png",
              color: Colors.white,
              alignment: Alignment.bottomRight,
                )
                : Container(),
            Text(
              widget.tagName,
              style: TextStyle(fontSize: 8, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
