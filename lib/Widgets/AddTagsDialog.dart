import 'package:flutter/material.dart';
import 'package:s2_0607/Methods/SqlMethod.dart';

class AddTagsDialog extends StatefulWidget {
  final tags;

  const AddTagsDialog({Key? key, required this.tags}) : super(key: key);

  @override
  State<AddTagsDialog> createState() => _AddTagsDialogState();
}

class _AddTagsDialogState extends State<AddTagsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                child: const Icon(Icons.close),
                onTap: () => Navigator.pop(context),
              ),
            ),
            const Text(
              "請選擇欲新增的標籤",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (var i in widget.tags)
              i == ""
                  ? Container()
                  : InkWell(
                      onTap: () async{
                       if(await TagsSqlMethod().insert(i)){
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("加入成功")));
                       }else{
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("加入失敗")));
                       }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10),
                          child: Text(
                            i,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    )
          ],
        ),
      ),
    );
  }
}
