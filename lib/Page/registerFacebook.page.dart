import 'dart:async';
import 'dart:io';

import 'package:finalproject/API/apiFriend.dart';
import 'package:finalproject/API/apiUser.dart';
import 'package:finalproject/Component/tapBar.dart';
import 'package:finalproject/Page/login.page.dart';
import 'package:finalproject/Tools/responsive.tools.dart';
import 'package:finalproject/Tools/style.tools.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterFacebook extends StatefulWidget {
  const RegisterFacebook({super.key});

  @override
  State<RegisterFacebook> createState() => _RegisterFacebookState();
}

class _RegisterFacebookState extends State<RegisterFacebook> {
  TextEditingController name = new TextEditingController();
  TextEditingController surname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController dateinput = new TextEditingController();
  String imageFile = '';
  String imageName = '';
  File? imgShow;
  String fb = '';
  List<String> idFriend = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    syncData();
  }

  Future syncData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        name.text = prefs.getString('fName').toString();
        surname.text = prefs.getString('lName').toString();
        email.text = prefs.getString('email').toString();
        fb = prefs.getString('fb').toString();
        dateinput.text = prefs.getString('birthday').toString();
        idFriend = prefs.getStringList('friends')!;
      });
    } catch (e) {}
  }

  void _openCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imgShow = File(pickedFile.path);
        imageFile = pickedFile.path;
        imageName = pickedFile.name;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imgShow = File(pickedFile.path);
        imageFile = pickedFile.path;
        imageName = pickedFile.name;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("โปรดเลือก", style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(height: 1, color: Colors.blue),
                ListTile(
                  onTap: () {
                    _openGallery(context);
                  },
                  title: Text("แกลเลอรี่"),
                  leading: Icon(Icons.account_box, color: Colors.blue),
                ),
                Divider(height: 1, color: Colors.blue),
                ListTile(
                  onTap: () {
                    _openCamera(context);
                  },
                  title: Text("กล้องถ่ายรูป"),
                  leading: Icon(Icons.camera, color: Colors.blue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNotiDialog(
    BuildContext context,
    String str,
    String noti,
    Icon icon,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(str, style: TextStyle(color: HexColor('46BBC7'))),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(height: 1, color: HexColor('46BBC7')),
                ListTile(
                  title: Text(noti),
                  leading: icon,
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ตกลง',
                      style: TextStyle(color: HexColor('46BBC7')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h =
        displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Padding myTextField(String str, Icon icon, TextEditingController text) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
        child: SizedBox(
          width: w * 0.7,
          height: h * 0.07,
          child: TextField(
            controller: text,
            decoration: InputDecoration(
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: icon,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('46BBC7'), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('46BBC7')),
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: str,
              labelStyle: TextStyle(color: HexColor('46BBC7')),
            ),
          ),
        ),
      );
    }

    Padding myTextFieldPs(String str, Icon icon, TextEditingController text) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
        child: SizedBox(
          width: w * 0.7,
          height: h * 0.07,
          child: TextField(
            controller: text,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: icon,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('46BBC7'), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor('46BBC7')),
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: str,
              labelStyle: TextStyle(color: HexColor('46BBC7')),
            ),
          ),
        ),
      );
    }

    Padding myTextFieldDate() {
      return Padding(
        padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.01, w * 0.05, h * 0.01),
        child: TextField(
          controller: dateinput,
          //editing controller of this TextField
          decoration: InputDecoration(
            labelText: "วัน/เดือน/ปีเกิด",
            labelStyle: TextStyle(color: HexColor('46BBC7')),
            prefixIcon: Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Icon(Icons.calendar_month, color: HexColor('46BBC7')),
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('46BBC7'), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('46BBC7')),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          readOnly: true,
          //set it true, so that user will not able to edit text
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2150),
            );

            if (pickedDate != null) {
              String formattedDate = DateFormat(
                'dd-MM-yyyy',
              ).format(pickedDate);
              setState(() {
                dateinput.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}
          },
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [HexColor('CEF4F8'), HexColor('46BBC7')],
          ),
        ),
        width: w,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(0, h * 0.055, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: w * 0.1,
                  color: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              ),
              Container(
                width: w * 0.85,
                height: h * 0.6,
                margin: EdgeInsets.fromLTRB(
                  w * 0.1,
                  h * 0.025,
                  w * 0.1,
                  h * 0.045,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    SizedBox(
                      width: w * 0.35,
                      height: w * 0.35,
                      child:
                          (imgShow == null)
                              ? CircleAvatar(
                                radius: w * 0.25,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: w * 0.25,
                                  backgroundImage: AssetImage(
                                    'assets/img/accountIcon.jpg',
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: w * 0.065,
                                      child: IconButton(
                                        onPressed: () {
                                          _showChoiceDialog(context);
                                        },
                                        icon: Icon(Icons.camera_alt, size: 30),
                                        color: HexColor('46BBC7'),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : CircleAvatar(
                                radius: w * 0.25,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: w * 0.25,
                                  backgroundImage: FileImage(imgShow!),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: w * 0.065,
                                      child: IconButton(
                                        onPressed: () {
                                          _showChoiceDialog(context);
                                        },
                                        icon: Icon(Icons.camera_alt, size: 30),
                                        color: HexColor('46BBC7'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                    ),
                    myTextField(
                      'ชื่อ',
                      Icon(Icons.person, color: HexColor('46BBC7')),
                      name,
                    ),
                    myTextField(
                      'นามสกุล',
                      Icon(Icons.person, color: HexColor('46BBC7')),
                      surname,
                    ),
                    // myTextField(
                    //   'อีเมล',
                    //   Icon(Icons.email, color: HexColor('46BBC7')),
                    //   email,
                    // ),
                    // myTextFieldPs(
                    //   'รหัสผ่าน',
                    //   Icon(Icons.lock, color: HexColor('46BBC7')),
                    //   password,
                    // ),
                    // myTextFieldPs(
                    //   'รหัสผ่านอีกครั้ง',
                    //   Icon(Icons.lock, color: HexColor('46BBC7')),
                    //   password_check,
                    // ),
                    myTextFieldDate(),
                    ButtonTheme(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            HexColor('46BBC7'),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                        ),
                        onPressed: () async {
                          // ignore: prefer_typing_uninitialized_variables
                          var answer;
                          if (imageName == '') {
                            answer = await registerbyFacebook(
                              name,
                              surname,
                              email,
                              dateinput,
                              File(''),
                              imageName,
                              fb,
                            );
                          } else {
                            answer = await registerbyFacebook(
                              name,
                              surname,
                              email,
                              dateinput,
                              imgShow!,
                              imageName,
                              fb,
                            );
                          }

                          if (answer != null) {
                            _showNotiDialog(
                              context,
                              'สำเร็จ',
                              'สมัครสมาชิกสำเร็จ',
                              Icon(
                                Icons.done_outline,
                                color: HexColor('46BBC7'),
                              ),
                            );

                            if (imgShow != null) {
                              UploadImage(imageFile, imageName);
                            }

                            for (int m = 0; m < idFriend.length; m++) {
                              autoAddFriend(
                                answer[0]['M_ID'],
                                idFriend[m],
                                '${answer[0]['M_fName']} ${answer[0]['M_lName']}',
                              );
                            }

                            saveValue(answer);
                            Timer(Duration(seconds: 3), () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (BuildContext context) => TabBottom(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            });
                          } else if (answer == 'test') {
                            _showNotiDialog(
                              context,
                              'แจ้งเตือน',
                              'ไม่สามารถทำรายการได้ เนื่องจากมีอีเมลผู้ใช้งานนี้แล้ว11',
                              Icon(Icons.warning, color: HexColor('46BBC7')),
                            );
                          } else {
                            _showNotiDialog(
                              context,
                              'แจ้งเตือน',
                              'ไม่สามารถทำรายการได้ เนื่องจากมีอีเมลผู้ใช้งานนี้แล้ว',
                              Icon(Icons.warning, color: HexColor('46BBC7')),
                            );
                          }
                        },

                        child: Text(
                          "ยืนยันการสมัครสมาชิก",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
