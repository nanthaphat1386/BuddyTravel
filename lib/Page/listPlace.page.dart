import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:finalproject/API/apiPlace.dart';
import 'package:finalproject/Page/addPlace.page.dart';
import 'package:finalproject/Page/detailPlace.page.dart';
import 'package:finalproject/Tools/responsive.tools.dart';

// ignore: camel_case_types
class listPlace extends StatefulWidget {
  const listPlace({super.key});

  @override
  State<listPlace> createState() => _listPlaceState();
}

// ignore: camel_case_types
class _listPlaceState extends State<listPlace> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _userLocation;
  LatLng initialCameraPosition = const LatLng(
    36.865421209974606,
    -124.99604970216751,
  );
  bool isChecked = false;
  TextEditingController placeSearch = TextEditingController();

  List place = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _userLocation = await location.getLocation();
    double? latitude = _userLocation.latitude;
    double? longitude = _userLocation.longitude;

    try {
      setState(() {
        initialCameraPosition = LatLng(latitude!, longitude!);
      });
      allPlace(latitude!.toString(), longitude!.toString());
      allPlace10km(latitude.toString(), longitude.toString());
    } catch (e) {}
  }

  Future<List> allPlace(String lati, String long) async {
    try {
      place = await getPlace(lati, long);
    } catch (e) {
      print(e);
    }
    return place;
  }

  Future<List> allPlace10km(String lati, String long) async {
    try {
      place = await getPlace10Km(lati, long, "send");
    } catch (e) {
      print(e);
    }
    return place;
  }

  Future<List> allPlaceByName(String lati, String long, String name) async {
    try {
      place = await getPlaceByName(lati, long, name);
    } catch (e) {
      print(e);
    }
    return place;
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h =
        displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text('สถานที่ท่องเที่ยว'),
        backgroundColor: HexColor('#46BBC7'),
        actions: [
          IconButton(
            onPressed: () async {
              String refresh = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPlace()),
              );
              if (refresh == 'true') {
                if (isChecked == true) {
                  setState(() {
                    allPlace(
                      initialCameraPosition.latitude.toString(),
                      initialCameraPosition.longitude.toString(),
                    );
                  });
                } else {
                  setState(() {
                    allPlace10km(
                      initialCameraPosition.latitude.toString(),
                      initialCameraPosition.longitude.toString(),
                    );
                  });
                }
              }
            },
            icon: Icon(Icons.add_home_work_sharp),
          ),
        ],
      ),
      backgroundColor: HexColor('CEF4F8'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: w * 0.65,
                  height: h * 0.2,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: placeSearch,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            allPlaceByName(
                              initialCameraPosition.latitude.toString(),
                              initialCameraPosition.longitude.toString(),
                              placeSearch.text,
                            );
                          });
                        },
                        child: Icon(Icons.search, color: HexColor('#46BBC7')),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: HexColor('#46BBC7'),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: HexColor('#46BBC7'),
                        ),
                      ),
                      hintText: 'ชื่อ ประเภท เทศกาล',
                    ),
                  ),
                ),
                Checkbox(
                  checkColor: Colors.black,
                  fillColor: MaterialStateProperty.all(Colors.white),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text("ทั้งหมด"),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future:
                  isChecked == false && placeSearch.text.isEmpty
                      ? allPlace10km(
                        initialCameraPosition.latitude.toString(),
                        initialCameraPosition.longitude.toString(),
                      )
                      : isChecked == true && placeSearch.text.isEmpty
                      ? allPlace(
                        initialCameraPosition.latitude.toString(),
                        initialCameraPosition.longitude.toString(),
                      )
                      : allPlaceByName(
                        initialCameraPosition.latitude.toString(),
                        initialCameraPosition.longitude.toString(),
                        placeSearch.text,
                      ), // a previously-obtained Future<String> or null // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (ConnectionState.active != null && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: place.length,
                    itemBuilder: (BuildContext buildContext, int index) {
                      return place[0]['P_ID'] != ""
                          ? Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  Container(
                                    height: h * 0.75,
                                    width: w,
                                    child: Scrollbar(
                                      child: PageView.builder(
                                        itemCount:
                                            place[index]['P_Image'].length,
                                        pageSnapping: true,
                                        padEnds: false,
                                        itemBuilder: (context, pagePosition) {
                                          return Container(
                                            child: Image.network(
                                              place[index]['P_Image'][pagePosition],
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child:
                                                    place[index]['P_Name']
                                                                .toString()
                                                                .length >=
                                                            20
                                                        ? Tooltip(
                                                          message:
                                                              place[index]['P_Name'],
                                                          child: Text(
                                                            "${place[index]['P_Name'].toString().substring(0, 17)}...",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        )
                                                        : Text(
                                                          "${place[index]['P_Name']}",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                              ),
                                              SizedBox(width: w * 0.015),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                //padding: EdgeInsets.all(2),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.5),
                                                  child: Text(
                                                    '${place[index]['Distance']} กม.',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                place[index]['P_CountReview'] +
                                                    ' ',
                                              ),
                                              Icon(
                                                Icons.reviews,
                                                color: HexColor('#46BBC7'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      2,
                                      10,
                                      2,
                                    ),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            'ประเภท ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          for (
                                            int i = 0;
                                            i < place[index]['P_Type'].length;
                                            i++
                                          )
                                            Wrap(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    right: 5,
                                                  ),
                                                  child: box(
                                                    place[index]['P_Type'][i],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          //
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      2,
                                      10,
                                      2,
                                    ),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            'เทศกาล ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          for (
                                            int i = 0;
                                            i <
                                                place[index]['P_Festival']
                                                    .length;
                                            i++
                                          )
                                            Wrap(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    right: 5,
                                                  ),
                                                  child: box(
                                                    place[index]['P_Festival'][i],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          //
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                size: 20,
                                                color: HexColor('46BBC7'),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(left: 2),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                place[index]["P_Address"],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        alignment: Alignment(1, -1),
                                        child: ButtonTheme(
                                          minWidth: 0.35 * w,
                                          height: 0.075 * h,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              String ans = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => DetailPlace(
                                                        id: place[index]['P_ID'],
                                                      ),
                                                ),
                                              );
                                              if (ans == 'TRUE') {
                                                try {
                                                  setState(() {
                                                    isChecked = false;
                                                    allPlace10km(
                                                      initialCameraPosition
                                                          .latitude
                                                          .toString(),
                                                      initialCameraPosition
                                                          .longitude
                                                          .toString(),
                                                    );
                                                  });
                                                } catch (e) {}
                                              } else {}
                                            },
                                            child: const Text('เยี่ยมชม'),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: HexColor(
                                                '#FFFFFF',
                                              ),
                                              backgroundColor: HexColor(
                                                '46BBC7',
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 30,
                                                vertical: 10,
                                              ),
                                              textStyle: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          : Container();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container box(String str) {
    double w = displayWidth(context);
    double h =
        displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //width: 0.15 * w,
      height: 0.075 * h,
      alignment: Alignment.center,
      decoration: myBoxDecoration(HexColor('#46BBC7')),
      child: Text(
        str,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.5, color: Colors.white),
      ),
    );
  }

  BoxDecoration myBoxDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(
        Radius.circular(5.0), //     <--- border radius here
      ),
    );
  }
}
