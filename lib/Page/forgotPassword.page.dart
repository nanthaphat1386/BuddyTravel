import 'dart:async';
import 'dart:math';

import 'package:finalproject/Page/login.page.dart';
import 'package:finalproject/Tools/responsive.tools.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:finalproject/API/apiUser.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _recipientController = TextEditingController();
  TextEditingController _otp = TextEditingController(text: '');
  String username = 'buddytravel.io1@gmail.com';
  String password = 'cdhwllrgfcphohbo';

  bool checkMail = false;
  bool isHTML = false;

  String randomstr = '';
  String index = '';

  String generateRandomString(int len) {
    var r = Random();
    const _chars = '1234567890';
    return List.generate(
      len,
      (index) => _chars[r.nextInt(_chars.length)],
    ).join();
  }

  String generateRandomStringIndex() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(5, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  Future mailerSend(String otp) async {
    final smtpServer = gmail(username, password);
    final message =
        Message()
          ..from = Address(username, 'Buddy Travel')
          ..recipients.add(_recipientController.text)
          ..subject = 'ต้องการกู้รหัสผ่านใช่หรือไม่ ??'
          ..text = 'รหัส OTP ของคุณคือ $otp \nรหัสอ้างอิงคือ $index';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE

    // Let's send another message using a slightly different syntax:
    //
    // Addresses without a name part can be set directly.
    // For instance `..recipients.add('destination@example.com')`
    // If you want to display a name part you have to create an
    // Address object: `new Address('destination@example.com', 'Display name part')`
    // Creating and adding an Address object without a name part
    // `new Address('destination@example.com')` is equivalent to
    // adding the mail address as `String`.
    // final equivalentMessage =
    //     Message()
    //       ..from = Address(username, 'Your name 😀')
    //       ..recipients.add(Address('destination@example.com'))
    //       ..ccRecipients.addAll([
    //         Address('destCc1@example.com'),
    //         'destCc2@example.com',
    //       ])
    //       ..bccRecipients.add('bccAddress@example.com')
    //       ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    //       ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    //       ..html =
    //           '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>'
    //       ..attachments = [
    //         FileAttachment(File('exploits_of_a_mom.png'))
    //           ..location = Location.inline
    //           ..cid = '<myimg@3.141>',
    //       ];

    // final sendReport2 = await send(equivalentMessage, smtpServer);

    // Sending multiple messages with the same connection
    //
    // Create a smtp client that will persist the connection
    // var connection = PersistentConnection(smtpServer);

    // // Send the first message
    // await connection.send(message);

    // // send the equivalent message
    // //await connection.send(equivalentMessage);

    // // close the connection
    // await connection.close();
  }

  Future<void> _dialogOTPFailed(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รหัส OTP ไม่ถูกต้อง'),
          content: const Text('กรุณาทำรายการใหม่อีกครั้ง'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text('ตกลง', style: TextStyle(color: HexColor('46BBC7'))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) - kToolbarHeight;

    ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: HexColor('46BBC7'),
      fixedSize: Size(w * 0.5, h * 0.2),
      padding: EdgeInsets.symmetric(horizontal: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    SizedBox inputEmail() {
      return SizedBox(
        width: w * 1,
        height: h * 0.1,
        child: TextField(
          controller: _recipientController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black26, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black26, width: 1.5),
            ),
            hintText: 'อีเมล',
            hintStyle: TextStyle(
              color: HexColor('000000').withOpacity(0.75),
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      );
    }

    SizedBox inputOTP(bool checkEmail) {
      return SizedBox(
        width: w * 0.5,
        child: TextField(
          enabled: checkEmail == true ? true : false,
          controller: _otp,
          maxLength: 6,

          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black26, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black26, width: 1.5),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: HexColor('CEF4F8')),
      backgroundColor: HexColor('CEF4F8'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: w * 1,
            height: h * 0.915,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(top: h * 0.025),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/img/lock_reset.png',
                          ),radius: w*0.275,
                        ),
                        //Icon(Icons.lock_reset_sharp, size: h * 0.275),
                        Text(
                          'ลืมรหัสผ่าน ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.065,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Column(
                            children: [
                              Container(
                                width: w,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'กรุณากรอกอีเมลเพื่อรับ OTP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.045,
                                  ),
                                ),
                              ),
                              SizedBox(height: h * 0.015),
                              inputEmail(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      inputOTP(checkMail),
                                      index.isNotEmpty
                                          ? Text(' รหัสอ้างอิง $index')
                                          : Container(),
                                    ],
                                  ),
                                  Container(
                                    width: w * 0.3,
                                    height: h * 0.08,
                                    child: ElevatedButton(
                                      style: raisedButtonStyle,
                                      onPressed: () {
                                        randomstr = generateRandomString(6);
                                        index = generateRandomStringIndex();
                                        mailerSend(randomstr);
                                        setState(() {
                                          checkMail = true;
                                        });
                                      },
                                      child: Text('รับรหัส OTP'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(bottom: h * 0.025),
                      width: w * 0.9,
                      height: h * 0.1,
                      child: ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed:
                            checkMail
                                ? () {
                                  if (_otp.text.contains(randomstr)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => NewPasswordPage(
                                              email: _recipientController.text,
                                            ),
                                      ),
                                    );
                                  } else {
                                    _dialogOTPFailed(context);
                                  }
                                }
                                : null,
                        child: Text('สร้างรหัสผ่านใหม่'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool check_password = false;
  bool check_password_again = false;
  TextEditingController create_password = TextEditingController();
  TextEditingController check_createPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) - kToolbarHeight;

    ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: HexColor('46BBC7'),
      fixedSize: Size(w * 0.5, h * 0.2),
      padding: EdgeInsets.symmetric(horizontal: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );

    return Scaffold(
      appBar: AppBar(backgroundColor: HexColor('CEF4F8')),
      backgroundColor: HexColor('CEF4F8'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: w,
            height: h * 0.915,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(top: h * 0.025),
                    child: Column(
                      children: [
                        Icon(Icons.lock_reset_sharp, size: h * 0.275),
                        Text(
                          'กรอกรหัสผ่านใหม่ที่ต้องการ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.05,
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        SizedBox(
                          width: w * 0.9,
                          height: h * 0.1,
                          child: TextField(
                            obscureText: check_password == false ? true : false,
                            controller: create_password,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    check_password = !check_password;
                                  });
                                },
                                icon:
                                    check_password == true
                                        ? Icon(Icons.remove_red_eye)
                                        : Icon(Icons.remove_red_eye_outlined),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                  width: 1.5,
                                ),
                              ),
                              hintText: 'รหัสผ่านใหม่',
                              hintStyle: TextStyle(
                                color: HexColor('000000').withOpacity(0.75),
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: w * 0.9,
                          height: h * 0.1,
                          child: TextField(
                            controller: check_createPassword,
                            obscureText:
                                check_password_again == false ? true : false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    check_password_again =
                                        !check_password_again;
                                  });
                                },
                                icon:
                                    check_password_again == true
                                        ? Icon(Icons.remove_red_eye)
                                        : Icon(Icons.remove_red_eye_outlined),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                  width: 1.5,
                                ),
                              ),
                              hintText: 'รหัสผ่านใหม่อีกครั้ง',
                              hintStyle: TextStyle(
                                color: HexColor('000000').withOpacity(0.75),
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(bottom: h * 0.025),
                      width: w * 0.9,
                      height: h * 0.1,
                      child: ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () async {
                          if (create_password.text ==
                              check_createPassword.text) {
                            if (create_password.toString().length > 5) {
                              String result = await createPassword(
                                widget.email,
                                create_password.text,
                              );
                              if (result.contains('TRUE')) {
                                _showMyDialogCreatePassword();
                                Timer(Duration(seconds: 2), () {
                                  Navigator.pop(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (BuildContext context) => Login(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                });
                              } else {
                                _showMyDialogCreatePasswordFailed();
                              }
                            } else {
                              _showMyDialogCreatePasswordFailed();
                            }
                          } else {
                            _showMyDialogCreatePasswordFailed();
                          }
                        },
                        child: Text('สร้างรหัสผ่านใหม่'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialogCreatePassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ทำรายการสำเร็จ'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('คุณได้ทำการเปลี่ยนรหัสเรียบร้อยแล้ว')],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialogCreatePasswordFailed() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ทำรายการไม่สำเร็จ'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('กรุณาตรวจสอบข้อมูลแล้วทำรายการใหม่อีกครั้ง'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
