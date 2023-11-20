import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/manage/static_method.dart';
import 'package:quick_room_services/reviewpage.dart';
import 'package:quick_room_services/sign_in.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/global_urls.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'add_flat.dart';
import 'add_hostel.dart';
import 'add_pg_flat.dart';
import 'add_pg_room.dart';
import 'add_room.dart';
import 'hostel_details.dart';
import 'values/colors.dart';

class MyResidency extends StatefulWidget {
  const MyResidency({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyResidencyWidget();
  }
}

class MyResidencyWidget extends State with SingleTickerProviderStateMixin {
  late BuildContext ctx;
  List<String> tabList = ['Hostel', 'Leads'];
  int selectedTab = 0;
  List<String> imageList = ['assets/home.png'];
  var resultList = [];
  var leadResultList = [];
  bool loaded = true;
  int initialIndex = 0;
  var status;
  double? rating;
  double averageRate = 0.0;
  bool? click;

  final GlobalKey _floatingActionButtonKey = GlobalKey();

  void getHostelsAndLeads() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.getString('location_id').toString();
    setState(() {
      loaded = false;
    });
    var dio = Dio();
    var formData = FormData.fromMap({
      'user_id': sp.getString('user_id').toString(),
    });
    var response = await dio.post(getUserHostel(), data: formData);
    var hostelres = response.data;
    print("GET HOSTELS");
    print(hostelres);
    var formData2 = FormData.fromMap({
      'user_id': sp.getString('user_id').toString(),
    });
    var leadresponse = await dio.post(getUserLead(), data: formData2);
    var leadres = leadresponse.data;
    print("GET LEADS");
    print(leadres);

    setState(() {
      loaded = true;
      resultList = hostelres['hostel'];
      leadResultList = leadres['leads'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getHostelsAndLeads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: selectedTab == 0
            ? FloatingActionButton(
                onPressed: () {
                  // STM().redirect2page(ctx, Add(false, "0"));
                },
                // child: SvgPicture.asset('assets/addhostel.svg',height: 50,width: 50),
                backgroundColor: const Color(0xff21488c),
                child: PopupMenuButton(
                  // offset: Offset(-80.0, kToolbarHeight+500),
                  // offset: Offset(-70, -410),
                  offset: Offset(-70, -MediaQuery.of(context).size.height / 2),

                  elevation: 1,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onSelected: (value) {
                    // Handle the selected option here
                    if (value == 1) {
                      print('Option 1 selected');
                    } else if (value == 2) {
                      STM().redirect2page(ctx, flat(false, false, "0", 'Flat'));
                      print('Option 2 selected');
                    } else if (value == 3) {
                      STM().redirect2page(
                          ctx, Pgflat(false, false, "0", ' PG Flat'));
                      print('Option 3 selected');
                    } else if (value == 4) {
                      STM()
                          .redirect2page(ctx, Add(false, false, "0", 'Hostel'));
                      print('Option 4 selected');
                    } else if (value == 5) {
                      STM().redirect2page(
                          ctx, PgRoom(false, false, "0", 'PG Room'));
                      print('Option 5 selected');
                    } else if (value == 6) {
                      STM().redirect2page(
                          ctx,
                          Room(
                            false,
                            false,
                            "0",
                            'Room',
                          ));
                      print('Option 6 selected');
                    }
                  },
                  child: Icon(Icons.add, size: 50),

                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select your residency type-',
                                  style: Sty().mediumText.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      )),
                              SizedBox(
                                height: 3,
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.8,
                              ),
                            ],
                          ),
                        )),
                    PopupMenuItem(
                        value: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/bulding.png',
                                  height: 20, width: 20),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Flat',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add your flat residency here ',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    PopupMenuItem(
                        value: 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/bulding.png',
                                  height: 20, width: 20),
                              // Icon(Icons.image, color: Colors.white, size: 20),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Flat(PG)',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add your cot-base flat(PG) \nresidency here ',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    PopupMenuItem(
                        value: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/bulding.png',
                                  height: 20, width: 20),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hostel',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add your hostel residency here',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    PopupMenuItem(
                        value: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/bulding.png',
                                  height: 20, width: 20),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room(PG)',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add your cot-base room(PG)\nresidency here',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    PopupMenuItem(
                        value: 6,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/bulding.png',
                                  height: 20, width: 20),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Room',
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add your non cot-base room\nresidency here',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: Sty()
                                          .mediumText
                                          .copyWith(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ))
            : null,
        appBar: AppBar(
          backgroundColor: const Color(0xff21488c),
          leading: InkWell(
              onTap: () {
                STM().back2Previous(ctx);
              },
              child: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            initialIndex == 0 ? 'My Residency' : 'My Leads',
            style: Sty().largeText.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
          ),
        ),
        body: Column(
          children: [
            loaded
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Clr().grey))),
                      child: TabBar(
                          unselectedLabelColor:
                              Color(0xff21488C).withOpacity(0.5),
                          labelColor: Color(0xff21488C),
                          unselectedLabelStyle: TextStyle(color: Clr().grey),
                          onTap: (value) {
                            setState(() {
                              initialIndex = value;
                            });
                          },
                          physics: BouncingScrollPhysics(),
                          tabs: const [
                            Tab(text: 'Residencies'),
                            Tab(text: 'Leads'),
                          ]),
                    ),
                  )
                : Container(),
            SizedBox(height: Dim().d28),
            loaded
                ? Expanded(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d2),
                    child: TabBarView(children: [
                      resultList.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              // itemCount: resultList.length,
                              itemCount: resultList.length,
                              itemBuilder: (context, index) {
                                return itemHostelLayout(ctx, index, resultList);
                              },
                            )
                          : Center(
                              child: Text(
                                "No Data Found",
                                style:
                                    TextStyle(color: Clr().blue, fontSize: 24),
                              ),
                            ),
                      leadResultList.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              // itemCount: resultList.length,
                              itemCount: leadResultList.length,
                              itemBuilder: (context, index) {
                                return itemLeadLayout(
                                    ctx, index, leadResultList);
                              },
                            )
                          : Center(
                              child: Text(
                                "No Data Found",
                                style:
                                    TextStyle(color: Clr().blue, fontSize: 24),
                              ),
                            )
                    ]),
                  ))
                : Expanded(
                    child: Column(
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  )),
            // SizedBox(height: 12,),
            // InkWell(
            //   onTap: () async {
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return AlertDialog(
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(Dim().d12)),
            //             insetPadding:
            //                 EdgeInsets.symmetric(horizontal: Dim().d16),
            //             title: Image.asset('assets/exit.jpg',
            //                 height: Dim().d220, width: Dim().d350),
            //             actions: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 children: [
            //                   Expanded(
            //                     child: InkWell(
            //                       onTap: () {
            //                         STM().back2Previous(ctx);
            //                       },
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                             borderRadius:
            //                                 BorderRadius.circular(Dim().d12),
            //                             border: Border.all(
            //                                 color: Clr().primaryColor)),
            //                         child: Padding(
            //                           padding: EdgeInsets.symmetric(
            //                               vertical: Dim().d12),
            //                           child: Center(
            //                             child: Text('Cancel',
            //                                 style: Sty().mediumText.copyWith(
            //                                     color: Clr().primaryColor)),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(width: Dim().d12),
            //                   Expanded(
            //                     child: InkWell(
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                             borderRadius:
            //                                 BorderRadius.circular(Dim().d12),
            //                             border: Border.all(
            //                                 color: Clr().primaryColor)),
            //                         child: Padding(
            //                           padding: EdgeInsets.symmetric(
            //                               vertical: Dim().d12),
            //                           child: Center(
            //                             child: Text('ok',
            //                                 style: Sty().mediumText.copyWith(
            //                                     color: Clr().primaryColor)),
            //                           ),
            //                         ),
            //                       ),
            //                       onTap: () async {
            //                         SharedPreferences sp =
            //                             await SharedPreferences.getInstance();
            //                         sp.clear();
            //                         STM().finishAffinity(context, SignIn());
            //                       },
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: Dim().d20,
            //               ),
            //             ],
            //           );
            //         });
            //   },
            //   child: Center(
            //     child: Container(
            //       child: Column(
            //         children: [
            //           Text('Log Out',
            //               style: Sty().mediumBoldText.copyWith(
            //                     color: Clr().primaryColor,
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: Dim().d20,
            //                   ))
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            //
          ],
        ),
      ),
    );
  }

  //Item
  Widget itemLayout(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(Dim().d12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: selectedTab == index ? Clr().primaryColor : Colors.white,
                width: 2),
          ),
        ),
        child: Text(
          tabList[index],
          style: Sty().mediumText.copyWith(
                color: selectedTab == index ? Clr().primaryColor : Colors.grey,
              ),
        ),
      ),
    );
  }

  //Hostel Item
  Widget itemHostelLayout(ctx, index, list) {
    averageRate = double.parse(list[index]['review_avg_rating'].toString());

    return Card(
      elevation: 3,
      // margin: EdgeInsets.all(Dim().d2),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: Dim().d16, horizontal: Dim().d4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                list[index]['image_path'] != null
                    ? Container(
                        child: CachedNetworkImage(
                        imageUrl: list[index]['image_path'],
                        placeholder: (context, url) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        ),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width / 2.1,
                        height: MediaQuery.of(context).size.height / 6,
                      ))
                    : Icon(
                        Icons.broken_image,
                        size: 100,
                      ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list[index]['name'],
                        maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: Sty().mediumText.copyWith(
                              fontSize: Dim().d14,
                            ),
                      ),
                      SizedBox(height: Dim().d4),
                      // Text(
                      //   list[index]['hostel_type'],
                      //   style: Sty().mediumText.copyWith(
                      //         fontSize: Dim().d12,
                      //       ),
                      // ),
                      SizedBox(height: Dim().d4),

                      // list[index]['status'] != 0
                      //     ? Text(
                      //         "Active",
                      //         style: TextStyle(
                      //           color: Colors.green,
                      //           fontSize: 14,
                      //         ),
                      //       )
                      //     : Text(
                      //         "Inactive",
                      //         style: TextStyle(
                      //           color: Colors.red,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      // Text(
                      //   "PerDayCount: ${list[index]['perDayCount'] ?? 0}",
                      //   style: Sty().mediumText.copyWith(
                      //       fontSize: Dim().d12, fontWeight: FontWeight.w500),
                      // ),

                      // Text(
                      //   // '1RK | 1BHK | 2BHK | 3BHK',
                      //   list[index]["hostel_type"].toString() ,
                      //   textAlign: TextAlign.start,
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 1,
                      //   style: Sty().mediumText.copyWith(
                      //     fontSize: 10,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      if (list[index]["hostel_type"] != null)
                        SizedBox(
                          height: 12,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list[index]["hostel_type"].length,
                            scrollDirection: Axis.horizontal,
                            // itemExtent: 100,
                            itemBuilder: (context, index2) {
                              var v = list[index]["hostel_type"][index2];
                              return Row(
                                children: [
                                  Text(
                                    // '1RK | 1BHK | 2BHK | 3BHK',
                                    '${v.toString()}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Sty().mediumText.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  (v != list[index]["hostel_type"].last)
                                      ? Text(
                                          // '1RK | 1BHK | 2BHK | 3BHK',
                                          ' | ',
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Sty().mediumText.copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        )
                                      : Container(),
                                ],
                              );
                            },
                          ),
                        ),
                      SizedBox(height: 8),
                      if (list[index]["different_charge"] != null)
                        SizedBox(
                          height: 12,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list[index]["different_charge"].length,
                            scrollDirection: Axis.horizontal,
                            // itemExtent: 100,
                            itemBuilder: (context, index2) {
                              var v = list[index]["different_charge"][index2];
                              return Row(
                                children: [
                                  Text(
                                    // '1RK | 1BHK | 2BHK | 3BHK',
                                    '${v['type'].toString()}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Sty().mediumText.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  if (v != list[index]["different_charge"].last)
                                    Text(
                                      // '1RK | 1BHK | 2BHK | 3BHK',
                                      ' | ',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Sty().mediumText.copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),

                      SizedBox(height: Dim().d8),
                      Text(
                        // list[index]["monthly_charge"].toString() ,
                        // '7500/month',
                        '\u20b9' +
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
                      SizedBox(
                        height: Dim().d12,
                      ),
                      // SizedBox(
                      //   width: Dim().d100,
                      //   child: Text(
                      //     list[index]['address'],
                      //     maxLines: 3,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: Sty().mediumText.copyWith(
                      //       fontWeight: FontWeight.w300,
                      //       fontSize: Dim().d12,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: Dim().d4),
                      Text(
                        // 'front of IIB classes, krishna colony, sai nagar, nanded, maharashtra Nanded-431602',
                        list[index]['address'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Sty().mediumText.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      STM().redirect2page(
                          ctx,
                          ReviewPage(
                            hostelId: '${list[index]['id'] ?? '0'.toString()}',
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
                              Text(
                                  // ' 4.3',
                                  ' ${averageRate}',
                                  style: Sty().mediumBoldText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dim().d24)),
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
                                  itemSize: Dim().d24,
                                  unratedColor: Color(0xffccdce8),
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
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
                            ],
                          ),
                          SizedBox(
                            height: Dim().d6,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text.rich(
                              TextSpan(
                                // text: 'Hello ',
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${list[index]['review_count'] ?? '0'.toString()}',
                                      style: Sty().mediumBoldText.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dim().d14)),
                                  TextSpan(
                                      text: ' reviews |',
                                      style: Sty().mediumBoldText.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13)),
                                  TextSpan(
                                      text: ' view rating and review',
                                      style: Sty().mediumText.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.blueAccent,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              text: 'Visitors to your account in this month.',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 12)),
                          TextSpan(
                              text:
                                  ' ${list[index]['count'] ?? '0'.toString()}',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dim().d16)),
                        ],
                      ),
                    ),
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
                              text: 'Total vacant'
                                  '  ${(list[index]['type'] == 'Room') ? 'rooms' : (list[index]['type'] == 'Flat') ? 'flat'  : 'places'} -',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 12)),
                          TextSpan(
                              text:
                                  ' ${list[index]['vancany'] ?? '0'.toString()}',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dim().d16)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (list[index]['message'] != '')
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(list[index]['message'],
                          // 'Data uploaded succesfully! your account has been sent to the resieasy team, it will be approved within 24 hours',
                          // ' ${averageRate}',
                          textAlign: TextAlign.start,
                          style: Sty().mediumBoldText.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                              fontSize: 9)),
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          _showSuccessDialog(ctx, list[index]['id'].toString());
                        },
                        child: Column(
                          children: [
                            // SvgPicture.asset('assets/delete.svg'),
                            Image.asset('assets/deleteic.png',
                                height: 25, width: 25, color: Colors.indigo),
                            SizedBox(
                              height: 8,
                            ),
                            Text(' Delete',
                                // ' ${averageRate}',
                                style: Sty().mediumBoldText.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 9)),
                          ],
                        ),
                      ),
                      SizedBox(width: Dim().d8),
                      if (list[index]['status'] != 0)
                        InkWell(
                          onTap: () {
                            // if (value == 1) {
                            //   print('Option 1 selected');
                            // } else if (value == 2) {
                            //   STM().redirect2page(ctx, flat(false, "0", 'Flat'));
                            //   print('Option 2 selected');
                            // } else if (value == 3) {
                            //   STM().redirect2page(ctx, Pgflat(false, "0",' PG Flat'));
                            //   print('Option 3 selected');
                            // }else if (value == 4) {
                            //   STM().redirect2page(ctx, Add(false, "0",'Hostel'));
                            //   print('Option 4 selected');
                            // }else if (value == 5) {
                            //   STM().redirect2page(ctx, PgRoom(false, "0",'PG Room'));
                            //   print('Option 5 selected');
                            // }else if (value == 6) {
                            //   STM().redirect2page(ctx, Room(false, "0",'Room',));
                            //   print('Option 6 selected');
                            // }

                            if (list[index]['type'].toString() == 'Flat') {
                              print('Option 1 Flat');
                              STM().redirect2page(
                                  context,
                                  flat(true, false,
                                      list[index]['id'].toString(), 'Flat'));
                            } else if (list[index]['type'].toString() ==
                                'PG Flat') {
                              STM().redirect2page(
                                  context,
                                  Pgflat(true, false,
                                      list[index]['id'].toString(), 'PG Flat'));
                              print('Option 2 PG Flat');
                            } else if (list[index]['type'].toString() ==
                                'Hostel') {
                              STM().redirect2page(
                                  context,
                                  Add(true, false, list[index]['id'].toString(),
                                      'Hostel'));
                              print('Option 3 Hostel');
                            } else if (list[index]['type'].toString() ==
                                'PG Room') {
                              STM().redirect2page(
                                  context,
                                  PgRoom(true, false,
                                      list[index]['id'].toString(), 'PG Room'));
                              print('Option 4 PG Room');
                            } else if (list[index]['type'].toString() ==
                                'Room') {
                              STM().redirect2page(
                                  context,
                                  Room(true, false,
                                      list[index]['id'].toString(), 'Room'));
                              print('Option 5 Room');
                            } else if (list[index]['type'].toString() ==
                                'null') {
                              STM().redirect2page(
                                  context,
                                  Add(true, false, list[index]['id'].toString(),
                                      'Hostel'));
                              print('Option 6 selected  error');
                            }
                            // STM().redirect2page(context, flat(true, list[index]['id'].toString(),'Flat'));
                            // print('${list[index]['id'].toString()}fshgdfg dfu');
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/editic.png',
                                  height: 25, width: 25, color: Colors.indigo),
                              // Icon(Icons.edit_outlined),
                              SizedBox(
                                height: 8,
                              ),
                              Text(' Edit',
                                  // ' ${averageRate}',
                                  style: Sty().mediumBoldText.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 9)),
                            ],
                          ),
                        ),
                      SizedBox(width: Dim().d8),
                      if (list[index]['status'] != 0)
                        TextButton(
                            // onPressed: () {
                            //   if (list[index]['type'].toString() == 'Flat') {
                            //     print('Option 1 Flat');
                            //     STM().redirect2page(context, flat(true,true, list[index]['id'].toString(),'Flat'));
                            //   } else if (list[index]['type'].toString() == 'PG Flat') {
                            //     STM().redirect2page(context, Pgflat(true,true , list[index]['id'].toString(),'PG Flat'));
                            //     print('Option 2 PG Flat');
                            //   } else if (list[index]['type'].toString() == 'Hostel') {
                            //     STM().redirect2page(context, Add(true,true , list[index]['id'].toString(),'Hostel'));
                            //     print('Option 3 Hostel');
                            //   }else if (list[index]['type'].toString() == 'PG Room') {
                            //     STM().redirect2page(context, PgRoom(true,true , list[index]['id'].toString(),'PG Room'));
                            //     print('Option 4 PG Room');
                            //   }else if (list[index]['type'].toString() == 'Room') {
                            //     STM().redirect2page(context, Room(true,true ,list[index]['id'].toString(),'Room'));
                            //     print('Option 5 Room');
                            //   }else if (list[index]['type'].toString() == 'null') {
                            //     STM().redirect2page(context, Add(true,true , list[index]['id'].toString(),'Hostel'));
                            //     print('Option 6 selected  error');
                            //   }
                            //
                            //   // changeHostelStatus(list[index]['id']);
                            // },
                            onPressed: () {
                              STM().redirect2page(
                                  ctx,
                                  Details(
                                      sType: 'myres',
                                      hostel_id: list[index]['id'].toString(),
                                      hostelName:
                                          list[index]['name'].toString(),
                                      hostelAddress:
                                          list[index]['address'].toString(),
                                      ownerName:
                                          list[index]['owner_name'].toString(),
                                      ownerNumber: list[index]['owner_number']
                                          .toString(),
                                      alternateNumber:
                                          list[index]['alt_number'].toString(),
                                      ownerEmail:
                                          list[index]['email'].toString(),
                                      hostelTelephoneNumber:
                                          list[index]['tel_number'].toString(),
                                      hostelType:
                                          list[index]['hostel_type'].toString(),
                                      vacancyCountAvailable:
                                          list[index]['vancany'].toString(),
                                      extraCharges: list[index]['extra_charge']
                                          .toString(),
                                      gateClosingTime:
                                          list[index]['close_time'].toString(),
                                      monthly_charge: list[index]
                                              ['monthly_charge']
                                          .toString(),
                                      facility:
                                          list[index]['facility'].toString(),
                                      conditions:
                                          list[index]['condition'].toString(),
                                      lat: list[index]['latitude'].toString(),
                                      long:
                                          list[index]['longitude'].toString()));
                            },
                            child: Column(
                              children: [
                                Image.asset('assets/viewic.png',
                                    height: 25,
                                    width: 25,
                                    color: Colors.indigo),
                                // Icon(Icons.view_timeline),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('View',
                                    // ' ${averageRate}',
                                    style: Sty().mediumBoldText.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 9)),
                              ],
                            )),
                      // SizedBox(width: Dim().d8),

                      TextButton(
                          onPressed: (list[index]['status'] != 0)
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          " Change Status",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: Text(
                                            'Are you sure you want to Change Status?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                changeHostelStatus(
                                                    list[index]['id']);
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK")),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("CANCEL")),
                                        ],
                                      );
                                    },
                                  );
                                  // changeHostelStatus(list[index]['id']);
                                }
                              : null,
                          child: Column(
                            children: [
                              Text(
                                list[index]['hostel_status'] == 1
                                    ? 'Active'
                                    : 'Inactive',
                                style: Sty().mediumText.copyWith(
                                    fontSize: Dim().d14,
                                    fontWeight: FontWeight.w600,
                                    color: list[index]['hostel_status'] == 1
                                        ? Colors.greenAccent.shade700
                                        : Clr().errorRed),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(' Status',
                                  // ' ${averageRate}',
                                  style: Sty().mediumBoldText.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 9)),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Lead Item
  Widget itemLeadLayout(ctx, index, list) {
    return Card(
        elevation: 3,
        margin: EdgeInsets.all(Dim().d8),
        child: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list[index]['name'],
                    style: Sty().mediumText.copyWith(
                          fontSize: Dim().d20,
                        ),
                  ),
                  SizedBox(height: Dim().d8),
                  Text(
                    'For : ' + list[index]['hostel_name'],
                    style: Sty().mediumText.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  SizedBox(height: Dim().d8),
                  Text(
                    'Mobile: ' + list[index]['phone'],
                    style: Sty().mediumText.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ],
              )),
              Container(
                height: Dim().d100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(list[index]['created_at'].toString()),
                    InkWell(
                        onTap: () async {
                          STM()
                              .openDialer('${list[index]['phone'].toString()}');
                          // var url = "tel:" + list[index]['phone'].toString();
                          // if (await canLaunchUrlString(url)) {
                          //   await launchUrlString(url);
                          // } else {
                          //   throw 'Could not launch $url';
                          // }
                        },
                        child: SvgPicture.asset('assets/call.svg')),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _showSuccessDialog(ctx, String id) async {
    AwesomeDialog(
      context: ctx,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Are you sure you want to delete ?',
      // desc: 'Dialog description here.............',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        var dio = Dio();
        var formData = FormData.fromMap({
          'id': id,
        });
        var response = await dio.post(deleteHostelUrl(), data: formData);
        var res = response.data;
        print(res);

        getHostelsAndLeads();
      },
    )..show();
  }

  void changeHostelStatus(id) async {
    FormData body = FormData.fromMap({
      'hostel_id': id,
    });
    var result = await STM().post(ctx, Str().processing, 'update_status', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      getHostelsAndLeads();
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
