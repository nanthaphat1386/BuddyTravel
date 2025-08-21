import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

saveValue(var data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('id', data[0]['M_ID']);
  prefs.setString('fName', data[0]['M_fName']);
  prefs.setString('lName', data[0]['M_lName']);
  prefs.setString('email', data[0]['M_Email']);
  prefs.setString('image', data[0]['M_Image']);
  prefs.setString('date', data[0]['M_bDate']);
  prefs.setString('fb', data[0]['FB_ID']);
  if (data[0]['M_Password'] != null) {
    prefs.setString('password', data[0]['M_Password']);
  } else {
    prefs.setString('password','buddytravelv1');
  }
}

saveValueRegisterFacebook(
  var data,
  List<String> friends,
  String birthday,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> str = data['name'].toString().split(' ');
  try {
    prefs.setString('fName', str[0]);
    prefs.setString('lName', str[1]);
    prefs.setString('email', data['email']);
    prefs.setString('fb', data['id']);
    prefs.setString('birthday', birthday);
    prefs.setStringList('friends', friends);
  } catch (e) {}
}

// ignore: non_constant_identifier_names
UploadImage(String fileImage, String imgName) async {
  var formData = dio.FormData.fromMap({
    'file': await dio.MultipartFile.fromFile(fileImage, filename: imgName),
  });
  var response = await Dio()
      .post(
        'https://bdtravel.comsciproject.net/buddy_travel/api/UploadImageToProfile.php',
        data: formData,
      )
      .then((value) => print("Response ==> $value"));
}

Future login(String email, String password) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/login.php',
    );
    var response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );
    data = jsonDecode(response.body);
    if (data.toString().isNotEmpty && data.toString().contains("INCORRECT")) {
    } else if (data.toString().isNotEmpty &&
        data.toString().contains("FALSE")) {
    } else {
      saveValue(data);
    }
  } catch (e) {
    print(e);
  }

  return data;
}

Future<String> createPassword(String email, String password) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/createPassword.php',
    );
    var response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  print(data);
  return data.toString();
}

Future loginFacebook(String id) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/loginFacebook.php',
    );
    var response = await http.post(url, body: {'id': id});
    data = jsonDecode(response.body);
    if (data.isEmpty) {
    } else {
      saveValue(data);
    }
  } catch (e) {
    print(e);
  }

  return data;
}

Future getDetailMember(String id) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getDetailMember.php',
    );
    var response = await http.post(url, body: {'id': id});
    data = jsonDecode(response.body);
  } catch (e) {}

  return data;
}

Future Profile_info(String id) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.profile.php',
    );
    var response = await http.post(url, body: {'id': id});
    var data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      for (int m = 0; m < data[i]['C_Image'].length; m++) {
        if (data[i]['C_Image'][m].toString().startsWith(' ')) {
          data[i]['C_Image'][m] = data[i]['C_Image'][m].toString().replaceFirst(
            RegExp(r' '),
            '',
          );
        }
      }
    }
    return data;
  } catch (e) {}
}

Future<String> register(
  TextEditingController email,
  TextEditingController name,
  TextEditingController surname,
  TextEditingController password,
  TextEditingController dateinput,
  File image,
  String imageName,
) async {
  Uri url = Uri.parse(
    'https://bdtravel.comsciproject.net/buddy_travel/api/register.php',
  );
  var response;
  if (image.path.isEmpty) {
    response = await http.post(
      url,
      body: {
        'fname': name.text.toString(),
        'lname': surname.text.toString(),
        'email': email.text.toString(),
        'password': password.text.toString(),
        'bdate': dateinput.text.toString(),
        'image': '',
      },
    );
  } else {
    response = await http.post(
      url,
      body: {
        'fname': name.text.toString(),
        'lname': surname.text.toString(),
        'email': email.text.toString(),
        'password': password.text.toString(),
        'bdate': dateinput.text.toString(),
        'image':
            'https://bdtravel.comsciproject.net/buddy_travel/Upload/Picture/Profile/$imageName',
      },
    );
  }
  var data = jsonDecode(response.body);
  return data.toString();
}

Future registerbyFacebook(
  TextEditingController name,
  TextEditingController surname,
  TextEditingController email,
  TextEditingController dateinput,
  File image,
  String imageName,
  String idFB,
) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/registerFacebook.php',
    );
    var response;
    if (image.path.isEmpty) {
      response = await http.post(
        url,
        body: {
          'fname': name.text.toString(),
          'lname': surname.text.toString(),
          'email': email.text.toString(),
          'bdate': dateinput.text.toString(),
          'image': '',
          'fb': idFB,
        },
      );
    } else {
      response = await http.post(
        url,
        body: {
          'fname': name.text.toString(),
          'lname': surname.text.toString(),
          'email': email.text.toString(),
          'bdate': dateinput.text.toString(),
          'image':
              'https://bdtravel.comsciproject.net/buddy_travel/Upload/Picture/Profile/$imageName',
          'fb': idFB,
        },
      );
    }
    data = jsonDecode(response.body);
  } catch (e) {}
  print(data);
  return data;
}

Future<String> UpdateProfile(
  String id,
  String name,
  String surname,
  TextEditingController bdate,
  String image,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse(
    'https://bdtravel.comsciproject.net/buddy_travel/api/editprofile.php',
  );
  var response = await http.post(
    url,
    body: {
      'id': id,
      'name': name,
      'surname': surname,
      'date': bdate.text,
      'image': image,
    },
  );
  var data = jsonDecode(response.body);
  if (data.toString().contains('TRUE')) {
    prefs.setString('fName', name);
    prefs.setString('lName', surname);
    prefs.setString('date', bdate.text);
    prefs.setString('image', image);
  }
  return data.toString();
}

Future<String> UpdatePassword(String id, TextEditingController password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse(
    'https://bdtravel.comsciproject.net/buddy_travel/api/editpassword.php',
  );
  var response = await http.post(
    url,
    body: {'id': id, 'password': password.text},
  );
  var data = jsonDecode(response.body);
  if (data.toString().contains('TRUE')) {
    prefs.setString('password', password.text);
  }
  return data.toString();
}

bool checkEmail(String email) {
  final bool isValid = EmailValidator.validate(email);
  return isValid;
}
