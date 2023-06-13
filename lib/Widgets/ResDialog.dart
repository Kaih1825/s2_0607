import 'package:flutter/material.dart';
import 'package:s2_0607/Methods/SqlMethod.dart';
import 'package:get/get.dart';

class ResDialog extends StatefulWidget {
  const ResDialog({Key? key}) : super(key: key);

  @override
  State<ResDialog> createState() => _ResDialogState();
}

class _ResDialogState extends State<ResDialog> {
  var emailCOntroller = TextEditingController();

  var pwdCOntroller = TextEditingController();

  var nickNmeCOntroller = TextEditingController();

  var gender = "男";

  var emailError;
  var pwdError;

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
          Text(
            "註冊",
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("E-mail"),
                  ),
                  Expanded(
                      child: TextField(
                    controller: emailCOntroller,
                    decoration: InputDecoration(
                      errorText: emailError,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1))),
                  ))
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("密碼"),
                  ),
                  Expanded(
                      child: TextField(
                    controller: pwdCOntroller,
                    decoration: InputDecoration(
                      errorText: pwdError,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1))),
                  ))
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("暱稱"),
                  ),
                  Expanded(
                      child: TextField(
                    controller: nickNmeCOntroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1))),
                  ))
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("性別"),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey,width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButton(
                          value: gender,
                          underline: Container(),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(child: Text("男"),value: "男",),
                            DropdownMenuItem(child: Text("女"),value: "女",),
                          ],
                          onChanged: (value) {
                            gender=value.toString();
                            setState(() { });
                          },

                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () async {
                if(!GetUtils.isEmail(emailCOntroller.text)){
                  emailError="Email格式錯誤";
                  setState(() {});
                  return;
                }
                emailError=null;
                if(!RegExp("^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{7,}\$").hasMatch(pwdCOntroller.text)){
                  pwdError="密碼格式錯誤";
                  setState(() {});
                  return;
                }
                pwdError=null;
                print("ll"+(await UserSqlMethod().insert(
                    emailCOntroller.text, pwdCOntroller.text,
                    nickNmeCOntroller.text, gender)).toString());
              },
              child: Container(
                width: 100,
                color: Color.fromARGB(255, 50, 95, 110),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Text(
                    "註冊",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
