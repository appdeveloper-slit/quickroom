import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quick_room_services/hostel_details.dart';
import 'package:quick_room_services/manage/static_method.dart';
import 'package:quick_room_services/values/colors.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/global_urls.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'filter_page.dart';
import 'location.dart';
import 'sidedrawer.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

enum GenderType { boyshostel, girlshostel, all, flat, girlsroom, boysroom }

enum PriceType { lowtohigh, hightolow }

class _HomeState extends State<Home> {
  late BuildContext ctx;

  dynamic userdata;

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      checkConnectivity();
      checkownertype();
      viewallhostels();
      getLocation();
    });
  }

  String owner_type = "";
  bool loaded = true;
  String setLocation = "";
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List<dynamic> resultList = [];
  List<dynamic> FillterList = [];
    var filterData;
    String? pageType;
  List<String> imageList = [];

  void checkownertype() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    owner_type = sp.getString("user_type") != null
        ? sp.getString("user_type")!
        : "UNKNOWN";
    print('${owner_type}dagv');

    setState(() {
      owner_type = owner_type;
    });
  }

  int pageIndex = 0;
  var city;

  void viewallhostels() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    var deviceState = await OneSignal.shared.getDeviceState();
    var playerId = deviceState!.userId!;

    setState(() {
      loaded = false;
    });
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': sp.getString('user_id').toString(),
      'player_id': playerId.toString(),
      'location_id': sp.getString('location_id').toString(),
      'latitude': sp.getString('lat').toString(),
      'longitude': sp.getString('lng').toString(),
    });
    print(formData.fields);
    var response = await dio.post(viewAllHostelsUrl(), data: formData);
    var res = response.data;
    print(res);
    setState(() {
      loaded = true;
    });
    userdata = res['user'];
    print('${userdata}dgfdgfhd');
    imageList = [];
    for (int i = 0; i < res['sliders'].length; i++) {
      imageList.add(res['sliders'][i]['img_path']);
    }
    print(res['location']);
    print(sp.getString('location_id').toString());
    print(sp.getString('lat').toString());
    print(sp.getString('lng').toString());
    setState(() {
      setLocation = res['location'].toString();
    });

    if (res['error'] == false) {
      imageList = imageList;
      resultList = res['hostel'];
      FillterList = resultList;
      print(sp.getString('location_id').toString());
      print(sp.getString('lat').toString());
      print(sp.getString('lng').toString());
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(res['message'].toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK")),
            ],
          );
        },
      );
    }
  }

  getLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    double lat = double.parse(sp.getString('lat').toString());
    double lng = double.parse(sp.getString('lng').toString());
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    setState(() {
      Placemark placeMark = placemarks[0];
      city = placeMark.subLocality;
      print(city);
    });
  }

  @override
  void initState() {
    checkConnectivity();
    checkownertype();
    viewallhostels();
    getLocation();
    super.initState();
  }

  DateTime? currentBackPressTime;

  void checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(30),
            contentPadding: EdgeInsets.all(30),
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.center,
                  child:
                      Text("Connection Error", style: TextStyle(fontSize: 20))),
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text("No internet connection found.",
                      style: TextStyle(fontSize: 18))),
              SizedBox(
                height: 10,
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Center(child: Text("TRY AGAIN"))),
                          Icon(Icons.refresh)
                        ],
                      ),
                    )),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Do you want to exist application?"),
              actions: [
                TextButton(
                    onPressed: () => SystemNavigator.pop(), child: Text("Yes")),
                TextButton(
                    onPressed: () => Navigator.pop(ctx), child: Text("No")),
              ],
            );
          },
        );
        return false;
      },
      child: Scaffold(
        drawer: navbar(ctx, scaffoldState, owner_type, userdata),
        key: scaffoldState,
        appBar: AppBar(
          backgroundColor: Color(0xff21488c),
          leading: InkWell(
            onTap: () {
              scaffoldState.currentState?.openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.all(Dim().d14),
              child: SvgPicture.asset(
                'assets/menu.svg',
                fit: BoxFit.contain,
                height: Dim().d16,
                width: Dim().d16,
              ),
            ),
          ),
          title: InkWell(
            onTap: () {
              checkConnectivity();
              checkownertype();
              viewallhostels();
              getLocation();
            },
            child: Image.asset('assets/resifinal.png',
                height: Dim().d56,
                width: Dim().d100,
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerLeft),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SelectLocation()));
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset('assets/location.svg', height: Dim().d20),
                    SizedBox(width: Dim().d8),
                    SizedBox(
                      width: Dim().d80,
                      child: Text(
                        '${setLocation.isNotEmpty ? setLocation.toString() + " " : city.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Sty().mediumText.copyWith(
                              color: Colors.white,
                              fontSize: Dim().d12,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: loaded
            ? UpgradeAlert(
                upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.material),
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Dim().d12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Material(
                                shadowColor: Clr().grey.withOpacity(0.4),
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(Dim().d20),
                                child: TextFormField(
                                    onTapOutside: (event){
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                  decoration: Sty()
                                      .TextFormFieldOutlineStyleWithHome
                                      .copyWith(
                                        hintText: 'Search residency name',
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.all(Dim().d16),
                                          child: const Icon(Icons.search,
                                              color: Color(0xFF343E42)),
                                        ),
                                      ),
                                  onChanged: searchresult,
                                ),
                              ),
                            ),
                            SizedBox(width: Dim().d20),
                            InkWell(
                              // onTap: () async {
                              //   filterData = await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Filter()),
                              //   );
                              //   if (filterData != null) {
                              //     String pageType = filterData[0]['pageType'];
                              //     List<dynamic> FillterList = filterData[0]['resultList'];
                              //   // pageType = filterData['pageType'].toString();
                              //   // FillterList = filterData['resultList'];
                              //      // pageType = filterData['pageType'];
                              //      // FillterList = List<dynamic>.from(filterData['resultList']);
                              //   setState(() {
                              //     print('$FillterList' + 'gsffss');
                              //     print('$pageType' + 'djdhpageType');
                              //   });
                              // } },
                              onTap: () async {
                                FillterList = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Filter()),
                                );
                                setState(() {
                                  print('$FillterList' + 'gsffss');
                                });
                              },
                              child: SvgPicture.asset('assets/filterhome.svg',
                                  height: Dim().d52),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    Dim().d4, Dim().d4, Dim().d4, 0),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        pageIndex = index;
                                      });
                                    },
                                  ),
                                  items: imageList
                                      .map((e) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: <Widget>[
                                                CachedNetworkImage(
                                                  imageUrl: mainDomain() + e,
                                                  width: 1200,
                                                  height: 300,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d16,
                              ),
                              CarouselIndicator(
                                height: 8.0,
                                width: 8.0,
                                cornerRadius: 100.0,
                                activeColor: Clr().black,
                                index: pageIndex,
                                count: imageList.length,
                                color: Clr().grey,
                              ),
                              SizedBox(height: 12),
                              (FillterList.length > 0)
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: Dim().d4,
                                              mainAxisSpacing: Dim().d8,
                                              // childAspectRatio: 5 / 8.8,
                                              mainAxisExtent:310,
                                              // mainAxisExtent:318,
                                              // childAspectRatio:MediaQuery.of(context).size.width /
                                              //     (MediaQuery.of(context).size.height / 1.25),

                                          ),
                                      itemCount: FillterList.length,
                                      itemBuilder: (context, index) {
                                        return itemLayout(
                                            context, index, FillterList);
                                      },
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: Dim().d150),
                                      child: Center(
                                          child: Text("No Data Found",
                                              style: TextStyle(
                                                  color: Clr().blue,
                                                  fontSize: 24)))),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget itemLayout(context, index, list) {
    return InkWell(
      onTap: () {
        STM().redirect2page(
            ctx,
            Details(
                hostel_id: list[index]['id'].toString(),
                hostelName: list[index]['name'].toString(),
                hostelAddress: list[index]['address'].toString(),
                ownerName: list[index]['owner_name'].toString(),
                ownerNumber: list[index]['owner_number'].toString(),
                alternateNumber: list[index]['alt_number'].toString(),
                ownerEmail: list[index]['email'].toString(),
                hostelTelephoneNumber: list[index]['tel_number'].toString(),
                hostelType: list[index]['hostel_type'].toString(),
                vacancyCountAvailable: list[index]['vancany'].toString(),
                extraCharges: list[index]['extra_charge'].toString(),
                gateClosingTime: list[index]['close_time'].toString(),
                monthly_charge: list[index]['monthly_charge'].toString(),
                facility: list[index]['facility'].toString(),
                conditions: list[index]['condition'].toString(),
                lat: list[index]['latitude'].toString(),
                long: list[index]['longitude'].toString()));
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Clr().white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                list[index]['image_path'] != null
                    ? CachedNetworkImage(
                        imageUrl: list[index]['image_path'].toString(),
                        height: Dim().d120,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()]),
                      )
                    : Icon(
                        Icons.broken_image,
                        size: 130,
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dim().d8, horizontal: Dim().d8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: RatingBar.builder(
                              initialRating: 1,
                              minRating: 1,
                              direction: Axis.horizontal,
                              ignoreGestures: true,
                              allowHalfRating: true,
                              itemCount: 1,
                              itemSize: 20.00,
                              unratedColor: Clr().grey,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rate) {},
                            ),
                          ),
                          Text(
                              '${list[index]['review_avg_rating']??'0'.toString()}',
                              style: Sty().mediumText.copyWith(
                                  fontSize: 12.00,
                                  fontWeight: FontWeight.w400))
                        ],
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      SizedBox(
                          width: Dim().d72,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '(${list[index]['review_count'].toString()}',
                                    style: Sty().mediumText.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.00)),
                                Text('Reviews)',
                                    style: Sty().mediumText.copyWith(
                                        fontSize: 11.00,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                  child: Text(
                    list[index]['name'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Sty().mediumText.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                SizedBox(
                  height: Dim().d8,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                  child: (list[index]['hostel_type'] != null)
                      ? SizedBox(
                          height: 12,
                          // width: 110,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list[index]["hostel_type"].length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index2) {
                              var v = list[index]["hostel_type"][index2];
                              return Row(
                                children: [
                                  Text(
                                    ' ${v.toString()}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Sty().mediumText.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                   (v != list[index]["hostel_type"].last)? Text(
                                    ' |',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Sty().mediumText.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ):Container(),
                                ],
                              );
                            },
                          ),
                        )
                      : Text(
                          '',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Sty().mediumText.copyWith(
                                fontSize: Dim().d12,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                ),
                SizedBox(height: Dim().d2),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                      child: (list[index]['different_charge'] != null)
                          ? SizedBox(
                              height: 12,
                              width: 100.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list[index]["different_charge"].length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index2) {
                                  var v = list[index]["different_charge"][index2];
                                  return Row(
                                    children: [
                                      Text(
                                        ' ${v['type'].toString()}',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Sty().mediumText.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                       (v != list[index]["different_charge"].last)? Text(
                                        ' |',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Sty().mediumText.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ):Container(),
                                    ],
                                  );
                                },
                              ),
                            )
                          : Text(
                              '',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Sty().mediumText.copyWith(
                                    fontSize: Dim().d12,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: Dim().d4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                        child: Text(
                          '  \u20b9' +
                              list[index]['monthly_charge'].toString() +
                              '/month',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Sty().mediumText.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    Card(
                      color: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:Clr().primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 3.0),
                        child:Text(
                          '${(list[index]['type'] == 'Room') ? 'AR' : (list[index]['type'] == 'Flat') ? 'AF'  : 'AP'}-'
                              '${list[index]['vancany'].toString()}',
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Sty().mediumText.copyWith(
                            fontSize: 10,color: Clr().white,
                            fontWeight: FontWeight.w500,
                          ),),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                SizedBox(
                  height: Dim().d56,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                    child: Text(
                      list[index]['address'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Sty().mediumText.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ),
                // SizedBox(height: Dim().d12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchresult(String value) {
    if (value.isEmpty) {
      setState(() {
        FillterList = resultList;
      });
    } else {
      setState(() {
        FillterList = resultList.where((element) {
          final resultTitle = element['name'].toLowerCase();
          final input = value.toLowerCase();
          return resultTitle
              .toString()
              .toLowerCase()
              .startsWith(input.toString().toLowerCase());
        }).toList();
      });
    }
  }

  void getSearchList(key, type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      key: type,
      'location_id': sp.getString('location_id').toString(),
      'latitude': sp.getString('lat').toString(),
      'longitude': sp.getString('lng').toString(),
    });
    var result = await STM().post(ctx, Str().loading, 'search', body);
    var success = result['error'];
    var message = result['message'];
    if (success) {
      setState(() {
        resultList = result['hostel'];
        FillterList = resultList;
      });
    } else {
      setState(() {
        resultList = result['hostel'];
        FillterList = resultList;
      });
    }
  }

  categoryFilter() {
    return showDialog(
        context: context,
        builder: (index) {
          return AlertDialog(
            title: Text('Choose', style: Sty().mediumBoldText),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Boys hostel"),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Radio<GenderType>(
                    value: GenderType.boyshostel,
                    groupValue: null,
                    onChanged: (GenderType? value) {
                      getSearchList('hostel_type', 'boyshostel');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Girls hostel'),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Radio<GenderType>(
                    value: GenderType.girlshostel,
                    groupValue: null,
                    onChanged: (GenderType? value) {
                      getSearchList('hostel_type', 'girlshostel');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Boys room'),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Radio<GenderType>(
                    value: GenderType.boysroom,
                    groupValue: null,
                    onChanged: (GenderType? value) {
                      getSearchList('hostel_type', 'boysroom');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Girls room'),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Radio<GenderType>(
                    value: GenderType.girlsroom,
                    groupValue: null,
                    onChanged: (GenderType? value) {
                      getSearchList('hostel_type', 'girlsroom');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Flat'),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Radio<GenderType>(
                    value: GenderType.flat,
                    groupValue: null,
                    onChanged: (GenderType? value) {
                      getSearchList('hostel_type', 'flat');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('All'),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Radio<GenderType>(
                    value: GenderType.all,
                    groupValue: null,
                    onChanged: (GenderType? value) {
                      getSearchList('hostel_type', 'all');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  priceFilter() {
    return showDialog(
        context: context,
        builder: (index) {
          return AlertDialog(
            title: Text('Choose', style: Sty().mediumBoldText),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  title: const Text('Low To High'),
                  leading: Radio<PriceType>(
                    value: PriceType.lowtohigh,
                    groupValue: null,
                    onChanged: (PriceType? value) {
                      getSearchList('price', 'lowtohigh');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('High To Low'),
                  leading: Radio<PriceType>(
                    value: PriceType.hightolow,
                    groupValue: null,
                    onChanged: (PriceType? value) {
                      getSearchList('price', 'hightolow');
                      STM().back2Previous(ctx);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  double reciprocal(double d) => 1 / d;
}
