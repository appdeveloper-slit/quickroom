import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'manage/static_method.dart';
import 'multiselect.dart';

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  late BuildContext ctx;

  List<dynamic> filterList = [
    {
      'name': 'Flat',
      'type': [
        {
          'typename': 'Family Flat',
          'Subtype': ['1RK', '1BHK', '2BHK', '3BHK']
        },
        {
          'typename': 'Boys Flat',
          'Subtype': ['1RK', '1BHK', '2BHK', '3BHK']
        },
        {
          'typename': 'Girls Flat',
          'Subtype': ['1RK', '1BHK', '2BHK', '3BHK']
        },
      ],
    },
    {
      'name': 'PG Flat',
      'type': [
        {
          'typename': 'Boys PG Flat',
          'Subtype':  ['1RK', '1BHK', '2BHK', '3BHK']
        },
        {
          'typename': 'Girls PG Flat',
          'Subtype':  ['1RK', '1BHK', '2BHK', '3BHK']
        },
      ],
    },
    {
      'name': 'Hostel',
      'type': [
        {
          'typename': 'Boys Hostel',
          'Subtype': []
        },
        {
          'typename': 'Girls Hostel',
          'Subtype': []
        },
      ],
    },
    {
      'name': 'PG Room',
      'type': [
        {
          'typename': 'Boys PG Room',
          'Subtype': []
        },
        {
          'typename': 'Girls PG Room',
          'Subtype': []
        },
      ],
    },
    {
      'name': 'Room',
      'type': [
        {
          'typename': 'Family Room',
          'Subtype': []
        },
        {
          'typename': 'Boys Room',
          'Subtype': []
        },
        {
          'typename': 'Girls Room',
          'Subtype': []
        }
      ],
    },
    {
      'name': 'All Type',
      'type': [
        {
          'typename': 'All Type Residencies',
          'Subtype': []
        }
      ],
    },
  ];

  // List<String> filter = [
  //   'Flat',
  //   'Hostel'
  // ];

  int selectedCategoryIndex = 0;
  var name;
  var names;
  var typename;
  int selectedTypeIndex = -1;
  int position = 0;
  int position1 = 0;
  int selectedCategoryIndex2 = -1;
  int selectedTypeIndex2 = -1;


  List<dynamic> resultList = [];
  int _selectedIndex = -1;
  String? isSelected;
  String? sortprice;

  final List<dynamic> _wordName = [
    {"name": "High to Low", "price": "hightolow"},
    {"name": "Low to High", "price": "lowtohigh"},
  ];
  List collectionList = [];
  int _selectedIndex2 = -1;

  final List<dynamic> _wordName2 = [
    {"name": "By Rating", "select": "true"},
  ];

  @override
  void initState() {
    name = filterList[0]['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,

        // centerTitle: true,
        title: Text(
          'Filter',
          style: Sty().largeText.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 360,
              child: Row(
                children: [
                  // Categories (Names) List
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: filterList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: selectedCategoryIndex == index
                              ? Colors.white
                              : Color(0xffeeedeb),
                          title: Text(
                            filterList[index]['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedCategoryIndex = index;
                              name = filterList[index]['name'];
                              selectedTypeIndex = -1; // Reset selected type
                            });
                          },
                        );
                      },
                    ),
                  ),
                  // Subcategories (Types and Subtypes) List
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   physics: NeverScrollableScrollPhysics(),
                            //   itemCount:  filterList[selectedCategoryIndex]['type'][position1]['typename'].length,
                            //   itemBuilder: (context, index) {
                            //     return ListTile(
                            //       minLeadingWidth: 5,
                            //       dense: true,
                            //       leading: selectedCategoryIndex2 == index
                            //           ? Icon(Icons.check_circle,color: Colors.black,)
                            //           : Icon(Icons.circle_outlined,color: Colors.black),
                            //       title: Text(
                            //         filterList[selectedCategoryIndex]['type'][position1]['typename'].toString(),
                            //         style: TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w400,
                            //         ),
                            //       ),
                            //       onTap: () {
                            //         setState(() {
                            //           selectedCategoryIndex2 = index;
                            //           names = filterList[selectedCategoryIndex]['type'][position]['Subtype'][index];
                            //           // name = filterList[index]['name'];
                            //           print('${names}');
                            //           // name = filterList[index]['name'];
                            //           selectedTypeIndex2 = -1; // Reset selected type
                            //         });
                            //       },
                            //     );
                            //   },
                            // ),

                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: filterList[selectedCategoryIndex]['type'].length,
                              itemBuilder: (context, index) {
                                var typeInfo = filterList[selectedCategoryIndex]['type'][index];
                                return ListTile(
                                  leading: collectionList.contains(typeInfo['typename'])
                                      ? Icon(
                                    Icons.check_box,
                                    color: Colors.black,
                                  ) // Change background color
                                      : Icon(
                                    Icons.check_box_outline_blank_sharp,
                                    color: Colors.black,
                                  ),
                                  minLeadingWidth: 5,
                                  dense: true,
                                  title: Text(
                                    typeInfo['typename'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {

                                      selectedTypeIndex = index;
                                      position = filterList[selectedCategoryIndex]['type'].indexWhere((e) => e['typename'] == typeInfo['typename']);
                                      print(position);
                                      print('${typename}dgdggd');
                                    });
                                    if(collectionList.contains(typeInfo['typename'])){
                                      setState(() {
                                        collectionList.remove(typeInfo['typename']);
                                      });
                                    }else{
                                      setState(() {
                                        collectionList.add(typeInfo['typename']);
                                        print(collectionList);
                                      });
                                    }
                                  },
                                );
                              },
                            ),



                            // if (selectedCategoryIndex >= 0)
                            //   for (var typeInfo in filterList[selectedCategoryIndex]['type'])
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         ListTile(
                            //           leading: selectedTypeIndex == filterList[selectedCategoryIndex]['type'].indexOf(typeInfo)
                            //               ? Icon(
                            //             Icons.check_box,
                            //             color: Colors.black,
                            //           ) // Change background color
                            //               : Icon(
                            //               Icons
                            //                   .check_box_outline_blank_sharp,
                            //               color: Colors.black),
                            //           minLeadingWidth: 5,
                            //           dense: true,
                            //           title: Text(
                            //             typeInfo['typename'],
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.w400,
                            //                 fontSize: 14),
                            //           ),
                            //           // tileColor: selectedTypeIndex == filterList[selectedCategoryIndex]['type'].indexOf(typeInfo)
                            //           //     ? Colors.blue.withOpacity(0.2) // Change background color
                            //           //     : null,
                            //           onTap: () {
                            //             setState(() {
                            //               // typename =  filterList[selectedCategoryIndex]['type'].indexOf(typeInfo['typename']);
                            //               selectedTypeIndex = filterList[selectedCategoryIndex]['type'].indexOf(typeInfo);
                            //               position =
                            //                   filterList[selectedCategoryIndex]['type'].indexWhere((e) => e['typename'] == typeInfo['typename']);
                            //               print(position);
                            //               print(typename);
                            //             });
                            //           },
                            //         ),
                            //         // Column(
                            //         //   crossAxisAlignment:
                            //         //       CrossAxisAlignment.start,
                            //         //   children: [
                            //         //     if (selectedTypeIndex ==
                            //         //         filterList[selectedCategoryIndex]
                            //         //                 ['type']
                            //         //             .indexOf(typeInfo))
                            //         //       for (var subtype
                            //         //           in typeInfo['Subtype'])
                            //         //         Text(subtype),
                            //         //   ],
                            //         // ),
                            //       ],
                            //     ),
                            Divider(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:  filterList[selectedCategoryIndex]['type'][position]['Subtype'].length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  minLeadingWidth: 5,
                                  dense: true,
                                  leading: selectedCategoryIndex2 == index
                                      ? Icon(Icons.check_circle,color: Colors.black,)
                                      : Icon(Icons.circle_outlined,color: Colors.black),
                                  title: Text(
                                    filterList[selectedCategoryIndex]['type'][position]['Subtype'][index].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {

                                      selectedCategoryIndex2 = index;
                                      names = filterList[selectedCategoryIndex]['type'][position]['Subtype'][index];
                                      // name = filterList[index]['name'];
                                      print('${names}');
                                      // name = filterList[index]['name'];
                                      selectedTypeIndex2 = -1; // Reset selected type
                                    });
                                  },
                                );
                              },
                            ),
                            // Text(filterList[selectedCategoryIndex]
                            // ['type'][position]['Subtype'].toString())
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only( left: 12.0),
              child: Text(
                'Sort',
                style: Sty().largeText.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sort by price', style: Sty().mediumText),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 100,
                          width: 150,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: _wordName.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // Toggle the selected and deselected state
                                      if (_selectedIndex == index) {
                                        _selectedIndex = -1; // Deselect
                                      } else {
                                        _selectedIndex = index; // Select
                                        print(_wordName[index]['price']);
                                        sortprice = _wordName[index]['price'];
                                      }
                                    });
                                    // setState(() {
                                    //   _selectedIndex = index;
                                    // });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _selectedIndex == index
                                          ? Icon(Icons.check_box_rounded)
                                          : Icon(Icons
                                          .check_box_outline_blank_sharp),
                                      // Icon(_selectedIndex == index
                                      //     ?Icons.check_circle_outline_rounded :
                                      // Icons.circle_outlined,
                                      //     color: _selectedIndex == index
                                      //         ? Color(0xffFA3C5A)
                                      //         : Colors.grey),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: Text(_wordName[index]['name'],
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sort by rating', style: Sty().mediumText),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 60,
                          width: 150,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: _wordName2.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // Toggle the selected and deselected state
                                      if (_selectedIndex2 == index) {
                                        _selectedIndex2 = -1; // Deselect
                                      } else {
                                        _selectedIndex2 = index; // Select
                                        print(_wordName2[index]['select']);
                                        isSelected =
                                        _wordName2[index]['select'];
                                        // print(_wordName[index]['select']);
                                        // sortprice = _wordName[index]['price'];
                                      }
                                    });
                                    // setState(() {
                                    //   _selectedIndex2 = index;
                                    // });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _selectedIndex2 == index
                                          ? Icon(Icons.check_box_rounded)
                                          : Icon(Icons
                                          .check_box_outline_blank_sharp),
                                      // Icon(_selectedIndex == index
                                      //     ?Icons.check_circle_outline_rounded :
                                      // Icons.circle_outlined,
                                      //     color: _selectedIndex == index
                                      //         ? Color(0xffFA3C5A)
                                      //         : Colors.grey),

                                      Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Text(_wordName2[index]['name'],
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 40,
                  width: 140,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff18628),
                      // Set the background color to red
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5.0), // Set border radius
                      ),
                    ),
                    onPressed: () {
                      filter();
                    },
                    child: Text(
                      'APPLY',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filter() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      // 'location_id': 1,
      'location_id': sp.getString('location_id').toString(),
      // 'type': 'Hostel',
      'type':( name == 'All Type')  ?'': '$name',
      'hostel_type': jsonEncode(collectionList),
      // 'hostel_type': ["Girls hostel"],
       'different_charge':names != null?'$names':'',
      'price': sortprice!= null? '$sortprice':'',
      'rating': isSelected,
      'all': true,
    });
    print('${name}dhddgdg');
    var result = await STM().post(ctx, Str().loading, 'filter', body);
    var error = result['error'];
    var message = result['message'];

    if (error){
      // setState(() {
      //   resultList = result['hostel'];
      //   STM().displayToast(message);
      //   // STM().back2Previous(ctx);
      //   print('$resultList' + 'dghstgfgd');
      //   Map<dynamic, dynamic> filterData = {
      //     'pageType': 'myres',
      //     'resultList': resultList,
      //   };
      //   setState(() {
      //     // List<dynamic> resultList ;
      //     Navigator.pop(context, filterData);
      //   });
      // });


      setState(() {
        resultList = result['hostel'];
        STM().displayToast(message);
        // STM().back2Previous(ctx);
        print('$resultList' + 'dghstgfgd');
        setState(() {
          // List<dynamic> resultList ;
          Navigator.pop(context, resultList);
        });
      });
      // setState(() {
      //   STM().back2Previous(ctx);
      //   // _showBottomSheet();
      // });
      // STM().errorDialog(ctx, message);
    } else
    {
      setState(() {
        resultList = result['hostel'];
        STM().displayToast(message);
        // STM().back2Previous(ctx);
        print('$resultList' + 'dghstgfgd');
        setState(() {
          // List<dynamic> resultList ;
          Navigator.pop(context, resultList);
        });
      });
    }
  }
}