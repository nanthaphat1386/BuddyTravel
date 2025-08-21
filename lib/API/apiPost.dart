import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<dynamic> get_ListCheckin(String id) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getCheckinFriend.php',
    );
    var response = await http.post(url, body: {'id': id});
    data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      for (int m = 0; m < data[i]['image'].length; m++) {
        if (data[i]['image'][m].toString().startsWith(' ')) {
          data[i]['image'][m] = data[i]['image'][m].toString().replaceFirst(
            RegExp(r' '),
            '',
          );
        }
      }
    }
  } catch (e) {}
  return data;
}

Future get_CheckinByID(String cid) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getCheckinByID.php',
    );
    var response = await http.post(url, body: {'cid': cid});
    data = jsonDecode(response.body);
    for (int i = 0; i < data['C_Image'].length; i++) {
      if (data['C_Image'][i].toString().startsWith(' ')) {
        data['C_Image'][i] = data['C_Image'][i].toString().replaceFirst(
          RegExp(r' '),
          '',
        );
      }
    }
  } catch (e) {}
  return data;
}

Future add_Checkin(
  String type,
  String mid,
  String pid,
  TextEditingController text,
  String image,
) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.php',
    );
    if (image == '') {
      var response = await http.post(
        url,
        body: {'type': type, 'mid': mid, 'pid': pid, 'text': text.text},
      );
      data = jsonDecode(response.body);
    } else {
      var response = await http.post(
        url,
        body: {
          'type': type,
          'mid': mid,
          'pid': pid,
          'text': text.text,
          'image': image,
        },
      );
      data = jsonDecode(response.body);
    }
  } catch (e) {}
  print(data);
  return data;
}

Future delete_Checkin(String type, String cid) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.php',
    );
    var response = await http.post(url, body: {'type': type, 'cid': cid});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future edit_Checkin(
  String type,
  String cid,
  TextEditingController text,
  String img,
) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.php',
    );
    var response = await http.post(
      url,
      body: {
        'type': type,
        'cid': cid,
        'text': text.text,
        'image': img,
      },
    );
    data = jsonDecode(response.body);
  } catch (e) {}
  return data.toString();
}

UploadImageCheckin(String fileImage, String imgName) async {
  var formData = dio.FormData.fromMap({
    'file': await dio.MultipartFile.fromFile(fileImage, filename: imgName),
  });
  var response = await Dio()
      .post(
        'https://bdtravel.comsciproject.net/buddy_travel/api/UploadImageToCheckin.php',
        data: formData,
      )
      .then((value) => print("Response ==> $value"));
}
