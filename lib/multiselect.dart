import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'manage/static_method.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
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
          'typename': ' Boys PG Flat',
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

  int _selectedIndex2 = -1;

  final List<dynamic> _wordName2 = [
    {"name": "By Rating", "select": "true"},
  ];

  @override
  void initState() {
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
          'Filter  testing',
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
                              print(name);
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
                            if (selectedCategoryIndex >= 0)
                              for (var typeInfo
                              in filterList[selectedCategoryIndex]['type'])
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: selectedTypeIndex ==
                                          filterList[selectedCategoryIndex]
                                          ['type']
                                              .indexOf(typeInfo)
                                          ? Icon(
                                        Icons.check_box,
                                        color: Colors.black,
                                      ) // Change background color
                                          : Icon(
                                          Icons
                                              .check_box_outline_blank_sharp,
                                          color: Colors.black),
                                      minLeadingWidth: 5,
                                      dense: true,
                                      title: Text(
                                        typeInfo['typename'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                      // tileColor: selectedTypeIndex == filterList[selectedCategoryIndex]['type'].indexOf(typeInfo)
                                      //     ? Colors.blue.withOpacity(0.2) // Change background color
                                      //     : null,
                                      onTap: () {
                                        setState(() {
                                          // typename =  filterList[selectedCategoryIndex]['type'].indexOf(typeInfo['typename']);
                                          selectedTypeIndex =
                                              filterList[selectedCategoryIndex]
                                              ['type']
                                                  .indexOf(typeInfo);
                                          position =
                                              filterList[selectedCategoryIndex]['type'].indexWhere((e) => e['typename'] == typeInfo['typename']);
                                          print(position);
                                          print(typename);
                                        });
                                      },
                                    ),
                                    // Column(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     if (selectedTypeIndex ==
                                    //         filterList[selectedCategoryIndex]
                                    //                 ['type']
                                    //             .indexOf(typeInfo))
                                    //       for (var subtype
                                    //           in typeInfo['Subtype'])
                                    //         Text(subtype),
                                    //   ],
                                    // ),
                                  ],
                                ),
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
                                    filterList[selectedCategoryIndex]
                                    ['type'][position]['Subtype'][index].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryIndex2 = index;
                                      print(selectedCategoryIndex2);
                                      names = filterList[selectedCategoryIndex]['type'][position]['Subtype'][index];
                                      // name = filterList[index]['name'];
                                      print('${names}');
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
            // SizedBox(
            //   height: 400,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     physics: BouncingScrollPhysics(),
            //     itemCount: filterList.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Padding(
            //         padding: const EdgeInsets.only(bottom: 24.0),
            //         child: InkWell(
            //           onTap: () {
            //             setState(() {
            //               // Toggle the selected and deselected state
            //               // if (_selectedIndex == index) {
            //               //   _selectedIndex = -1; // Deselect
            //               //
            //               // } else {
            //               //   _selectedIndex = index; // Select
            //               //   print(_wordName[index]['price']);
            //               //   sortprice = _wordName[index]['price'];
            //               // }
            //
            //             });
            //             // setState(() {
            //             //   _selectedIndex = index;
            //             // });
            //           },
            //           child: Padding(
            //             padding: EdgeInsets.all( 8),
            //             child: Text(filterList[index]['name'],style: Sty().mediumText.copyWith(fontSize: 18),
            //                 overflow: TextOverflow.ellipsis),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // Card(
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //           Padding(padding: EdgeInsets.all(4)),
            //           Text('18 May, 2022 '),
            //           Row(
            //             children: [
            //               Expanded(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         'Prashant Sharma',
            //                         style: Sty().mediumText.copyWith(
            //                           fontSize: 18,
            //                         ),
            //                       ),
            //                       Text(
            //                         'For : Aniket Hostel',
            //                         style: Sty().mediumText.copyWith(
            //                           fontSize: 14,
            //                         ),
            //                       ),
            //                       Text(
            //                         'Mobile: 9632587414',
            //                         style: Sty().mediumText.copyWith(
            //                           fontSize: 14,
            //                         ),
            //                       ),
            //                     ],
            //                   )),
            //               SvgPicture.asset('assets/call.svg'),
            //
            //             ],
            //           )
            //         ],
            //       ),
            //     )),
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
                    // SizedBox(
                    //   // color: Colors.red,
                    //   width: 200,
                    //   child: ListTile(
                    //
                    //     minLeadingWidth: 10,
                    //     contentPadding: EdgeInsets.zero,
                    //     title: const Text('Low To High'),
                    //     leading: Radio<PriceType>(
                    //       value: PriceType.lowtohigh,
                    //       groupValue: null,
                    //       onChanged: (PriceType? value) {
                    //         // getSearchList('price', 'lowtohigh');
                    //         STM().back2Previous(ctx);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 200,
                    //   child: ListTile(
                    //     minLeadingWidth: 0,
                    //     contentPadding: EdgeInsets.zero,
                    //     title: const Text('High To Low'),
                    //     leading: Radio<PriceType>(
                    //       value: PriceType.hightolow,
                    //       groupValue: null,
                    //       onChanged: (PriceType? value) {
                    //         // getSearchList('price', 'hightolow');
                    //         STM().back2Previous(ctx);
                    //       },
                    //     ),
                    //   ),
                    // ),
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
      'location_id': 1,
      // 'type': 'Hostel',
      'type': '$name',
      'hostel_type': ["Girls hostel"],
      // 'different_charge':' 1BHK',
      'price': '$sortprice',
      'rating': isSelected,
      // 'all': true,
    });
    var result = await STM().post(ctx, Str().loading, 'filter', body);
    var error = result['error'];
    var message = result['message'];

    if (error == false) {
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
    } else {
      setState(() {
        STM().back2Previous(ctx);
        // _showBottomSheet();
      });
      // STM().errorDialog(ctx, message);
    }
  }
}