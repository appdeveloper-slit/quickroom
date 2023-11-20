import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:quick_room_services/reviewpage.dart';
import 'package:quick_room_services/values/colors.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/global_urls.dart';
import 'package:quick_room_services/values/strings.dart';

import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'home.dart';
import 'manage/static_method.dart';
import 'product_image.dart';

class Details extends StatefulWidget {
  final String? sType;
  String hostel_id;
  String hostelName;
  String hostelAddress;
  String ownerName;
  String ownerNumber;
  String alternateNumber;
  String ownerEmail;
  String hostelTelephoneNumber;
  String hostelType;
  String vacancyCountAvailable;
  String extraCharges;
  String gateClosingTime;
  String monthly_charge;
  String facility;
  String conditions;

  String lat;
  String long;

  Details(
      {required this.hostel_id,
      required this.hostelName,
      required this.hostelAddress,
      required this.ownerName,
      required this.ownerNumber,
      required this.alternateNumber,
      required this.ownerEmail,
      required this.hostelTelephoneNumber,
      required this.hostelType,
      required this.vacancyCountAvailable,
      required this.extraCharges,
      required this.gateClosingTime,
      required this.monthly_charge,
      required this.facility,
      required this.conditions,
      required this.lat,
      required this.long, this.sType});

  @override
  State<Details> createState() => _DetailsState(
      hostel_id: hostel_id,
      hostelName: hostelName,
      hostelAddress: hostelAddress,
      ownerName: ownerName,
      ownerNumber: ownerNumber,
      alternateNumber: alternateNumber,
      ownerEmail: ownerEmail,
      hostelTelephoneNumber: hostelTelephoneNumber,
      hostelType: hostelType,
      vacancyCountAvailable: vacancyCountAvailable,
      extraCharges: extraCharges,
      gateClosingTime: gateClosingTime,
      monthly_charge: monthly_charge,
      facility: facility,
      conditions: conditions,
      lat: lat,
      long: long);
}

class _DetailsState extends State<Details> {
  late BuildContext ctx;
  String hostel_id;
  String hostelName;
  String hostelAddress;
  String ownerName;
  String ownerNumber;
  String alternateNumber;
  String ownerEmail;
  String hostelTelephoneNumber;
  String hostelType;
  String vacancyCountAvailable;
  String extraCharges;
  String gateClosingTime;
  String monthly_charge;
  String facility;
  String conditions;

  String lat;
  String long;

  _DetailsState(
      {required this.hostel_id,
      required this.hostelName,
      required this.hostelAddress,
      required this.ownerName,
      required this.ownerNumber,
      required this.alternateNumber,
      required this.ownerEmail,
      required this.hostelTelephoneNumber,
      required this.hostelType,
      required this.vacancyCountAvailable,
      required this.extraCharges,
      required this.gateClosingTime,
      required this.monthly_charge,
      required this.facility,
      required this.conditions,
      required this.lat,
      required this.long});

  bool loaded = false;

  double? rating;
  dynamic hostalData;
  int pageIndex = 0;
  List<dynamic> imageList = [];
  List<dynamic> similarList = [];
  String ? formattedCloseTime;
  String ? formattedOpenTime;

  void getHostel() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'hostel_id': hostel_id.toString(),
      'user_id': sp.getString('user_id').toString()
    });
    var result = await STM().post(ctx, Str().loading, 'get_hostel', body);
    setState(() {
      loaded = true;
      hostalData = result['hostel'];
      similarList = result['similar_hostel'];
      // averageRate = result['review_avg'];
      imageList = result['hostel']['imgs'];

    });
  }

  // void getHostel() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   // sp.getString('location_id').toString();
  //
  //   setState(() {
  //     loaded = false;
  //   });
  //   var dio = Dio();
  //   var formData = FormData.fromMap({
  //     'hostel_id': hostel_id.toString(),
  //     'user_id': sp.getString('user_id').toString()
  //   });
  //   var response = await dio.post(getHostelDetails(), data: formData);
  //   var res = response.data;
  //   print(res);
  //
  //   imageList = [];
  //   for (int i = 0; i < res['hostel']['imgs'].length; i++) {
  //     imageList.add(res['hostel']['imgs'][i]['image_path']);
  //   }
  //   setState(() {
  //     loaded = true;
  //     imageList = imageList;
  //   });
  // }

  double averageRate = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    getHostel();
    Future.delayed(Duration.zero, () {
      getReview();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Clr().primaryColor2,
    ));
    ctx = context;

    (hostalData['has_close_time'] == 1 || hostalData['close_time'] == null ) ? null:formattedCloseTime = formatTime("${hostalData['close_time']??''}",);
    (hostalData['has_close_time'] == 1 || hostalData['open_time'] == null ) ? null:formattedOpenTime = formatTime("${hostalData['open_time']??''}",);
    print(formattedCloseTime);
    print(formattedOpenTime);
    return WillPopScope(
      onWillPop: () async {
        print('hghfgsType${widget.sType}');
        // widget.sType == 'myres'? STM().back2Previous(context)) :
         STM().back2Previous(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   leading: InkWell(
          //     onTap: () {
          //       STM().back2Previous(context);
          //     },
          //     child: Icon(
          //       Icons.arrow_back,
          //       color: Clr().black,
          //     ),
          //   ),
          //   title:Text('hdhdhdhd'),
          //   elevation: 0,
          //   backgroundColor: Clr().transparent,
          // ),

        // appBar: AppBar(
        //   backgroundColor: Color(0xff21488c),
        //   leading: InkWell(
        //       onTap: () {
        //         STM().finishAffinity(ctx,Home());
        //       },
        //       child: Icon(Icons.arrow_back_ios_new)),
        //   centerTitle: true,
        //   title: Text(
        //     'Hostel Details',
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        body:SingleChildScrollView(
          // padding: EdgeInsets.all(16),
          child:  loaded
              ?Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height / 2.6,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                    ),
                    items: imageList
                        .map((e) => InkWell(
                      onTap: (){
                        print(imageList);
                        List<String> imagePaths = imageList.map((e) => e['image_path'].toString()).toList();
                        print(pageIndex);
                        print(imagePaths);
                        // STM().redirect2page(context, ImageDisplayPage(imageUrl: '${e['image_path'].toString()}') );
                        STM().redirect2page(context, ZoomableImagePage(imageUrls:imagePaths,initialIndex: pageIndex,) );
                      },

                          child: ClipRRect(
                                // borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: e['image_path'].toString(),
                                      width: double.infinity,
                                      height: 500,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.blue,
                                            )
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                        ))
                        .toList(),
                  ),
                  if (imageList.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      child: CarouselIndicator(
                        height: 10.0,
                        width: 10.0,
                        cornerRadius: 100.0,
                        activeColor: Clr().primaryColor,
                        index: pageIndex,
                        count: imageList.length,
                        color: Colors.blueAccent.shade100,
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d12, vertical: Dim().d12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dim().d20),
                    Text('${hostelName}',
                        style: Sty().mediumBoldText.copyWith(
                            fontWeight: FontWeight.w600, fontSize: Dim().d28)),
                    SizedBox(height: Dim().d12),
                    Row(
                      children: [
                        // SvgPicture.asset('assets/location.svg',
                        //     height: Dim().d16, color: Clr().primaryColor),
                        // SizedBox(width: Dim().d12),
                        Expanded(
                            child: Text('${hostelAddress}',
                                style: Sty().mediumText.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d16))),
                      ],
                    ),
                    SizedBox(height: Dim().d16),
                    InkWell(
                      onTap: () async {
                        launchUrl(
                            Uri.parse(
                                'https://www.google.com/maps/search/?api=1&query=$lat,$long'),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Row(
                        children: [
                          Text('View On Map',
                              style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueAccent,
                                  fontSize: Dim().d16)),
                          SizedBox(width: Dim().d2),
                          // SvgPicture.asset('assets/map.svg', height: Dim().d28),
                          Image.asset('assets/mapic.jpeg', height: Dim().d28),
                        ],
                      ),
                    ),
                    SizedBox(height: Dim().d8),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(height: Dim().d20),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dim().d12,
                  ),
                  child: Column(
                    children: [
                      Text('Rating & reviews',
                          style: Sty().mediumBoldText.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: Dim().d24)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dim().d36),
              InkWell(
                onTap: () {
                  STM().redirect2page(
                      ctx,
                      ReviewPage(
                        hostelId: hostel_id.toString(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(' ${averageRate}',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dim().d44)),
                          SizedBox(
                            width: Dim().d12,
                          ),
                          // Text(
                          //   ' ${averageRate}',
                          //   style: Sty().smallText.copyWith(
                          //       color: Color(0xff21488C),
                          //       fontSize: Dim().d12),
                          // ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RatingBar.builder(
                              initialRating: averageRate,
                              minRating: 1,
                              direction: Axis.horizontal,
                              ignoreGestures: true,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: Dim().d44,
                              unratedColor: Color(0xffccdce8),
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Color(0xffde4e5d),
                              ),
                              onRatingUpdate: (rate) {
                                print(rating);
                                setState(() {
                                  rating = rate;
                                });
                              },
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: RichText(
                          //       text: TextSpan(children: [
                          //         WidgetSpan(
                          //             child: InkWell(
                          //                 onTap: () {
                          //                   STM().redirect2page(
                          //                       ctx,
                          //                       ReviewPage(
                          //                         hostelId: hostel_id.toString(),
                          //                       ));
                          //                 },
                          //                 child: Text(
                          //                   ' ${averageRate}',
                          //                   style: Sty().smallText.copyWith(
                          //                       color: Color(0xff21488C),
                          //                       fontSize: Dim().d12),
                          //                 ))),
                          //         TextSpan(
                          //             text: '+ratings',
                          //             style: Sty().smallText.copyWith(
                          //                 color: Color(0xff21488C),
                          //                 fontSize: Dim().d8)),
                          //       ])),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text.rich(
                          TextSpan(
                            // text: 'Hello ',
                            children: <TextSpan>[
                              TextSpan(
                                  text:  '${hostalData['review_count'] ?? '0'}',
                                  style: Sty().mediumBoldText.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18)),
                              TextSpan(
                                  text: ' reviews |',
                                  style: Sty().mediumBoldText.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18)),
                              TextSpan(
                                  text: ' view rating and review',
                                  style: Sty().mediumText.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.blueAccent,
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dim().d32),
              SizedBox(height: Dim().d8),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dim().d12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hostelType == null)
                        Text(hostelType,
                            style: Sty().mediumBoldText.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 20)),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text.rich(
                        TextSpan(
                          // text: 'Hello ',
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Hurry up there are limited ${(hostalData['type'] == 'Room') ? 'rooms' : (hostalData['type'] == 'Flat') ? 'flats'  : 'places'} -',
                                style: Sty().mediumBoldText.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 16)),
                            TextSpan(
                                text: ' $vacancyCountAvailable',
                                style: Sty().mediumBoldText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dim().d20)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dim().d48),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dim().d12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact details',
                          style: Sty().mediumBoldText.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 22)),
                      SizedBox(height: Dim().d20),
                      (hostalData['owner_name']== null || hostalData['owner_name']!= '')   ?   ListTile(
                        leading: SvgPicture.asset('assets/opratorname.svg',
                            height: 15, width: 15),
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        minLeadingWidth: 10,
                        title: Text(
                          '${hostalData['owner_name'] ?? ''}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ) :Container(),
                      (hostalData['owner_number']== null || hostalData['owner_number']!= '')  ?    ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: SvgPicture.asset('assets/mobile.svg',
                            height: 20, width: 20),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 10,
                        title: Text(
                          '${hostalData['owner_number'] ?? ''.toString()}',
                          // '9876648765',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        trailing: SizedBox(
                          width: 90,
                          height: 24,
                          child: ElevatedButton(
                              onPressed: () async {
                                await launchUrl(Uri.parse(
                                    'tel:${hostalData['owner_number'] ?? ''.toString()}'));
                              },
                              // onPressed: () {
                              //   // STM().redirect2page(ctx, SignUp());
                              // },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Clr().white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color:Clr().blue.withOpacity(0.6)),
                                      borderRadius: BorderRadius.circular(5))),
                              child: Text(
                                'Call',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Clr().blue.withOpacity(0.6),
                                ),
                              )),
                        ),
                      ) :Container(),
                      (hostalData['whatsapp_number']== null || hostalData['whatsapp_number']!= '')  ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: SvgPicture.asset('assets/whatsappnew.svg',
                            height: 20, width: 20),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 10,
                        title: Text(
                          '${hostalData['whatsapp_number'] ?? ''.toString()}',
                          // '8764321987',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        trailing: SizedBox(
                          width: 90,
                          height: 24,
                          child: ElevatedButton(
                              onPressed: () async {
                                await launch(
                                    "whatsapp://send?phone=${hostalData['whatsapp_number'] ?? ''.toString()}");
                                // STM().openWhatsApp(alternateNumber.toString());
                                // await launch(
                                //     "whatsapp://send?phone=${alternateNumber.toString()}");
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Clr().white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color:  Clr().blue.withOpacity(0.6)),
                                      borderRadius: BorderRadius.circular(5))),
                              child: Text(
                                'message',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Clr().blue.withOpacity(0.6),
                                ),
                              )),
                        ),
                      ):Container(),
                      (hostalData['email']== null || hostalData['email']!= '') ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: SvgPicture.asset('assets/mailnew.svg',
                            height: 15, width: 15),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 10,
                        title: Text(
                          // 'abcdef123@gmail.com',
                          '${hostalData['email'] ?? ''.toString()}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        trailing: SizedBox(
                          width: 90,
                          height: 24,
                          child: ElevatedButton(
                              onPressed: () async {
                                await launchUrl(Uri.parse(
                                    'mailto:${hostalData['email'] ?? ''.toString()}'));
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Clr().white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Clr().blue.withOpacity(0.6)),
                                      borderRadius: BorderRadius.circular(5))),
                              child: Text(
                                'mail',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Clr().blue.withOpacity(0.6),
                                ),
                              )),
                        ),
                      ):Container(),
                      if (hostalData['tel_number'] != '' ||
                          hostalData['tel_number'] == null)
                        ListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          leading: SvgPicture.asset('assets/telephone.svg',
                              height: 20, width: 20),
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 10,
                          title: Text(
                            // '54378',
                            '${hostalData['tel_number'] ?? ''.toString()}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if(hostalData['different_charge'] != null  )  (  hostalData['different_charge'].isNotEmpty  )?SizedBox(height: Dim().d40) : Container(),
              // hostalData['different_charge'] != null ||

              if(hostalData['different_charge'] != null  )  (  hostalData['different_charge'].isNotEmpty  ) ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dim().d12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rent Details',
                          style: Sty().mediumBoldText.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 22)),
                      SizedBox(height: Dim().d20),
                      Card(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 32),
                          child: Column(
                            children: [
                              if(hostalData['different_charge'] != null  )    ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: hostalData['different_charge'].length,
                                // itemExtent: 100,
                                itemBuilder: (context, index) {
                                  var v = hostalData['different_charge'][index];

                                  return  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              (hostalData['type'] == 'Room') ?  Image.asset(
                                                  'assets/bulding.png',
                                                  height: 20,
                                                  width: 20) : (hostalData['type'] == 'Flat') ?  Image.asset(
                                                  'assets/bulding.png',
                                                  height: 20,
                                                  width: 20): (hostalData['type'] == 'PG Flat') ?  Image.asset(
                                                  'assets/bulding.png',
                                                  height: 20,
                                                  width: 20)  : SvgPicture.asset(
                                                  'assets/twoPerson.svg',
                                                  height: 15,
                                                  width: 15),
                                              // Image.asset(
                                              //     'assets/bulding.png',
                                              //     height: 20,
                                              //     width: 20),
                                              SizedBox(
                                                width: Dim().d12,
                                              ),
                                              Text(
                                             "${v['type']??''.toString()}",
                                                // '2 person',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: Dim().d12,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/ruppyicon.png',
                                                height: 20,
                                                width: 20,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: Dim().d12,
                                              ),
                                              Text(
                                                '${v['charge'].toString()}₹',
                                                // '7000₹',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          if(hostalData['type'] == 'PG Flat')  SizedBox(
                                            width: Dim().d12,
                                          ),
                                          if(hostalData['type'] == 'PG Flat') Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/twoPerson.svg',
                                                  height: 15,
                                                  width: 15),
                                              SizedBox(
                                                width: Dim().d12,
                                              ),
                                              Text(
                                                "${v['capacity']??''.toString()}",
                                                // '2 person',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        "${v['description']??''.toString()}",
                                        // 'Text of explaination of above charges',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                       ( v != hostalData['different_charge'].last) ? Divider(
                                        color: Colors.grey,
                                        indent: 10,
                                        endIndent: 10,
                                      ):Container(),
                                      if( v != hostalData['different_charge'].last)  SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );

                                },
                              ),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ) : Container(),
              SizedBox(height: Dim().d40),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dim().d12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (hostalData['deposit'] == 'No' || hostalData['deposit'] == null ) ? Container() :  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(hostalData['deposit'] != null)   Text('Deposit',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),

                          if(hostalData['deposit'] != null)    SizedBox(height: Dim().d16),
                          if(hostalData['deposit'] != null)     ListTile(
                            leading: Image.asset(  'assets/ruppyicon.png',
                                height: 20, width: 20),
                            contentPadding: EdgeInsets.zero,
                            visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                            minLeadingWidth: 10,
                            title: Text(
                              " ${hostalData['deposit_desc']??''}",
                              // 'Briff explanation of deposit will hostel owner get from student',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),

                          if(hostalData['deposit'] != null)     SizedBox(height: Dim().d40),
                        ],
                      ),

                      // Text(hostalData['extra_charge'],
                      //     style: Sty().mediumBoldText.copyWith(
                      //         fontWeight: FontWeight.w600, fontSize: 22)),
                      (hostalData['extra_charge'] == 'No' || hostalData['extra_charge'] == null )  ?  Container():  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(hostalData['extra_charge'] != null)     Text('Extra charges',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                          if(hostalData['extra_charge'] != null)    SizedBox(height: Dim().d16),
                          if(hostalData['extra_charge'] != null)      ListTile(
                            leading: Image.asset( 'assets/ruppyicon.png',
                                height: 20, width: 20),
                            contentPadding: EdgeInsets.zero,
                            visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                            minLeadingWidth: 10,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child:  Text(
                                " ${hostalData['extra_desc']??''}",
                                // 'Briff explanation of what type of extra charges will hostel owner get from student',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          if(hostalData['extra_charge'] != null)    SizedBox(height: Dim().d40),
                        ],
                      ),

                      (  hostalData['facility'] != null )?Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Facility',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                          SizedBox(height: Dim().d20),
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: hostalData['facility'].length,
                            // itemExtent: 100,
                            itemBuilder: (context, index) {
                              // var v = hostalData['condition'][index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('assets/cheklistic.svg', height: 20, width: 20),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Text(
                                        " ${hostalData['facility'][index]??''}",
                                        // 'Briff explanation of what type of extra charges will hostel owner get from student',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            },
                          ),
                          SizedBox(height: Dim().d40),
                        ],
                      ):Container(),

                      // Text('has_close_time :${hostalData['has_close_time']}'),

                      (hostalData['has_close_time'] == 1 || hostalData['close_time'] == null )  ?  Container():
                      // if(hostalData['close_time'] != null)
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Gate closing & opennig time',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                          SizedBox(height: Dim().d20),
                          ListTile(
                            leading:
                            Icon(CupertinoIcons.timer, color: Colors.black),
                            contentPadding: EdgeInsets.zero,
                            visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                            minLeadingWidth: 10,
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Closing Time',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.15,
                                    ),
                                    Text(
                                      'Opening Time',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 0.0,top: 10),
                                      child: Text(
                                        " ${formattedCloseTime??''}",
                                        // " ${hostalData['close_time']??''}",
                                        // " ${hostalData['close_time'].format(context).toString()??''}",
                                        // '09:30 pm',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.22,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 0.0,top: 10),
                                        child: Text(
                                          "  ${formattedOpenTime??''}",
                                          // '09:30 pm',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dim().d12),
                          Divider(),
                          SizedBox(height: Dim().d28),
                        ],
                      ),

                   if(hostalData['why_this_residence'] != null)   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Why student will select this residency',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                          SizedBox(height: Dim().d20),
                          ListTile(
                            // leading: Icon('assets/proIcon.svg',height: 20,width: 20),
                            leading:Image.asset('assets/moreic.png', height: 20, width: 20),
                            contentPadding: EdgeInsets.zero,
                            visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                            minLeadingWidth: 10,
                            title:  Text(
                             " ${hostalData['why_this_residence']??''}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: Dim().d40),
                        ],
                      ),


                      if(hostalData['about_residence'] != null)     Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('More about your residency',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                      SizedBox(height: Dim().d20),
                          ListTile(
                            leading: Image.asset('assets/rulesic.png',
                                height: 20, width: 20),
                            contentPadding: EdgeInsets.zero,
                            visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                            minLeadingWidth: 10,
                            title: Text(
                              " ${hostalData['about_residence']??''}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: Dim().d40),
                        ],
                      ),

                      if(hostalData['leaving_policy'] != null)     Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Apartment leaving policy',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                      SizedBox(height: Dim().d20),
                          ListTile(
                            leading: Image.asset('assets/rulesic.png',
                                height: 20, width: 20),
                            contentPadding: EdgeInsets.zero,
                            visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                            minLeadingWidth: 10,
                            title: Text(
                              " ${hostalData['leaving_policy']??''}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: Dim().d40),
                        ],
                      ),


                      (  hostalData['condition'] != null )?Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rule & restrictions',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                          SizedBox(height: Dim().d20),
                           ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: hostalData['condition'].length,
                            // itemExtent: 100,
                            itemBuilder: (context, index) {
                              // var v = hostalData['condition'][index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/rulesic.png', height: 20, width: 20),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Text(
                                        " ${hostalData['condition'][index]??''}",
                                        // 'Briff explanation of what type of extra charges will hostel owner get from student',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              //   ListTile(
                              //   leading: Image.asset('assets/rulesic.png', height: 20, width: 20),
                              //   contentPadding: EdgeInsets.zero,
                              //   visualDensity:
                              //   VisualDensity(horizontal: 0, vertical: -4),
                              //   minLeadingWidth: 10,
                              //   title:  Row(
                              //     children: [
                              //       Image.asset('assets/rulesic.png', height: 20, width: 20),
                              //       SizedBox(width: 10),
                              //       Text(
                              //         " ${hostalData['condition'][index]??''}",
                              //         // 'Briff explanation of what type of extra charges will hostel owner get from student',
                              //         style: TextStyle(
                              //             color: Colors.black,
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.w400),
                              //       ),
                              //     ],
                              //   ),
                              // );



                            },
                          ),
                          SizedBox(height: Dim().d40),
                        ],
                      ):Container(),



                      // SizedBox(height: Dim().d40),
                      if(similarList.isNotEmpty) Text('Similar residencies in selected area',
                          style: Sty().mediumBoldText.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 22)),
                      if(similarList.isNotEmpty) SizedBox(
                        height: Dim().d28,
                      ),
                      if(similarList.isNotEmpty)  SizedBox(
                        height: 350,
                        child: ListView.builder(
                          itemCount: similarList.length,
                          // padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return itemLayout(context, index, similarList);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dim().d40),
            ],
          ): Center(
            child:Container(),
          ),
        )
      ),
    );
  }

  Widget itemLayout(context, index, list) {
    return Row(
      children: [
        InkWell(
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
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                color: Clr().white,
                // decoration: BoxDecoration(
                //     color: Clr().white,
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.red,
                //       blurRadius: 2.0, // soften the shadow
                //       spreadRadius:5.0, //extend the shadow
                //       // offset: Offset(
                //       //   5.0, // Move to right 10  horizontally
                //       //   5.0, // Move to bottom 10 Vertically
                //       // ),
                //     )
                //   ],
                // ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    list[index]['images'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: list[index]['images'][0]['image_path']
                                  .toString(),
                              height: Dim().d140,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()]),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png')),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d12,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Dim().d56,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      itemSize: 15.00,
                                      unratedColor: Clr().grey,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rate) {
                                        // print(rating);
                                        // setState(() {
                                        //   rating = rate;
                                        // });
                                      },
                                    ),
                                  ),
                                  Text(
                                      '${list[index]['review_avg_rating'].toString()}',
                                      style: Sty().mediumText.copyWith(
                                          fontSize: 10.00,
                                          fontWeight: FontWeight.w400))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Dim().d12,
                          ),
                          SizedBox(
                              width: Dim().d72,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                    // SizedBox(
                    //   height: Dim().d8,
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d8),
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
                    // Expanded(
                    //   flex: 1,
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                    //     // padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                    //     child: Text(
                    //       list[index]["hostel_type"].toString(),
                    //       textAlign: TextAlign.start,
                    //       overflow: TextOverflow.ellipsis,
                    //       maxLines: 1,
                    //       style: Sty().mediumText.copyWith(
                    //             fontSize: Dim().d12,
                    //             fontWeight: FontWeight.w400,
                    //           ),
                    //     ),
                    //   ),
                    // ),
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
                            // width: 190,
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
                        Padding(
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                      child: Text(
                        list[index]['address'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Sty().mediumText.copyWith(
                              fontSize: Dim().d12,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),

                    SizedBox(height: Dim().d12),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

// get Review
  void getReview() async {
    FormData body = FormData.fromMap({
      'hostel_id': hostel_id.toString(),
    });
    var result = await STM().post(ctx, Str().loading, 'show_review', body);
    setState(() {
      averageRate = double.parse(result['review_avg'].toString());
    });
  }
  String formatTime(String timeString) {
    final DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }
}
