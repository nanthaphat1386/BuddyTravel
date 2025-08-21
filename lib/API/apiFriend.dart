import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future get_Friend(String id) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/Friend.php',
    );
    var response = await http.post(url, body: {'id': id});
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future search_friend(String id, TextEditingController str) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/searchfriend.php',
    );
    var response = await http.post(url, body: {'id': id, 'fr_id': str.text});
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future remove_Friend(String id, String fr_id) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/remove_friend.php',
    );
    var response = await http.post(url, body: {'id': id, 'fr_id': fr_id});
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future cancel_Friend(String id, String fr_id) async {
  var data;
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/cancel_friend.php',
    );
    var response = await http.post(url, body: {'id': id, 'fr_id': fr_id});
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }

  return data;
}

Future accept_Friend(String id, String fr_id) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/accept_friend.php',
    );
    var response = await http.post(url, body: {'id': id, 'fr_id': fr_id});
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future change_Friend(
  String id,
  String fr_id,
  TextEditingController name,
) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/change_name.php',
    );
    var response = await http.post(
      url,
      body: {'id': id, 'fr_id': fr_id, 'name': name.text},
    );
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future get_Request(String id) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/request_friend.php',
    );
    var response = await http.post(url, body: {'mid': id});
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future accept_Request(String id) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/request_friend.php',
    );
    var response = await http.post(url, body: {'mid': id});
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future addFriend(String id, String fr_id) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addfriend.php',
    );
    var response = await http.post(url, body: {'id': id, 'fr_id': fr_id});
    var data = jsonDecode(response.body);
    return data;
  } catch (e) {}
}

Future autoAddFriend(String id, String fr_id, String name) async {
  try {
    Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addfriendfacebook.php',
    );
    var response = await http.post(
      url,
      body: {'id': id, 'fr_id': fr_id, 'name': name},
    );
    var data = jsonDecode(response.body);
  } catch (e) {}
}
