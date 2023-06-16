import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s2_0607/Methods/SqlMethod.dart';
import 'package:s2_0607/Widgets/ResDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HeaderWidget.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  var remember = false;
  var showPwd=true;
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var pwdError="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSp();
  }

  void getSp()async{
    var sp=await SharedPreferences.getInstance();
    emailController.text=sp.getString("tempEmail")??"";
    passwordController.text=sp.getString("tempPwd")??"";
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(50, 0, 142, 255),
          ),
        ),
        Dialog(
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
                "登入",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  color: Colors.blueGrey.shade100,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "會員名稱或郵箱",
                              hintStyle: TextStyle(fontSize: 13)),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextField(
                          controller: passwordController,
                          textAlign: TextAlign.center,
                          obscureText: showPwd,
                          decoration: InputDecoration(
                              suffix: GestureDetector(
                                  onTap: () {showPwd=!showPwd;setState(() {});},
                                  child: Icon(showPwd?Icons.visibility_off:Icons.visibility)),
                              filled: true,
                              fillColor: Colors.white,
                              errorText: pwdError==""?null:pwdError,
                              hintText: "密碼",
                              hintStyle: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            Checkbox(
                                value: remember,
                                onChanged: (value) {
                                  remember = value!;
                                  setState(() {});
                                }),
                            GestureDetector(
                              child: Text("記住我"),
                              onTap: () {
                                remember = !remember;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: InkWell(
                          onTap: ()async{
                            if(remember){
                              var sp=await SharedPreferences.getInstance();
                              sp.setString("tempEmail", emailController.text);
                              sp.setString("tempPwd", passwordController.text);
                              sp.commit();
                            }
                            if(!await UserSqlMethod().login(emailController.text, passwordController.text)){
                              pwdError="帳號或密碼錯誤";
                              setState(() {});
                            }else {
                              var sp=await SharedPreferences.getInstance();
                              sp.setBool("isLogin", true);
                              sp.setString("email", emailController.text);
                              islogin.value=true;
                              Get.back();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            color: Color.fromARGB(255, 50, 95, 110),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              child: Text(
                                "登入",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "忘記密碼？",
                style: TextStyle(fontSize: 13),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  child: Text(
                    "還沒有帳戶？立即註冊",
                    style: TextStyle(fontSize: 13),
                  ),
                  onTap: (){
                    Get.back();
                    Get.dialog(ResDialog());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
