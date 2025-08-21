import 'package:finalproject/Page/forgotPassword.page.dart';
import 'package:finalproject/Page/registerFacebook.page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:finalproject/API/apiUser.dart';
import 'package:finalproject/Component/tapBar.dart';
import 'package:finalproject/Page/register.page.dart';
import 'package:finalproject/Tools/responsive.tools.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

  Future facebookLogin() async {
    List<String> idFriend = [];
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
          'user_friends',
          'user_birthday',
        ],
      );
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final getFriends = await FacebookAuth.i.getUserData(
          fields: 'friends,birthday',
        );
        var result_ = await loginFacebook(userData['id']);
        for (int i = 0; i < getFriends['friends']['data'].length; i++) {
          idFriend.add(getFriends['friends']['data'][i]['id']);
        }
        if (result_.isNotEmpty) {
          saveValue(result_);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('กำลังเข้าสู่ระบบ')));
          Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TabBottom()),
            );
          });
        } else {
          String bdate = getFriends['birthday'].toString().replaceAll('/', '-');
          List<String> listBirthDay = bdate.split('-');
          String birthDay =
              '${listBirthDay[1]}-${listBirthDay[0]}-${listBirthDay[2]}';
          saveValueRegisterFacebook(userData, idFriend, birthDay);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterFacebook()),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) - kToolbarHeight;

    SizedBox inputText(String id, TextEditingController text) {
      return SizedBox(
        width: w * 1,
        height: h * 0.07,
        child: TextField(
          obscureText: id == 'email' ? false : true,
          controller: text,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: HexColor('61E0ED'), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: HexColor('61E0ED'), width: 1.5),
            ),
            labelText: id == 'email' ? 'อีเมล' : 'รหัสผ่าน',
            labelStyle: TextStyle(
              color: HexColor('000000').withOpacity(0.75),
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      );
    }

    SizedBox boxHeightText(double x) {
      return SizedBox(height: h * x);
    }

    Container btnLogin() {
      return Container(
        width: w * 1,
        height: h * 0.07,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(HexColor('46BBC7')),
          ),
          onPressed: () async {
            var result = await login(
              _controllerEmail.text,
              _controllerPassword.text,
            );
            if (result.toString().contains("INCORRECT")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง')),
              );
            } else if (result.toString().contains("FALSE")) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('กรุณากรอกอีเมล')));
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('กำลังเข้าสู่ระบบ')));
              Timer(const Duration(seconds: 3), () {
                try {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TabBottom()),
                  );
                } catch (e) {}
              });
            }
          },
          child: Text(
            'เข้าสู่ระบบ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: HexColor('FFFFFF'),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: HexColor('CEF4F8'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: w * 1,
            height: h * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h * 0.085),
                Container(
                  height: h * 0.33,
                  color: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset('assets/img/buddy_travel.png'),
                  ),
                ),
                boxHeightText(0.055),
                Container(
                  height: h * 0.475,
                  width: w * 0.8,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.05,
                        h * 0.03,
                        w * 0.05,
                        h * 0.03,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          inputText('email', _controllerEmail),
                          boxHeightText(0.02),
                          inputText('password', _controllerPassword),
                          boxHeightText(0.01),
                          Container(
                            width: w * 1,
                            height: h * 0.035,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Register(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'สมัครสมาชิก',
                                    style: TextStyle(color: HexColor('61E0ED')),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'ลืมรหัสผ่าน ?',
                                    style: TextStyle(color: HexColor('61E0ED')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          boxHeightText(0.025),
                          btnLogin(),
                          boxHeightText(0.0175),
                          InkWell(
                            onTap: () {
                              facebookLogin();
                            },
                            child: Container(
                              width: w * 0.175,
                              height: h * 0.085,
                              child: FittedBox(
                                child: Icon(
                                  Icons.facebook,
                                  color: HexColor('2A9DFA'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
