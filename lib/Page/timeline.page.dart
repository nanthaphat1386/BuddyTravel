import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/API/apiPost.dart';
import 'package:finalproject/Page/detailPlace.page.dart';
import 'package:finalproject/Page/listFavorite.page.dart';
import 'package:finalproject/Page/profile.page.dart';
import 'package:finalproject/Tools/responsive.tools.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class timeline extends StatefulWidget {
  const timeline({super.key});

  @override
  State<timeline> createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  String ID = '';
  List checkin = [];

  SampleItem? selectedMenu;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        ID = prefs.getString('id').toString();
      });
    } catch (e) {
      print(e);
    }
    getCheckin(ID);
  }

  Future<List> getCheckin(String id) async {
    try {
      checkin = await get_ListCheckin(id);
    } catch (e) {
      print(e);
    }
    return checkin;
  }

  Future<void> _showMyDialogDeleteCheckin(String cid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('ต้องการลบการเช็คอินออกใช่หรือไม่')],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        HexColor('46BBC7'),
                      ),
                    ),
                    onPressed: () async {
                      String value = await delete_Checkin("remove", cid);
                      if (value == "TRUE") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ลบข้อมูลสำเร็จ')),
                        );
                        setState(() {
                          getCheckin(ID);
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ลบข้อมูลไม่สำเร็จ')),
                        );
                      }
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future _onShareonSocial(List image, String text) async {
    // ignore: deprecated_member_use
    //Share.share('Visit FlutterCampus at https://www.fluttercampus.com');
    // ignore: deprecated_member_use
    try {
      List imagesPath = [];
      for (int i = 0; i < image.length; i++) {
        // final urlImage = image.first;
        final url = Uri.parse(image[i]);
        final response = await http.get(url);
        final bytes = response.bodyBytes;

        final temp = await getTemporaryDirectory();
        final path = "${temp.path}/image$i.jpg";
        File(path).writeAsBytesSync(bytes);
        imagesPath.add(path);
      }

      if (image.isNotEmpty) {
        final params = ShareParams(
          text: text,
          files: [
            for (int i = 0; i < imagesPath.length; i++) XFile(imagesPath[i]),
          ],
        );
        SharePlus.instance.share(params);
      } else {
        final params = ShareParams(text: text);
        SharePlus.instance.share(params);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h =
        displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Container boxImage(List img) {
      return Container(
        margin: EdgeInsets.all(10),
        width: w,
        height: h * 0.23,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: HexColor('46BBC7')),
        ),
        child: Image.network(img.first, fit: BoxFit.contain),
      );
    }

    Container boxTwoImage(List img) {
      return Container(
        margin: EdgeInsets.all(10),
        width: w,
        height: h * 0.23,
        child: Row(
          children: <Widget>[
            Container(
              width: w * 0.45,
              height: h * 0.23,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: HexColor('46BBC7')),
              ),
              child: Image.network(img.first, fit: BoxFit.contain),
            ),

            Container(
              width: w * 0.45,
              height: h * 0.23,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: HexColor('46BBC7')),
              ),
              child: Image.network(img.last, fit: BoxFit.contain),
            ),
          ],
        ),
      );
    }

    Container boxImageFull(List img) {
      return Container(
        margin: EdgeInsets.all(10),
        width: w,
        height: h * 0.23,
        child: Row(
          children: <Widget>[
            Container(
              width: w * 0.575,
              height: h * 0.23,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: HexColor('46BBC7')),
              ),
              child: Image.network(img.first, fit: BoxFit.contain),
            ),

            Column(
              children: [
                Container(
                  width: w * 0.325,
                  height: h * 0.115,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: HexColor('46BBC7')),
                  ),
                  child: Image.network(img[1], fit: BoxFit.contain),
                ),

                Container(
                  width: w * 0.325,
                  height: h * 0.115,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: HexColor('46BBC7')),
                  ),
                  child: Image.network(img[2], fit: BoxFit.contain),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Container boxImageOver(List img) {
      return Container(
        margin: EdgeInsets.all(10),
        width: w,
        height: h * 0.23,
        child: Row(
          children: <Widget>[
            Container(
              width: w * 0.575,
              height: h * 0.23,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: HexColor('46BBC7')),
              ),
              child: Image.network(img.first, fit: BoxFit.contain),
            ),

            Column(
              children: [
                Container(
                  width: w * 0.325,
                  height: h * 0.115,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: HexColor('46BBC7')),
                  ),
                  child: Image.network(img[1], fit: BoxFit.contain),
                ),
                Container(
                  width: w * 0.325,
                  height: h * 0.115,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      opacity: 0.65,
                      fit: BoxFit.contain,
                      image: NetworkImage(img[2]),
                    ),
                    border: Border.all(width: 1, color: HexColor('46BBC7')),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        _showMyDialogImage(context, img);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: w * 0.11,
                        height: h * 0.065,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(149, 255, 255, 255),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Text(
                          (img.length - 2).toString(),
                          style: TextStyle(
                            fontSize: w * 0.045,
                            color: Color.fromARGB(175, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#46BBC7'),
        title: Text("ไทมไลน์"),
        actions: [
          IconButton(
            onPressed: () async {
              String value = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => List_Favorite(id: ID)),
              );
              if (value == "TRUE") {
              } else {}
            },
            icon: Icon(Icons.bookmark),
            tooltip: 'รายการที่ชอบ',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: HexColor('CEF4F8')),
        height: h,
        width: w,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getCheckin(
                  ID,
                ), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (ConnectionState.active != null && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: checkin.length,
                      itemBuilder: (BuildContext buildContext, int index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Container(
                            width: w * 0.9,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    ((context) => Profile(
                                                      id: checkin[index]["M_ID"],
                                                      info:
                                                          ID ==
                                                                  checkin[index]["M_ID"]
                                                              ? "me"
                                                              : "friend",
                                                    )),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              checkin[index]['P_image'],
                                              scale: 1.0,
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      Wrap(
                                        direction: Axis.vertical,
                                        spacing: 2,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.bottomLeft,
                                                width: w * 0.625,
                                                height: h * 0.05,
                                                padding: EdgeInsets.only(
                                                  left: 5,
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            ((
                                                              context,
                                                            ) => Profile(
                                                              id:
                                                                  checkin[index]["M_ID"],
                                                              info:
                                                                  ID ==
                                                                          checkin[index]["M_ID"]
                                                                      ? "me"
                                                                      : "friend",
                                                            )),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    checkin[index]['name']
                                                                .toString()
                                                                .length >
                                                            30
                                                        ? checkin[index]['name']
                                                                .substring(
                                                                  0,
                                                                  29,
                                                                ) +
                                                            '...'
                                                        : checkin[index]['name'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: h * 0.0235,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ID == checkin[index]["M_ID"]
                                                  ? Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width: w * 0.085,
                                                    height: h * 0.045,
                                                    child: PopupMenuButton<
                                                      SampleItem
                                                    >(
                                                      initialValue:
                                                          selectedMenu,
                                                      // Callback that sets the selected popup menu item.
                                                      onSelected: (
                                                        SampleItem item,
                                                      ) async {
                                                        setState(() {
                                                          selectedMenu = item;
                                                        });
                                                        if (selectedMenu ==
                                                            SampleItem
                                                                .itemTwo) {
                                                          _showMyDialogDeleteCheckin(
                                                            checkin[index]['C_ID'],
                                                          );
                                                        } else if (selectedMenu ==
                                                            SampleItem
                                                                .itemOne) {
                                                          String
                                                          value = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => EditCheckin(
                                                                    cid:
                                                                        checkin[index]['C_ID'],
                                                                  ),
                                                            ),
                                                          );
                                                          if (value == "TRUE") {
                                                            setState(() {
                                                              getCheckin(ID);
                                                            });
                                                          }
                                                        } else if (selectedMenu ==
                                                            SampleItem
                                                                .itemThree) {
                                                          //แชร์ลงเฟสบุ๊ค
                                                          _onShareonSocial(
                                                            checkin[index]['image'],
                                                            checkin[index]['text'],
                                                          );
                                                        }
                                                      },
                                                      itemBuilder:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) => <
                                                            PopupMenuEntry<
                                                              SampleItem
                                                            >
                                                          >[
                                                            const PopupMenuItem<
                                                              SampleItem
                                                            >(
                                                              value:
                                                                  SampleItem
                                                                      .itemOne,
                                                              child: Text(
                                                                'แก้ไข',
                                                              ),
                                                            ),
                                                            const PopupMenuItem<
                                                              SampleItem
                                                            >(
                                                              value:
                                                                  SampleItem
                                                                      .itemTwo,
                                                              child: Text('ลบ'),
                                                            ),
                                                            const PopupMenuItem<
                                                              SampleItem
                                                            >(
                                                              value:
                                                                  SampleItem
                                                                      .itemThree,
                                                              child: Text(
                                                                'แชร์ลง Facebook',
                                                              ),
                                                            ),
                                                          ],
                                                    ),
                                                  )
                                                  : Container(),
                                            ],
                                          ),
                                          Container(
                                            width: w * 0.65,
                                            height: h * 0.035,
                                            alignment: Alignment.topCenter,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: w * 0.045,
                                                  color: HexColor('46BBC7'),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => DetailPlace(
                                                              id:
                                                                  checkin[index]['P_ID'],
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child:
                                                      checkin[index]['P_name']
                                                                  .toString()
                                                                  .length >
                                                              27
                                                          ? Tooltip(
                                                            message:
                                                                checkin[index]['P_name'],
                                                            child: Text(
                                                              '${checkin[index]['P_name'].toString().substring(0, 25)} ...',
                                                            ),
                                                          )
                                                          : Text(
                                                            '${checkin[index]['P_name']}',
                                                          ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  width: w,
                                  child: Text('${checkin[index]['text']}'),
                                ),
                                checkin[index]['image'].length == 1
                                    ? boxImage(checkin[index]['image'])
                                    : checkin[index]['image'].length == 2
                                    ? boxTwoImage(checkin[index]['image'])
                                    : checkin[index]['image'].length == 3
                                    ? boxImageFull(checkin[index]['image'])
                                    : checkin[index]['image'].length > 3
                                    ? boxImageOver(checkin[index]['image'])
                                    : Container(),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 5, left: 10),
                                  width: w,
                                  child: Text(
                                    'วันที่ ' +
                                        checkin[index]['date'].toString(),
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showMyDialogImage(BuildContext context, List image) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Container(
            width: 300,
            height: 300,
            child: Scrollbar(
              child: PageView.builder(
                itemCount: image.length,
                pageSnapping: true,
                padEnds: false,
                itemBuilder: (context, i) {
                  return Container(
                    child: Image.network(image[i], fit: BoxFit.fitHeight),
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}

class EditCheckin extends StatefulWidget {
  final String cid;
  const EditCheckin({Key? key, required this.cid}) : super(key: key);

  @override
  State<EditCheckin> createState() => _EditCheckinState();
}

class _EditCheckinState extends State<EditCheckin> {
  String str = '';
  List data = [];
  TextEditingController text = new TextEditingController();

  List<XFile> imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();

  @override
  initState() {
    super.initState();
    getDataCheckin(widget.cid);
  }

  Future<List<dynamic>> getDataCheckin(String cid) async {
    List img = [];
    try {
      var ans = await get_CheckinByID(cid);
      data.add(ans);
      setState(() {
        img = ans['C_Image'];
      });
      for (int i = 0; i < img.length; i++) {
        final url = Uri.parse(img[i]);
        final response = await http.get(url);
        final bytes = response.bodyBytes;

        final temp = await getTemporaryDirectory();
        final path = "${temp.path}/image$i.jpg";
        File(path).writeAsBytesSync(bytes);
        imageFileList.add(XFile(path));
      }
      setState(() {
        text.text = ans['C_Text'];
        imageFileList;
      });
    } catch (e) {
      print("error");
    }
    return data;
  }

  void selectImages() async {
    if (imageFileList.length > 4) {
      _dialogBuilderFullImage(context);
    } else {
      try {
        final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
        if (selectedImages!.isNotEmpty) {
          for (int i = 0; i < selectedImages.length; i++) {
            imageFileList.add(selectedImages[i]);
          }
        }
        setState(() {});
      } catch (e) {}
    }
  }

  Future<void> _dialogBuilderFullImage(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: const Text(
            'รูปภาพครบ 5 รูปแล้ว โปรดลบออกแล้วทำรายการใหม่อีกครั้ง',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
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

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h =
        displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลการเช็คอิน'),
        backgroundColor: HexColor('#46BBC7'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, "FALSE");
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        width: w * 1,
        height: h * 1.1,
        // decoration: BoxDecoration(color: Colors.black12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.025),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: text,
                  maxLines: 4,
                  // controller: text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: HexColor('46BBC7'),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: HexColor('46BBC7'),
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 10, right: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Container(
              //         width: w * 0.945,
              //         height: h * 0.13,
              //         decoration: BoxDecoration(
              //           border: Border.all(width: 1, color: HexColor('46BBC7')),
              //         ),
              //         child: Padding(
              //           padding: EdgeInsets.all(10),
              //           child: GridView.builder(
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //                   crossAxisSpacing: 0,
              //                   mainAxisSpacing: 0,
              //                   crossAxisCount: 5,
              //                 ),
              //             itemCount: imageFileList.length,
              //             itemBuilder: (context, index) {
              //               return InkWell(
              //                 splashColor:
              //                     Colors.white10, // Splash color over image
              //                 child: Stack(
              //                   children: [
              //                     Ink.image(
              //                       fit: BoxFit.cover, // Fixes border issues
              //                       width: 100,
              //                       height: 80,
              //                       image: NetworkImage(imageFileList[index]),
              //                     ),
              //                     Align(
              //                       alignment: Alignment.bottomRight,
              //                       child: InkWell(
              //                         onTap: () {
              //                           imageFileList.removeAt(index);
              //                           setState(() {});
              //                         },
              //                         child: Icon(
              //                           Icons.close,
              //                           color: Colors.red,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: h * 0.015),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        selectImages();
                      },
                      child: Text('เพิ่มรูปภาพ'),
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(
                          HexColor('46BBC7'),
                        ),
                      ),
                    ),
                    Container(
                      width: w * 0.65,
                      height: h * 0.275,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: HexColor('46BBC7')),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                crossAxisCount: 3,
                              ),
                          itemCount: imageFileList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor:
                                  Colors.white10, // Splash color over image
                              child: Stack(
                                children: [
                                  Ink.image(
                                    fit: BoxFit.cover, // Fixes border issues
                                    width: 100,
                                    height: 80,
                                    image: FileImage(
                                      File(imageFileList[index].path),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () {
                                        imageFileList.removeAt(index);
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.05),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  width: w * 1,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      String images = imageFileList
                          .map<String>((xfile) => xfile.name)
                          .toList()
                          .toString()
                          .replaceAll("[", "")
                          .replaceAll("]", "")
                          .replaceAll(" ", "");
                      String value = await edit_Checkin(
                        "edit",
                        widget.cid,
                        text,
                        images.isEmpty ? "" : images,
                      );
                      if (value == "TRUE") {
                        for (int i = 0; i < imageFileList.length; i++) {
                          UploadImageCheckin(
                            imageFileList[i].path,
                            imageFileList[i].name,
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('แก้ไขสำเร็จ')),
                        );
                        Navigator.pop(context, "TRUE");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('แก้ไขไม่สำเร็จ')),
                        );
                      }
                    },
                    child: Text("แก้ไขเช็คอินสถานที่"),
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(
                        HexColor('46BBC7'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";
}
