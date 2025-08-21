import 'package:finalproject/API/apiFavorite.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:finalproject/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFavorite extends StatefulWidget {
  const AddFavorite({super.key});

  @override
  State<AddFavorite> createState() => _AddFavoriteState();
}

class _AddFavoriteState extends State<AddFavorite> {
  String id = '';
  TextEditingController name = new TextEditingController();

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
        id = prefs.getString('id').toString();
      });
    } catch (e) {
      print(e);
    }
    print(id);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สำเร็จ'),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text('เพิ่มรายการโปรดสำเร็จ')]),
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
                      setState(() {
                        name.text = '';
                      });
                      Navigator.pop(context);
                    },
                    child: Text('ยืนยัน',style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

   Future<void> _showMyDialogEdit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ไม่สามารถทำรายการได้ กรุณาลองใหม่อีกครั้ง'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(
                        HexColor('46BBC7'),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('ตกลง',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
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

    Padding myTextField(
      String header,
      String str,
      IconData icon,
      TextEditingController text,
    ) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
        child: SizedBox(
          width: w * 0.95,
          height: h * 0.1,
          child: TextField(
            controller: text,
            decoration: InputDecoration(
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(icon, color: HexColor('46BBC7')),
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
              labelText: header,
              hintText: str,
              labelStyle: TextStyle(color: HexColor('46BBC7')),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มรายการโปรด"),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: h * 0.03),
              myTextField('ชื่อรายการ', '', Icons.bookmark, name),
              SizedBox(height: h * 0.025),
              Container(
                width: w * 0.6,
                height: h * 0.075,
                child: ButtonTheme(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        HexColor('46BBC7'),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (name.text.isNotEmpty) {
                        String value = await add_ListFavorite(
                          "Header",
                          id,
                          name,
                        );
                        if (value == "TRUE") {
                          _showMyDialog();
                        }
                      } else {
                        _showMyDialogEdit();
                      }
                    },
                    child: const Text(
                      "เพิ่มรายการโปรด",
                      style: TextStyle(color: Colors.white),
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
