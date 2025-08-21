import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future add_Review(
  String type,
  String pid,
  String mid,
  String point,
  String text,
  String images,
) async {
  var data;
  try {
    if (images.isEmpty) {
      Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/review.php',
      );
      var response = await http.post(
        url,
        body: {
          'type': type,
          'pid': pid,
          'mid': mid,
          'point': point,
          'text': text,
          'image': '',
        },
      );
      data = jsonDecode(response.body);
    } else {
      Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/review.php',
      );
      var response = await http.post(
        url,
        body: {
          'type': type,
          'pid': pid,
          'mid': mid,
          'point': point,
          'text': text,
          'image': images,
        },
      );
      data = jsonDecode(response.body);
    }
  } catch (e) {}
  return data;
}

Future remove_Review(String type, String rid) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/review.php',
    );
    var response = await http.post(url, body: {'type': type, 'rid': rid});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future edit_Review(
  String type,
  String rid,
  TextEditingController text,
  String point,
  String img,
) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/review.php',
    );
    var response = await http.post(
      url,
      body: {
        'type': type,
        'rid': rid,
        'text': text.text,
        'point': point,
        'image': img,
      },
    );
    data = jsonDecode(response.body);
  } catch (e) {}
  print(data);
  return data.toString();
}

Future get_Review(String pid) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getReviewByID.php',
    );
    var response = await http.post(url, body: {'pid': pid});
    data = jsonDecode(response.body);
    for (int i = 0; i < data[0]['R_ImageReview'].length; i++) {
      if (data[0]['R_ImageReview'][i].toString().startsWith(' ')) {
        data[0]['R_ImageReview'][i] = data[0]['R_ImageReview'][i]
            .toString()
            .replaceFirst(RegExp(r' '), '');
      }
    }
  } catch (e) {}
  return data;
}

Future get_ReviewByRID(String rid) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getReviewByID.php',
    );
    var response = await http.post(url, body: {'rid': rid});
    data = jsonDecode(response.body);
    for (int i = 0; i < data['R_Image'].length; i++) {
      if (data['R_Image'][i].toString().startsWith(' ')) {
        data['R_Image'][i] = data['R_Image'][i]
            .toString()
            .replaceFirst(RegExp(r' '), '');
      }
    }
  } catch (e) {}
  return data;
}

UploadImageReview(String fileImage, String imgName) async {
  var formData = dio.FormData.fromMap({
    'file': await dio.MultipartFile.fromFile(fileImage, filename: imgName),
  });
  var response = await Dio()
      .post(
        'https://bdtravel.comsciproject.net/buddy_travel/api/UploadImageToReview.php',
        data: formData,
      )
      .then((value) => print("Response ==> $value"));
}
