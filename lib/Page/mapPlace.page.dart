import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:finalproject/Page/detailPlace.page.dart';
import 'package:finalproject/Page/profile.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:finalproject/API/apiPlace.dart';
import 'package:finalproject/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mapPlace extends StatefulWidget {
  const mapPlace({super.key});

  @override
  State<mapPlace> createState() => _mapPlaceState();
}

class _mapPlaceState extends State<mapPlace> {
  late GoogleMapController _controller;
  late Marker marker;
  List<Marker> markers = <Marker>[];
  late BitmapDescriptor customIconMe = BitmapDescriptor.defaultMarker;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _userLocation;
  LatLng initialCameraPosition = const LatLng(
    36.865421209974606,
    -124.99604970216751,
  );

  String id_place = '';
  List friend = [];
  String place_name = '';
  List place_image = [];

  String name = '';
  String img = '';
  String ID = '';

  Future<void> _getUserLocation() async {
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
        _controller.moveCamera(
          CameraUpdate.newLatLng(LatLng(latitude, longitude)),
        );
        setMarkers(latitude, longitude);
        //getMeMarkers("me", "Me", latitude, longitude);
        _onMapCreate(_controller);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
    getProfile();
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        img = prefs.getString('image').toString();
        ID = prefs.getString('id').toString();
        name =
            prefs.getString('fName').toString() +
            ' ' +
            prefs.getString('lName').toString();
      });
    } catch (e) {
      print(e);
    }
    _getCheckinFriend();
  }

  Future _getCheckinFriend() async {
    var fr;
    try {
      fr = await getCheckinMap(ID);

      getMarkers(fr);
    } catch (e) {
      print(e);
    }
    print(fr);
    return fr;
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
        _controller.moveCamera(
          CameraUpdate.newLatLng(LatLng(latitude, longitude)),
        );
        _onMapCreate(_controller);
      });
    } catch (e) {}
  }

  void _onMapCreate(GoogleMapController controller) {
    _controller = controller;
    try {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: initialCameraPosition, zoom: 12),
        ),
      );
    } catch (e) {}
  }

  Future<void> _showMyDialogFriend(BuildContext context, List friend) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //backgroundColor: HexColor('46BBC7'),
          title: Text('เพื่อนที่เคยเช็คอิน'),
          content: Container(
            width: 400,
            height: 300,
            child: ListView.builder(
              itemCount: friend.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Profile(
                              id: friend[index]["id"],
                              info: "friend",
                            ),
                      ),
                    );
                  },
                  child: Card(
                    shape: Border.all(width: 1, color: HexColor('46BBC7')),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(friend[index]["image"]),
                      ),
                      title: Text(
                        friend[index]['name'],
                        style: TextStyle(color: HexColor('46BBC7')),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // createMarker() async {
  //   BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(3, 3)),
  //     'img/accountMe.png',
  //   ).then((icon) {
  //     setState(() {
  //       customIconMe = icon;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h =
        displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getUserLocation,
        backgroundColor: Colors.white,
        label: const Text('ค้นหาฉัน'),
        icon: Icon(Icons.near_me, color: HexColor('46BBC7')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Stack(
        children: [
          GoogleMap(
            onTap: (LatLng latLng) {},
            mapType: MapType.normal,
            markers: Set<Marker>.of(markers),
            initialCameraPosition: CameraPosition(
              target: initialCameraPosition,
              zoom: 14,
            ),
            onMapCreated: _onMapCreate,
          ),
          id_place.isNotEmpty
              ? Positioned(
                bottom: 0,
                child: Container(
                  width: w,
                  height: h * 0.355,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          width: w,
                          height: h * 0.215,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Scrollbar(
                            child: PageView.builder(
                              itemCount: place_image.length,
                              pageSnapping: true,
                              padEnds: false,
                              itemBuilder: (context, pagePosition) {
                                return Container(
                                  child: Image.network(
                                    place_image[pagePosition],
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: w,
                          height: h * 0.145,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                width: w,
                                height: h * 0.05,
                                child: Text(
                                  place_name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: w,
                                height: h * 0.075,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: w * 0.5,
                                      child: Row(
                                        children: [
                                          for (
                                            int i = 0;
                                            friend.length < 3
                                                ? i < friend.length
                                                : i < 3;
                                            i++
                                          )
                                            friend.length != 3 && i != 2
                                                ? Container(
                                                  width: w * 0.1,
                                                  height: h * 0.1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => Profile(
                                                                id:
                                                                    friend[i]["id"],
                                                                info: "friend",
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                            friend[i]['image'],
                                                          ),
                                                    ),
                                                  ),
                                                )
                                                : Container(
                                                  width: w * 0.1,
                                                  height: h * 0.1,
                                                  color: Colors.white12,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _showMyDialogFriend(
                                                        context,
                                                        friend,
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                      child: Text(
                                                        '+${friend.length - 2}',
                                                      ),
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
                                        minWidth: 0.4 * w,
                                        height: 0.125 * h,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => DetailPlace(
                                                      id: id_place,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Text('เยี่ยมชม'),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: HexColor(
                                              '#FFFFFF',
                                            ),
                                            backgroundColor: HexColor('46BBC7'),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 30,
                                              vertical: 10,
                                            ),
                                            textStyle: TextStyle(fontSize: 15),
                                          ),
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
                      Positioned(
                        right: 2.5,
                        child: Container(
                          width: w * 0.1,
                          height: h * 0.05,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                id_place = '';
                              });
                            },
                            icon: Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Container(),
          // (markers.isNotEmpty)
          //     ? Positioned(
          //         child: Align(
          //         alignment: FractionalOffset.bottomCenter,
          //         child: Container(
          //           height: h * 0.4,
          //           width: w,
          //           color: Colors.white,
          //           alignment: Alignment.bottomCenter,
          //           margin:
          //               EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.35),
          //         ),
          //       ))
          //     : Container(),
        ],
      ),
    );
  }

  setMarkers(double lat, double lng) {
    markers.add(
      Marker(
        markerId: const MarkerId("Search"),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: 'New Search'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }

  getMeMarkers(
    String id,
    String name,
    String images,
    List member,
    List imageList,
    double lat,
    double lng,
  ) async {
    markers.add(
      Marker(
        onTap: () {
          setState(() {
            id_place = id;
            place_name = name;
            friend = member;
            place_image = imageList;
          });
        },
        markerId: MarkerId(id),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: name),
        rotation: 180,
        icon: await ResizePicture(imageSize: 225, url: images),
      ),
    );
    try {
      setState(() {});
    } catch (e) {}
  }

  getMarkers(List friendList) async {
    for (int i = 0; i < friendList.length; i++) {
      markers.add(
        Marker(
          onTap: () {
            setState(() {
              id_place = friendList[i]['P_ID'];
              place_name = friendList[i]['P_Name'];
              friend = friendList[i]['Member'];
              place_image = friendList[i]['P_Image'];
            });
          },
          markerId: MarkerId(friendList[i]['P_ID']),
          position: LatLng(
            double.parse(friendList[i]["lat"]),
            double.parse(friendList[i]["lng"]),
          ),
          infoWindow: InfoWindow(title: friendList[i]['P_Name']),
          rotation: 180,
          icon: await ResizePicture(
            imageSize: 225,
            url: friendList[i]['P_Image'][0],
          ),
        ),
      );
    }
    try {
      setState(() {});
    } catch (e) {}
  }

  Future<BitmapDescriptor> ResizePicture({
    required String url,
    required int imageSize,
  }) async {
    final File imageFile = await DefaultCacheManager().getSingleFile(url);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, imageSize.toDouble(), imageSize.toDouble()),
      image: imageFI.image,
      flipHorizontally: true,
    );
    final _image = await pictureRecorder.endRecording().toImage(
      imageSize,
      (imageSize * 1.1).toInt(),
    );
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
