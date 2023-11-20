import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:quick_room_services/manage/static_method.dart';
import 'package:quick_room_services/values/colors.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/global_urls.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';
import 'my_residency.dart';
import 'values/styles.dart';

class Room extends StatefulWidget {
  bool? isThisForUpdate;
  bool? isThisView;
  String? hostelID;
  String? pageType;

  Room(this.isThisForUpdate, this.isThisView, this.hostelID, this.pageType);

  @override
  State<StatefulWidget> createState() {
    return RoomPage(isThisForUpdate, isThisView, hostelID, pageType);
  }
}

class RoomPage extends State<Room> {
  bool? isThisForUpdate;
  bool? isThisView;
  String? hostelID;
  String? pageType;
  String? newpageType;

  String? selectedValue4;

  RoomPage(
      this.isThisForUpdate, this.isThisView, this.hostelID, this.pageType);

  late BuildContext ctx;

  List<dynamic> facility2 = [];
  List<dynamic> rule = [];
  List<String> priceValue = [];
  List<String> descriValue = [];
  List<String> selectedItems = [];
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _ruleController = TextEditingController();
  TextEditingController _facilityController2 = TextEditingController();
  TextEditingController _otherCtrl = TextEditingController();
  TextEditingController _otherValue = TextEditingController();
  TextEditingController _otherCharge = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool _showMessage = false;
  bool _showMessage2 = false;

  // final formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  List<dynamic> ruleslists = [];
  List<dynamic> facilitylists = [];

  void _handleFocusChange() {
    setState(() {
      _showMessage = _focusNode.hasFocus;
    });
  }

  void _handleFocusChange2() {
    setState(() {
      _showMessage2 = _focusNode2.hasFocus;
    });
  }

  void _addItem() {
    if (_ruleController.text.toString().isNotEmpty) {
      if (!selectedList
          .any((item) => item['rule'] == _ruleController.text.toString())) {
        setState(() {
          selectedList.add({
            'rule': _ruleController.text,
          });
          _ruleController.clear();
        });
      } else {
        STM().displayToast('Item already exists');
      }
    }
    print(_facilityController2.text);
  }

  void _addItem2() {
    if (_facilityController2.text.toString().isNotEmpty) {
      if (!selectedList2.any(
              (item) => item['facility'] == _facilityController2.text.toString())) {
        setState(() {
          selectedList2.add({
            'facility': _facilityController2.text,
          });
          _facilityController2.clear();
        });
      } else {
        STM().displayToast('Item already exists');
      }
    }
    print(_facilityController2.text);
  }

  List<String> hostelTypeList = [
    "Family Room",
    "Boys Room",
    "Girls Room",
  ];

  List<dynamic> hostelType = [];
  String sGender = "Boys Hostel";

  List<String> actionList = ["Single Room", "Double Room"];

  List<TextEditingController> priceCtrl = [];
  List<TextEditingController> descripCtrl = [];
  String? sAction;
  List<String> DepositList = ["No", "Yes"];
  String sDeposit = "No";
  List<String> chargesList = ["No", "Yes"];
  String sCharges = "No";

  List timeList = [
    ["Time", "0"],
    ["No Limit", "1"]
  ];
  String sTime = "0";
  AwesomeDialog? dialog;
  bool loaded = true;
  String latitude = '';
  String longitude = '';

  String locationCapText =
      'Click on the button to capture your current location. You should be at your residencial location';

  String? selectedValue;
  List arrayList = [];

  List<Map<String, dynamic>> diffChargList = [];
  List<Map<String, dynamic>> changeList = [];

  TextEditingController hostelName = TextEditingController();
  TextEditingController hostelAddress = TextEditingController();

  // TextEditingController selectLocation = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController ownerNumber = TextEditingController();
  TextEditingController alternateNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telephoneNumber = TextEditingController();
  TextEditingController vacancyInNumber = TextEditingController();
  TextEditingController monthlyCharge = TextEditingController();
  TextEditingController facility = TextEditingController();
  TextEditingController conditions = TextEditingController();
  TextEditingController closeTime = TextEditingController();
  TextEditingController openTime = TextEditingController();
  TextEditingController whySelect = TextEditingController();
  TextEditingController moreAbout = TextEditingController();
  TextEditingController leavingPolicy = TextEditingController();
  TextEditingController extraCharges = TextEditingController();
  TextEditingController depositCtr = TextEditingController();

  int imageCount = 0;
  List<String> image64Strings = [];
  List<Widget> imagesList = [];

  List<String> allImagesBase64 = [];
  bool imagesChoosen = false;

  Future getLocations() async {
    setState(() {
      loaded = false;
    });
    var dio = Dio();
    // var formData = FormData.fromMap({
    // });
    var response = await dio.get(getLocationsUrl());
    var res = response.data;
    print(res);

    if (res['locations'].length > 0) {
      arrayList = [];
      for (int i = 0; i < res['locations'].length; i++) {
        arrayList.add([
          res['locations'][i]['id'].toString(),
          res['locations'][i]['name'].toString()
        ]);
      }
      selectedValue = res['locations'][0]['id'].toString();
    } else {
      arrayList.add(['0', 'No value']);
    }
    setState(() {
      arrayList = arrayList;
      // selectedValue = selectedValue;
      loaded = true;
    });
  }

  List<Map<String, dynamic>> selectedList = [
    {
      'rule': null,
    }
  ];
  List<Map<String, dynamic>> selectedList2 = [
    {
      'facility': null,
    }
  ];

  // final _items = selectedList5.map((e) => MultiSelectItem<e>(e, e['facility']))
  //     .toList();

  List<dynamic> selectedList3 = [];
  var valuessss;
  List<String> selectTedRule = [];
  List<String> selectTedFacility = [];
  List<dynamic> imageList = [];

  void getAndUpdateImagesOnly() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    setState(() {
      loaded = false;
    });
    var dio = Dio();
    var formData = FormData.fromMap({
      'hostel_id': hostelID.toString(),
      'user_id': sp.getString('user_id').toString()
    });

    print("HOSTEL ID: " + hostelID.toString());
    print("USER ID: " + sp.getString('user_id').toString());

    var response = await dio.post(getHostelDetails(), data: formData);
    var res = response.data;
    print(res);

    imageList = [];
    for (int i = 0; i < res['hostel']['imgs'].length; i++) {
      imageList.add([
        res['hostel']['imgs'][i]['image_path'].toString(),
        res['hostel']['imgs'][i]['id'].toString()
      ]);
    }
    setState(() {
      loaded = true;
      imageList = imageList;
    });
  }

  int? positions;

  void getHostel() async {
    print("Fetching HOSTEL DETAILS FOR UPDATE");
    SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.getString('location_id').toString();

    setState(() {
      loaded = false;
    });
    var dio = Dio();
    var formData = FormData.fromMap({
      'hostel_id': hostelID.toString(),
      'user_id': sp.getString('user_id').toString()
    });

    print("HOSTEL ID: " + hostelID.toString());
    print("USER ID: " + sp.getString('user_id').toString());

    var response = await dio.post(getHostelDetails(), data: formData);
    var res = response.data;
    print(res);

    imageList = [];
    for (int i = 0; i < res['hostel']['imgs'].length; i++) {
      imageList.add([
        res['hostel']['imgs'][i]['image_path'].toString(),
        res['hostel']['imgs'][i]['id'].toString()
      ]);
    }
    if (res['error'] != true) {
      hostelName.text = res['hostel']['name'].toString();
      print("Updated controllers");
      hostelAddress.text = res['hostel']['address'].toString();
      // locationIdentification

      ownerName.text = res['hostel']['owner_name'].toString();
      ownerNumber.text = res['hostel']['owner_number'].toString();
      alternateNumber.text = res['hostel']['whatsapp_number'] != null
          ? res['hostel']['whatsapp_number'].toString()
          : "";
      email.text = res['hostel']['email'] != null
          ? res['hostel']['email'].toString()
          : "";
      telephoneNumber.text = res['hostel']['tel_number'] != null
          ? res['hostel']['tel_number'].toString()
          : "";

      vacancyInNumber.text = res['hostel']['vancany'].toString();
      closeTime.text = formatTime(res['hostel']['close_time'].toString());
      // openTime.text = res['hostel']['open_time'].toString();
      openTime.text = formatTime(res['hostel']['open_time'].toString());
      monthlyCharge.text = res['hostel']['monthly_charge'].toString();
      facility.text = res['hostel']['facility'].toString();
      conditions.text = res['hostel']['condition'].toString();
      whySelect.text = res['hostel']['why_this_residence'] ?? ''.toString();
      moreAbout.text = res['hostel']['about_residence'] ?? ''.toString();
      extraCharges.text = res['hostel']['extra_desc'] ?? ''.toString();
      depositCtr.text = res['hostel']['deposit_desc'] ?? ''.toString();
      leavingPolicy = TextEditingController(
          text: res['hostel']['leaving_policy'] ?? ''.toString());
      facility2 = hostelType = res['hostel']['hostel_type'] == null
          ? []
          : res['hostel']['hostel_type'];
      rule =
      res['hostel']['condition'] == null ? [] : res['hostel']['condition'];
      facility2 =
      res['hostel']['facility'] == null ? [] : res['hostel']['facility'];
      // for (int a = 0; a < facility2.length; a++) {
      //   selectedList2.add({'facility': facility2[a]});
      // }
      if (res['hostel']['facility'] != null)
        for (int a = 0; a < res['hostel']['facility'].length; a++) {
          selectedList2
              .map((e) => e['facility'])
              .contains(res['hostel']['facility'][a])
              ? null
              : selectedList2.add({'facility': res['hostel']['facility'][a]});
        }
      if (res['hostel']['condition'] != null)
        for (int a = 0; a < res['hostel']['condition'].length; a++) {
          selectedList
              .map((e) => e['rule'])
              .contains(res['hostel']['condition'][a])
              ? null
              : selectedList.add({'rule': res['hostel']['condition'][a]});
        }

      List aa = [];
      aa = res['hostel']['different_charge'];
      for (int a = 0; a < aa.length; a++) {
        if (actionList
            .map((e) => e.toString())
            .contains(aa[a]['type'].toString())) {
          int position = actionList.indexWhere(
                  (element) => element.toString() == aa[a]['type'].toString());
          priceCtrl[position] = TextEditingController(text: aa[a]['charge']);
          descripCtrl[position] =
              TextEditingController(text: aa[a]['description']);
          diffChargList.add({
            "type": aa[a]['type'],
            'index': a,
            "charge": aa[a]['charge'],
            "description": aa[a]['description'],
          });
        } else {
          _otherCtrl = TextEditingController(text: aa[a]['type']);
          _otherValue = TextEditingController(text: aa[a]['charge']);
          _otherCharge = TextEditingController(text: aa[a]['description']);
        }
      }
      // diffChargList.add({
      //   "type": actionList[index],
      //   "charge": priceCtrl[index].text,
      //   "description": descripCtrl[index].text,
      // });

      // rule =  res['hostel']['different_charge'] == null ? [] :res['hostel']['different_charge'];

      setState(() {
        loaded = true;
        imageList = imageList;
        sGender = res['hostel']['hostel_type'].toString();
        sCharges = res['hostel']['extra_charge'].toString();
        sTime = res['hostel']['has_close_time'].toString();
        sDeposit = res['hostel']['deposit'].toString();
        locationCapText = res['hostel']['latitude'].toString() +
            " " +
            res['hostel']['longitude'].toString();
        latitude = res['hostel']['latitude'].toString();
        longitude = res['hostel']['longitude'].toString();
        selectedValue = res['hostel']['location_id'].toString();
        selectedValue = res['hostel']['location_id'].toString();
        selectedValue = res['hostel']['location_id'].toString();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: Colors.red),
            ),
            content: Text('Cannot be updated since status is inactive'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK")),
            ],
          );
        },
      );
    }
  }

  String formatTime(String timeString) {
    final DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  void updateHostel(
      String hostelName,
      String hostelAddress,
      String locationIdentification,
      String ownerName,
      String ownerNumber,
      String altNumber,
      String email,
      String telNumber,
      String hostel_type,
      String vacancy,
      String extra_charge,
      String has_close_time,
      String monthly_charge,
      String facility,
      String condition,
      String latitude,
      String longitude,
      ) async {
    print("UPDATE METHOD CALLED");
    setState(() {
      loaded = false;
    });
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      print(has_close_time);
      var dio = Dio();

      var formData = FormData.fromMap({
        'id': hostelID.toString(),
        'name': hostelName,
        'address': hostelAddress,
        'location_id': locationIdentification,
        'owner_name': ownerName,
        'owner_number': ownerNumber,
        'whatsapp_number': altNumber,
        'alt_number': altNumber,
        'email': email,
        'tel_number': telNumber,
        'type': newpageType,
        // 'hostel_type': hostel_type,
        // 'hostel_type': ,
        'hostel_type': jsonEncode(hostelType),
        'vancany': vacancy,
        'extra_charge': sCharges,
        'extra_desc': extraCharges.text.toString(),
        // 'extra_charge': extra_charge,
        'has_close_time': has_close_time,
        'open_time': has_close_time == "0" ? openTime.text.toString() : "0",
        'close_time': has_close_time == "0" ? closeTime.text.toString() : "0",
        'monthly_charge': monthly_charge,
        'different_charge': jsonEncode(changeList),
        // 'different_charge': jsonEncode([
        //   {"type": "1BHK", "charge": 100, "description": "test"}
        // ]),
        'deposit': sDeposit,
        'deposit_desc': depositCtr.text.toString(),
        'facility': jsonEncode(facility2),
        // 'facility': facility,
        // 'condition': condition,
        'condition': jsonEncode(rule),
        'why_this_residence': whySelect.text.toString(),
        'about_residence': moreAbout.text.toString(),
        'leaving_policy': leavingPolicy.text.toString(),
        'latitude': latitude,
        'longitude': longitude,
        'images': jsonEncode(croppedFiles),
        //allImagesBase64.toString(),
        'user_id': sp.getString('user_id').toString(),

        // 'name': hostelName,
        // 'address': hostelAddress,
        // 'location_id': locationIdentification,
        // 'owner_name': ownerName,
        // 'owner_number': ownerNumber,
        // 'alt_number': altNumber,
        // 'email': email,
        // 'tel_number': telNumber,
        // 'hostel_type': hostel_type,
        // 'vancany': vacancy,
        // 'extra_charge': 'no',
        // 'extra_desc': extraCharges.text.toString(),
        //
        // // 'extra_charge': extra_charge,
        // 'has_close_time': has_close_time,
        // 'close_time': has_close_time == "0" ? closeTime.text.toString() : "0",
        // 'open_time': has_close_time == "0" ? openTime.text.toString() : "0",
        // 'monthly_charge': monthly_charge,
        // 'facility': facility,
        // 'condition': condition,
        // 'why_this_residence': whySelect.text.toString(),
        // 'about_residence': moreAbout.text.toString(),
        // 'leaving_policy': leavingPolicy.text.toString(),
        // 'latitude': latitude,
        // 'longitude': longitude,
        // 'images': jsonEncode(croppedFiles), // allImagesBase64.toString(),
        // 'user_id': sp.getString('user_id').toString(),
      });
      var response = await dio.post(updateHostelUrl(), data: formData);
      var res = response.data;
      if (res['error'] == false) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Success",
                style: TextStyle(color: Colors.green),
              ),
              content: Text(res['message'].toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyResidency()));
                    },
                    child: Text("OK")),
              ],
            );
          },
        );
      }
      print(res);
    } catch (e) {
      print("Error");
      print(e.runtimeType);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: Colors.red),
            ),
            content: Text('Server error'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK")),
            ],
          );
        },
      );
    }
    setState(() {
      loaded = true;
    });
  }

  // void AddHostel() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   FormData body = FormData.fromMap({
  //     'name': hostelName,
  //     'address': hostelAddress,
  //     'location_id': locationIdentification,
  //     'owner_name': ownerName,
  //     'owner_number': ownerNumber,
  //     'alt_number': altNumber,
  //     'email': email,
  //     'tel_number': telNumber,
  //     'hostel_type': hostel_type,
  //     'vancany': vacancy,
  //     'extra_charge': extra_charge,
  //     'has_close_time': has_close_time,
  //     'close_time': has_close_time == "0" ? closeTime.text.toString() : "0",
  //     'monthly_charge': monthly_charge,
  //     'facility': jsonEncode(facility2),
  //     // 'facility': facility,
  //     // 'condition': condition,
  //     'condition': jsonEncode(rule),
  //     'latitude': latitude,
  //     'longitude': longitude,
  //     'images': jsonEncode(croppedFiles), //allImagesBase64.toString(),
  //     'user_id': sp.getString('user_id').toString(),
  //   });
  //   var result = await STM().post(ctx, Str().loading, 'add_hostel', body);
  //   setState(() {
  //     loaded = true;
  //     hostalData = result['hostel'];
  //     similarList = result['similar_hostel'];
  //     // averageRate = result['review_avg'];
  //     imageList = result['hostel']['imgs'];
  //   });
  // }
  void addHostel(
      String hostelName,
      String hostelAddress,
      String locationIdentification,
      String ownerName,
      String ownerNumber,
      String altNumber,
      String email,
      String telNumber,
      String hostel_type,
      String vacancy,
      String extra_charge,
      String has_close_time,
      String monthly_charge,
      // String facility,
      // String condition,
      String latitude,
      String longitude,
      ) async {
    // setState(() {
    //   loaded = false;
    //
    // });

    SharedPreferences sp = await SharedPreferences.getInstance();
    print(has_close_time);
    // var dio = Dio();
    var body = FormData.fromMap({
      'name': hostelName,
      'address': hostelAddress,
      'location_id': locationIdentification,
      'owner_name': ownerName,
      'owner_number': ownerNumber,
      'whatsapp_number': altNumber,
      'alt_number': altNumber,
      'email': email,
      'tel_number': telNumber,
      'type': newpageType,
      // 'hostel_type': hostel_type,
      // 'hostel_type': ,
      'hostel_type': jsonEncode(hostelType),
      'vancany': vacancy,
      'extra_charge': sCharges,
      'extra_desc': extraCharges.text.toString(),
      // 'extra_charge': extra_charge,
      'has_close_time': has_close_time,
      'open_time': has_close_time == "0" ? openTime.text.toString() : "0",
      'close_time': has_close_time == "0" ? closeTime.text.toString() : "0",
      'monthly_charge': monthly_charge,
      // 'different_charge': jsonEncode([
      //   {"type": "1BHK", "charge": 100, "description": "test"}
      // ]),
      'different_charge': jsonEncode(changeList),
      'deposit': sDeposit,
      'deposit_desc': depositCtr.text.toString(),
      'facility': jsonEncode(facility2),
      // 'facility': facility,
      // 'condition': condition,
      'condition': jsonEncode(rule),
      'why_this_residence': whySelect.text.toString(),
      'about_residence': moreAbout.text.toString(),
      'leaving_policy': leavingPolicy.text.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'images': jsonEncode(croppedFiles), //allImagesBase64.toString(),
      'user_id': sp.getString('user_id').toString(),
    });
    var response = await STM().post(ctx, Str().loading, 'add_hostel', body);
    // var response = await dio.post(addHostelUrl(), data: formData);
    var res = response;

    var error = res['error'];
    var message = res['message'];
    print('gsdfg${widget.pageType}');

    if (error == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Success",
              style: TextStyle(color: Colors.green),
            ),
            content: Text(res['message'].toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyResidency()));
                  },
                  child: Text("OK")),
            ],
          );
        },
      );
    } else {
      print(message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: Colors.red),
            ),
            content: Text('Server error'),
            // content: Text('${message}'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("OK")),
            ],
          );
        },
      );
    }
    print(res);
  }

  // print(e.runtimeType);

  void setAllStates() {
    print("SET ALL STATES");
    print(image64Strings);
    print(imagesList);

    setState(() {
      imagesList = imagesList;
      image64Strings = image64Strings;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      imagesList = imagesList;
      image64Strings = image64Strings;
    }));
  }

  String imgToBase64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    String header = "data:image/png;base64,";
    return base64String;
  }

  Widget imagePicker() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: () async {
          chooseImage();
        },
        child: Container(
          padding: EdgeInsets.all(15),
          color: Color.fromARGB(255, 216, 216, 216),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(!imagesChoosen ? "Upload images" : "Ready to upload",
                  style: TextStyle(fontSize: 12, color: Colors.black45)),
              !imagesChoosen
                  ? Icon(
                Icons.upload,
                color: Colors.blue,
              )
                  : Icon(Icons.done, color: Colors.green)
            ],
          ),
        ),
      ),
    );
  }

  List<XFile>? receivedFiles = [];
  List<String> croppedFiles = [];
  List<File> resultList = [];

  final ImagePicker _picker = ImagePicker();

  void chooseImage() async {
    receivedFiles = await _picker.pickMultiImage();
    MultiImageCrop.startCropping(
        context: context,
        alwaysShowGrid: true,
        activeColor: Colors.amber,
        pixelRatio: 3,
        files: List.generate(
            receivedFiles!.length, (index) => File(receivedFiles![index].path)),
        callBack: (List<File> images) {
          // var image;
          var image;
          setState(() {
            resultList = images;
          });
          // print(resultList);
          List<dynamic> list = [];
          for (var a = 0; a < images.length; a++) {
            setState(() {
              list.add({'type': 'file', 'image': images[a]});
              image = images[a].readAsBytesSync();
              // image = images[a].readAsBytesSync();
              croppedFiles.add(base64Encode(image).toString());
            });
          }
          print(croppedFiles.length);
        },
        aspectRatio: 16 / 9);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getReview();
      getfacilities();
    });
    getLocations().then((value) {
      if (isThisForUpdate!) {
        getHostel();
      }
    });
    _focusNode.addListener(_handleFocusChange);
    _focusNode2.addListener(_handleFocusChange2);

    // insertInitials();
    super.initState();
  }

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    imagesList = imagesList;
    image64Strings = image64Strings;
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        backgroundColor: Color(0xff21488c),
        leading: InkWell(
            onTap: () {
              STM().back2Previous(ctx);
            },
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: isThisForUpdate!
            ? Text(isThisView! ? "View Room" : "Update Room")
            : Text('Add ${widget.pageType}'),
        // title: isThisForUpdate! ? Text("Update Hostel") : Text('Add Hostel'),
      ),
      body: SingleChildScrollView(
        controller: controller,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: AbsorbPointer(
          absorbing: isThisView!,
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Fill the below complete information well so that resident can understand easily \nFields marked with a star(*) are mandatory to fill',
                    style: Sty().mediumText.copyWith(fontSize: 15)),

                SizedBox(
                  height: 20,
                ),
                Text(
                  '${widget.pageType} Type *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),

                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('You can select multiple options',
                      style: Sty().mediumText.copyWith(fontSize: 15)),
                ),
                SizedBox(
                  height: 12,
                ),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: hostelTypeList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index2) {
                    return InkWell(
                      onTap: () {
                        if (hostelType.contains(hostelTypeList[index2])) {
                          setState(() {
                            hostelType.remove(hostelTypeList[index2]);
                          });
                        } else {
                          setState(() {
                            hostelType.add(hostelTypeList[index2]);
                            print(hostelType);
                          });
                        }
                        print("${hostelType} + 'send data to api'");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Row(children: [
                          hostelType.contains(hostelTypeList[index2])
                              ? Icon(
                            Icons.check_circle,
                            color: Colors.black,
                          )
                              : Icon(Icons.circle_outlined,
                              color: Colors.black),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            hostelTypeList[index2].toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ]),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 12,
                ),

                // Column(
                //   children: [
                //     Row(
                //       children: [
                //         Radio<String>(
                //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           value: hostelTypeList[0],
                //           groupValue: sGender,
                //           onChanged: (value) {
                //             setState(() {
                //               sGender = value!;
                //             });
                //           },
                //           activeColor: Clr().primaryColor,
                //         ),
                //         Text(
                //           hostelTypeList[0],
                //           style: Sty().mediumText,
                //         ),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Radio<String>(
                //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           value: hostelTypeList[1],
                //           groupValue: sGender,
                //           onChanged: (value) {
                //             setState(() {
                //               sGender = value!;
                //             });
                //           },
                //           activeColor: Clr().primaryColor,
                //         ),
                //         Text(
                //           hostelTypeList[1],
                //           style: Sty().mediumText,
                //         ),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Radio<String>(
                //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           value: hostelTypeList[2],
                //           groupValue: sGender,
                //           onChanged: (value) {
                //             setState(() {
                //               sGender = value!;
                //             });
                //           },
                //           activeColor: Clr().primaryColor,
                //         ),
                //         Text(
                //           hostelTypeList[2],
                //           style: Sty().mediumText,
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),

                SizedBox(height: 16.0),

                Text('Residency Name: *',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  controller: hostelName,
                  maxLines: 100,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter residency Name',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Residency Address: *',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  maxLines: 100,
                  minLines: 1,
                  controller: hostelAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter residency Address',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: Dim().d28,
                ),
                Text('Select Area: *',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 20),
                Text('Select the area in which your residency is loacted',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w400)),
                SizedBox(height: Dim().d28),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      )),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Color(0xff000000)),
                      items: arrayList.map((val) {
                        return DropdownMenuItem<String>(
                          value: val[0],
                          child: Text(val[1]),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          selectedValue = v!;
                          print(selectedValue);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d28,
                ),
                Container(
                  color: Clr().lightShadow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Map Location: *',
                        style: Sty().mediumText.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                                locationCapText,
                                style: Sty().mediumText.copyWith(
                                  fontSize: 12,
                                ),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 40,
                            width: 120,
                            child: ElevatedButton(
                                style: Sty().primaryButton.copyWith(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      )),
                                ),
                                onPressed: () {
                                  permissionHandle();
                                },
                                child: Text('Capture',
                                    style: Sty().mediumText.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ))),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Text('Operator Name: *',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  controller: ownerName,
                  maxLines: 100,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter Operator Name',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Operator Number: *',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  controller: ownerNumber,
                  maxLines: 100,
                  minLines: 1,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter Operator Number',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Whatsapp Number:',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  maxLines: 100,
                  minLines: 1,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: alternateNumber,
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter whatsapp Number',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Email:',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  controller: email,
                  maxLines: 100,
                  minLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter Email',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Telephone Number:',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  maxLength: 10,
                  maxLines: 100,
                  minLines: 1,
                  keyboardType: TextInputType.number,
                  controller: telephoneNumber,
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter Telephone Number',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Total Vacant ${widget.pageType} *',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  maxLines: 100,
                  minLines: 1,
                  // maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: vacancyInNumber,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter total vacant ${widget.pageType}',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Text('Monthly Avarage Rent *',
                    style: Sty()
                        .mediumText
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: monthlyCharge,
                  maxLines: 100,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter monthly avarage rent ',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   controller: vacancyInNumber,
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.all(10),
                //     hintText: 'Enter monthly avarage rent ',
                //     hintStyle: TextStyle(fontSize: 13),
                //     border: InputBorder.none,
                //     fillColor: Colors.black12,
                //     filled: true,
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Different Charges *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 0.8,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Dim().d8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('You can Select multiple option',
                              style: Sty().mediumText.copyWith(fontSize: 15)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Room Type',
                                style: Sty().mediumText.copyWith(fontSize: 15)),
                            Text('Room Rent',
                                style: Sty().mediumText.copyWith(fontSize: 15))
                          ],
                        ),
                        SizedBox(height: 20.0),
                        ListView.builder(
                            itemCount: actionList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              priceCtrl.add(TextEditingController());
                              descripCtrl.add(TextEditingController());
                              priceValue.add('');
                              descriValue.add('');
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (diffChargList
                                              .map((e) => e['type'].toString())
                                              .contains(actionList[index].toString())) {
                                            setState(() {
                                              int position = diffChargList.indexWhere((element) =>
                                              element['type'].toString() == actionList[index].toString());
                                              diffChargList.removeAt(position);
                                            });
                                          } else {
                                            setState(() {
                                              diffChargList.add({
                                                "type": actionList[index],
                                                'index': index,
                                                "charge": priceCtrl[index].text,
                                                "description": descripCtrl[index].text,
                                              });
                                            });
                                            print(diffChargList);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          child: Row(children: [
                                            diffChargList
                                                .map((e) =>
                                                e['type'].toString())
                                                .contains(actionList[index]
                                                .toString())
                                                ? Icon(
                                              Icons.check_circle,
                                              color: Colors.black,
                                            )
                                                : Icon(Icons.circle_outlined,
                                                color: Colors.black),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              actionList[index],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Radio<String>(
                                      //       materialTapTargetSize:
                                      //           MaterialTapTargetSize.shrinkWrap,
                                      //       value: actionList[index],
                                      //       groupValue: diffChargList.isEmpty ? '' : diffChargList[index]['type'],
                                      //       onChanged: (value) {
                                      //         if (diffChargList.map((e) => e['type'].toString()).contains(actionList[index].toString())) {
                                      //           setState(() {
                                      //             diffChargList.remove(
                                      //                 actionList[index]
                                      //                     .toString());
                                      //           });
                                      //         } else {
                                      //           setState(() {
                                      //             diffChargList.add({
                                      //               "type": actionList[index],
                                      //               "charge":
                                      //                   priceCtrl[index].text,
                                      //               "description":
                                      //                   descripCtrl[index].text,
                                      //             });
                                      //           });
                                      //         }
                                      //         setState(() {
                                      //           sAction = value!;
                                      //
                                      //           print(diffChargList);
                                      //         });
                                      //       },
                                      //       activeColor: Clr().primaryColor,
                                      //     ),
                                      //     Text(
                                      //       actionList[index],
                                      //       style: Sty().mediumText,
                                      //     ),
                                      //   ],
                                      // ),
                                      SizedBox(
                                        width: 130,
                                        child: TextFormField(
                                          maxLines: 100,
                                          minLines: 1,
                                          controller: priceCtrl[index],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (diffChargList
                                                .map(
                                                    (e) => e['type'].toString())
                                                .contains(actionList[index]
                                                .toString())) {
                                              if (value!.isEmpty) {
                                                return 'This field is required';
                                              }
                                            }
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: "1000₹",
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                            ),
                                            border: InputBorder.none,
                                            fillColor: Colors.black12,
                                            filled: true,
                                            // suffixIcon:  ElevatedButton(
                                            //   onPressed: _addItem,
                                            //   child: Text('Add Item'),
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // if (positions != null)
                                  //   priceCtrl[index].text.isNotEmpty ? Container()  : index == positions!
                                  //       ? diffChargList
                                  //       .map((e) => e['type'].toString())
                                  //       .contains(actionList[index].toString())
                                  //       ? Container()
                                  //       : Row(
                                  //     crossAxisAlignment:
                                  //     CrossAxisAlignment.end,
                                  //     mainAxisAlignment:
                                  //     MainAxisAlignment.end,
                                  //     children: [
                                  //       Text('This Field is required',
                                  //           textAlign:
                                  //           TextAlign.center,
                                  //           style: Sty()
                                  //               .mediumText
                                  //               .copyWith(
                                  //               height: 1.5,
                                  //               fontSize: 12,
                                  //               color:
                                  //               Clr().red)),
                                  //     ],
                                  //   )
                                  //       : Container(),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    maxLines: 100,
                                    minLines: 1,
                                    validator: (value) {
                                      if (diffChargList
                                          .map(
                                              (e) => e['type'].toString())
                                          .contains(actionList[index]
                                          .toString())) {
                                        if (value!.isEmpty) {
                                          return 'This field is required';
                                        }
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: descripCtrl[index],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText:
                                      "What are included in the above charges ?",
                                      hintStyle: TextStyle(fontSize: 13),
                                      border: InputBorder.none,
                                      fillColor: Colors.black12,
                                      filled: true,
                                      // suffixIcon:  ElevatedButton(
                                      //   onPressed: _addItem,
                                      //   child: Text('Add Item'),
                                      // ),
                                    ),
                                  ),
                                  // if (positions != null)
                                  //   descripCtrl[index].text.isNotEmpty ?  Container() :  index == positions!
                                  //       ? diffChargList
                                  //       .map((e) => e['type'].toString()).contains(actionList[index].toString()) ? Container() : Row(
                                  //     children: [
                                  //       Text('This Field is required',
                                  //           textAlign:
                                  //           TextAlign.start,
                                  //           style: Sty()
                                  //               .mediumText
                                  //               .copyWith(
                                  //               height: 1.5,
                                  //               fontSize: 12,
                                  //               color:
                                  //               Clr().red)),
                                  //     ],
                                  //   )
                                  //       : Container(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 130,
                              child: TextFormField(
                                maxLines: 100,
                                minLines: 1,
                                textAlign: TextAlign.center,
                                controller: _otherCtrl,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Other",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  fillColor: Colors.black12,
                                  filled: true,

                                  // suffixIcon:  ElevatedButton(
                                  //   onPressed: _addItem,
                                  //   child: Text('Add Item'),
                                  // ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 130,
                              child: TextFormField(
                                maxLines: 100,
                                minLines: 1,
                                textAlign: TextAlign.center,
                                onEditingComplete: () {
                                  // _addItem2();
                                  // Trigger the API call when editing is complete
                                },
                                controller: _otherValue,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "1000₹",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  fillColor: Colors.black12,
                                  filled: true,

                                  // suffixIcon:  ElevatedButton(
                                  //   onPressed: _addItem,
                                  //   child: Text('Add Item'),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLines: 100,
                          minLines: 1,
                          onEditingComplete: () {
                            // _addItem2();
                            // Trigger the API call when editing is complete
                          },
                          controller: _otherCharge,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText:
                            "What are included in the above charges ?",
                            hintStyle: TextStyle(fontSize: 13),
                            border: InputBorder.none,
                            fillColor: Colors.black12,
                            filled: true,
                            // suffixIcon:  ElevatedButton(
                            //   onPressed: _addItem,
                            //   child: Text('Add Item'),
                            // ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Deposit *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          // value: sDeposit[0],
                          value: DepositList[0],
                          groupValue: sDeposit,
                          onChanged: (value) {
                            setState(() {
                              sDeposit = value!;
                            });
                          },
                          activeColor: Clr().primaryColor,
                        ),
                        Text(
                          DepositList[0],
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          value: DepositList[1],
                          groupValue: sDeposit,
                          onChanged: (String? value) {
                            setState(() {
                              sDeposit = value!;
                            });
                          },
                          activeColor: Clr().primaryColor,
                        ),
                        Text(
                          DepositList[1],
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                  ],
                ),
                if (sDeposit == DepositList[1]) SizedBox(height: 8),
                if (sDeposit == DepositList[1])
                  TextFormField(
                    maxLines: 100,
                    minLines: 1,
                    // maxLines: 1,
                    controller: depositCtr,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Explain all about deposit',
                      hintStyle: TextStyle(fontSize: 13),
                      border: InputBorder.none,
                      fillColor: Colors.black12,
                      filled: true,
                    ),
                  ),
                SizedBox(
                  height: 28,
                ),
                Text(
                  'Extra Charges: *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          value: chargesList[0],
                          groupValue: sCharges,
                          onChanged: (value) {
                            setState(() {
                              sCharges = value!;
                            });
                          },
                          activeColor: Clr().primaryColor,
                        ),
                        Text(
                          chargesList[0],
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          value: chargesList[1],
                          groupValue: sCharges,
                          onChanged: (String? value) {
                            setState(() {
                              sCharges = value!;
                            });
                          },
                          activeColor: Clr().primaryColor,
                        ),
                        Text(
                          chargesList[1],
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                  ],
                ),
                if (sCharges == chargesList[1]) SizedBox(height: 8),
                if (sCharges == chargesList[1])
                  TextFormField(
                    maxLines: 100,
                    minLines: 1,
                    // maxLines: 1,
                    controller: extraCharges,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Explain extra charges',
                      hintStyle: TextStyle(fontSize: 13),
                      border: InputBorder.none,
                      fillColor: Colors.black12,
                      filled: true,
                    ),
                  ),
                SizedBox(
                  height: 28,
                ),
                Text(
                  'Gate Closing & Opning Time: *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          value: timeList[0][1],
                          groupValue: sTime,
                          onChanged: (value) {
                            setState(() {
                              sTime = value!;
                            });
                          },
                          activeColor: Clr().primaryColor,
                        ),
                        Text(
                          timeList[0][0],
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          value: timeList[1][1],
                          groupValue: sTime,
                          onChanged: (String? value) {
                            setState(() {
                              sTime = value!;
                            });
                          },
                          activeColor: Clr().primaryColor,
                        ),
                        Text(
                          timeList[1][0],
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                sTime == timeList[0][1]
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Closing Time',
                        style: Sty().mediumText.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                    Text('Opening time',
                        style: Sty().mediumText.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                  ],
                )
                    : SizedBox(
                  height: 0,
                ),
                sTime == timeList[0][1]
                    ? SizedBox(height: 12)
                    : SizedBox(
                  height: 0,
                ),
                sTime == timeList[0][1]
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        closeTime.text = "";
                        TimeOfDay time = TimeOfDay.now();
                        FocusScope.of(context)
                            .requestFocus(new FocusNode());

                        TimeOfDay? picked = await showTimePicker(
                            context: context, initialTime: time);
                        if (picked != null && picked != time) {
                          closeTime.text = "";
                          // print(picked.format(context).toString());
                          print(
                              'hskgfddgfhhhghgd${picked.format(context).toString()}');
                          // closeTime.text = picked.hour.toString() +
                          //     ':' +
                          //     picked.minute.toString() +
                          //     ':' +
                          //     '00'; // add this line.
                          setState(() {
                            time = picked;
                            print('gfddgf${picked}');
                            // closeTime = TextEditingController(
                            //     text: picked.format(context).toString());
                            closeTime.text =
                                picked.format(context).toString();
                            print('closeTime${closeTime.text}');
                          });
                        }
                      },
                      child: SizedBox(
                        width: 150,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.datetime,
                          controller: closeTime,
                          enabled: false,
                          onTap: () async {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'cant be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "09.30 PM",
                            hintStyle: TextStyle(fontSize: 13),

                            // hintText: '\u20b91000',
                            border: InputBorder.none,
                            fillColor: Colors.black12,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        openTime.text = "";
                        TimeOfDay time = TimeOfDay.now();
                        FocusScope.of(context)
                            .requestFocus(new FocusNode());

                        TimeOfDay? picked = await showTimePicker(
                            context: context, initialTime: time);
                        if (picked != null && picked != time) {
                          openTime.text = "";
                          print(picked.format(context).toString());
                          // openTime.text = picked.hour.toString() +
                          //     ':' +
                          //     picked.minute.toString() +
                          //     ':' +
                          //     '00'; // add this line.
                          setState(() {
                            time = picked;
                            openTime = TextEditingController(
                                text: picked.format(context).toString());
                            // openTime.text = picked.format(context).toString();
                            print('openTime${openTime.text}');
                          });
                        }
                      },
                      child: SizedBox(
                        width: 150,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.datetime,
                          controller: openTime,
                          enabled: false,
                          onTap: () async {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'cant be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "09.30 AM",
                            hintStyle: TextStyle(fontSize: 13),
                            // hintText: '\u20b91000',
                            border: InputBorder.none,
                            fillColor: Colors.black12,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : SizedBox(
                  height: 0,
                ),
                SizedBox(height: 20),
                // Text('Monthly Charge: *',
                //     style: Sty()
                //         .mediumText
                //         .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
                // SizedBox(height: 12),
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   controller: monthlyCharge,
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.all(10),
                //     hintText: '\u20b91000',
                //     hintStyle: TextStyle(fontSize: 13),
                //     border: InputBorder.none,
                //     fillColor: Colors.black12,
                //     filled: true,
                //   ),
                // ),
                // SizedBox(height: 20),
                Text(
                  'Why resident will select this ${widget.pageType?.toLowerCase()} ?',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                TextFormField(
                  maxLines: 100,
                  minLines: 1,
                  // maxLines: 1,
                  controller: whySelect,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText:
                    'Enter why resident will select this ${widget.pageType?.toLowerCase()} ',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'More about this ${widget.pageType?.toLowerCase()}',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                TextFormField(
                  maxLines: 100,
                  minLines: 1,
                  // maxLines: 1,
                  controller: moreAbout,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText:
                    'Enter More about  ${widget.pageType?.toLowerCase()}',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Residency leaving policy *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                TextFormField(
                  maxLines: 100,
                  minLines: 1,
                  controller: leavingPolicy,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Enter residency leaving policy',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    fillColor: Colors.black12,
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Facilities *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 0.8,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('Select a facilities',
                              style: Sty().mediumText.copyWith(fontSize: 15)),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          children: selectedList2.map((item) {
                            bool isSelected2 =
                            facility2.contains(item['facility']);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected2) {
                                    facility2.remove(item['facility']);
                                  } else {
                                    facility2.add(item['facility']);
                                  }
                                  print('gdvhdhsdhsd${facility2}');
                                });
                              },
                              child: Card(
                                elevation: 1,
                                color: isSelected2
                                    ? Color(0xfffaedb9)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey.withOpacity(0.1)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['facility'],
                                    style: TextStyle(
                                      color: isSelected2
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          focusNode: _focusNode2,
                          // onEditingComplete: () {
                          //   _addItem2();
                          // },
                          onChanged: (value) {
                            setState(() {
                              _showMessage2 =
                              false; // Hide the message when the user starts typing.
                            });
                          },
                          controller: _facilityController2,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "More facilities",
                            hintStyle: TextStyle(fontSize: 13),
                            border: InputBorder.none,
                            fillColor: Colors.black12,
                            filled: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                _addItem2();
                              },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ),
                        ),
                        if (_showMessage2) SizedBox(height: 8),
                        if (_showMessage2)
                          Text(
                            'Add as many facilities as you want and then select them ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Clr().errorRed,
                              // fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Text(
                  'Rules & Restriction *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 0.8,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('Select a rules and restrictions',
                              style: Sty().mediumText.copyWith(fontSize: 15)),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          // runAlignment: WrapAlignment.center,
                          direction: Axis.horizontal,
                          children: selectedList.map((item) {
                            bool isSelected = rule.contains(item['rule']);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    rule.remove(item['rule']);
                                  } else {
                                    rule.add(item['rule']);
                                  }
                                  print('gdvhdhsdhsd${rule}');
                                });
                              },
                              child: Card(
                                elevation: 1,
                                color: isSelected
                                    ? Color(0xfffaedb9)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey.withOpacity(0.1)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['rule'],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          focusNode: _focusNode,
                          // onEditingComplete: () {
                          //    _addItem();
                          //   // Trigger the API call when editing is complete
                          // },
                          onChanged: (value) {
                            setState(() {
                              _showMessage =
                              false; // Hide the message when the user starts typing.
                            });
                          },
                          // onTapOutside: (event){
                          //   FocusManager.instance.primaryFocus?.unfocus();
                          // },
                          controller: _ruleController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "More rule's and restrictions",
                            hintStyle: TextStyle(fontSize: 13),
                            border: InputBorder.none,
                            fillColor: Colors.black12,
                            filled: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                _addItem();
                              },
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ),
                        ),
                        if (_showMessage) SizedBox(height: 8),
                        if (_showMessage)
                          Text(
                            'Add as many rules and restriction as you want and then select them',
                            style: TextStyle(
                              fontSize: 14,
                              color: Clr().errorRed,
                              // fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30.0),

                // SizedBox(height: 20),
                Text(
                  'Images: *',
                  style: Sty()
                      .mediumText
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Text(
                    'For best uploading of Residency images, keep its aspect ratio to 9:16',
                    style: Sty().mediumText.copyWith(fontSize: 12)),

                // imagePicker(),
                // (croppedFiles.length == 0)
                //     ? Text("")
                //     : Text("Images: " + '${croppedFiles.length}'),

                imagePicker(),
                (resultList.length == 0)
                    ? Text("")
                    : Text(
                  "Current Image",
                  style: Sty().mediumText.copyWith(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                (resultList.length == 0)
                    ? Text("")
                    : SizedBox(
                  height: 80,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: resultList.length,
                    scrollDirection: Axis.horizontal,
                    // itemExtent: 100,
                    itemBuilder: (context, index) {
                      var v = resultList[index];
                      return Stack(children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(v,
                                  width: 65,
                                  fit: BoxFit.fill,
                                  height: 60)),
                        ),
                        Positioned(
                          top: -3,
                          left: 60,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // _currentTabIndex = 1;
                                resultList.removeAt(index);
                              });
                            },
                            child: Image.asset(
                              'assets/cutimages.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ]);
                    },
                  ),
                ),

                if (isThisForUpdate!)
                  Text(
                    "Old Image",
                    style: Sty().mediumText.copyWith(
                      fontSize: 14,
                    ),
                  ),
                if (isThisForUpdate!)
                  SizedBox(
                    height: 10,
                  ),
                if (isThisForUpdate!)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < imageList.length; i++)
                          InkWell(
                            onTap: () {
                              print(imageList[i][1].toString());
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: Text('Delete image?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            SharedPreferences sp =
                                            await SharedPreferences
                                                .getInstance();
                                            var dio = Dio();
                                            var formData = FormData.fromMap({
                                              'id': imageList[i][1].toString()
                                            });
                                            var response = await dio.post(
                                                deleteImageUrl(),
                                                data: formData);
                                            var res = response.data;
                                            print(res);
                                            getAndUpdateImagesOnly();
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
                            },
                            child: Stack(children: [
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                      imageUrl: imageList[i][0].toString(),
                                      width: 65,
                                      fit: BoxFit.fill,
                                      height: 60),
                                ),
                              ),
                              Positioned(
                                top: -3,
                                left: 60,
                                child: Image.asset(
                                  'assets/cutimages.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ]),
                          )
                      ],
                    ),
                  ),
                // Column(
                //   children: imagesList,
                // ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(onPressed: (){
                //     addImageWidget();
                //   }, child: Text("Add image")),
                // ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(onPressed: (){
                //     setAllStates();
                //   }, child: Text("set state")),
                // ),

                SizedBox(
                  height: 10,
                ),
                Center(
                  child: SizedBox(
                    height: 40,
                    width: 180,
                    child: loaded
                        ? ElevatedButton(
                      style: Sty().primaryButton.copyWith(
                        shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                      onPressed: () {
                       if(formkey.currentState!.validate()){
                         for(int a = 0; a < diffChargList.length; a++){
                           int position = diffChargList[a]['index'];
                           changeList.add({
                             "type": actionList[position],
                             "charge": priceCtrl[position].text,
                             "description": descripCtrl[position].text,
                           });
                         }
                         print(changeList);
                         var aa;
                         _otherCtrl.text.isNotEmpty
                             ? aa = [
                           {
                             "type": _otherCtrl.text,
                             "charge": _otherValue.text,
                             "description": _otherCharge.text,
                           }
                         ]
                             : Container();
                         aa != null
                             ? changeList.addAll(aa)
                             : Container();
                         print('type of residence: ${widget.pageType}');
                         if (isLength(leavingPolicy.text, 1)) {
                           if (isLength(hostelName.text, 1)) {
                             print("HOSTEL NAME OK");
                             if (isLength(hostelAddress.text, 1)) {
                               print("HOSTEL ADDRESS OK");
                               if (selectedValue != null) {
                                 print("SELECT LOCATION OK");
                                 if (latitude.isNotEmpty &&
                                     longitude.isNotEmpty) {
                                   print("LAT LONG OK");
                                   if (isLength(ownerName.text, 1)) {
                                     print("OWNER NAME OK");
                                     if (isLength(ownerNumber.text, 10)) {
                                       print("OWNER NUMBER OK");
                                       if (isLength(
                                           alternateNumber.text, 10) ||
                                           alternateNumber.text.isEmpty) {
                                         print("ALTERNATE NUMBER OK");
                                         if (isEmail(email.text) ||
                                             email.text.isEmpty) {
                                           print("EMAIL OK");
                                           if (isLength(
                                               telephoneNumber.text,
                                               10) ||
                                               telephoneNumber
                                                   .text.isEmpty) {
                                             print("TELEPHONE NUMBER OK");
                                             if (sGender.isNotEmpty) {
                                               print(
                                                   "GENDER (sGender) OK");
                                               if (isLength(
                                                   vacancyInNumber.text,
                                                   1)) {
                                                 print(
                                                     "VACANCY IN NUMBER OK");
                                                 if (actionList
                                                     .isNotEmpty) {
                                                   print(
                                                       "CHARGE (sAction) OK");
                                                   if (sTime.isNotEmpty) {
                                                     print(
                                                         "GATE CLOSE (sTime) OK");
                                                     if (monthlyCharge.text
                                                         .isNotEmpty) {
                                                       print(
                                                           "MONTHLY CHARGE OK");
                                                       if (facility2
                                                           .isNotEmpty) {
                                                         print(
                                                             "FACILITY OK");
                                                         if (rule
                                                             .isNotEmpty) {
                                                           print(
                                                               "CONDITIONS OK");
                                                           if (croppedFiles
                                                               .length >
                                                               0 ||
                                                               isThisForUpdate!) {
                                                             print(
                                                                 "PERFECT!");
                                                             if (isThisForUpdate !=
                                                                 null &&
                                                                 isThisForUpdate !=
                                                                     true) {
                                                               addHostel(
                                                                   hostelName
                                                                       .text
                                                                       .toString(),
                                                                   hostelAddress
                                                                       .text
                                                                       .toString(),
                                                                   selectedValue
                                                                       .toString(),
                                                                   ownerName
                                                                       .text
                                                                       .toString(),
                                                                   ownerNumber
                                                                       .text
                                                                       .toString(),
                                                                   alternateNumber
                                                                       .text
                                                                       .toString(),
                                                                   email
                                                                       .text
                                                                       .toString(),
                                                                   telephoneNumber
                                                                       .text
                                                                       .toString(),
                                                                   sGender
                                                                       .toString(),
                                                                   vacancyInNumber
                                                                       .text
                                                                       .toString(),
                                                                   sAction
                                                                       .toString(),
                                                                   sTime
                                                                       .toString(),
                                                                   monthlyCharge
                                                                       .text
                                                                       .toString(),
                                                                   // facility.text
                                                                   //     .toString(),
                                                                   // conditions
                                                                   //     .text
                                                                   //     .toString(),
                                                                   latitude
                                                                       .toString(),
                                                                   longitude
                                                                       .toString());
                                                             } else {
                                                               updateHostel(
                                                                   hostelName
                                                                       .text
                                                                       .toString(),
                                                                   hostelAddress
                                                                       .text
                                                                       .toString(),
                                                                   selectedValue
                                                                       .toString(),
                                                                   ownerName
                                                                       .text
                                                                       .toString(),
                                                                   ownerNumber
                                                                       .text
                                                                       .toString(),
                                                                   alternateNumber
                                                                       .text
                                                                       .toString(),
                                                                   email
                                                                       .text
                                                                       .toString(),
                                                                   telephoneNumber
                                                                       .text
                                                                       .toString(),
                                                                   sGender
                                                                       .toString(),
                                                                   vacancyInNumber
                                                                       .text
                                                                       .toString(),
                                                                   sAction
                                                                       .toString(),
                                                                   sTime
                                                                       .toString(),
                                                                   monthlyCharge
                                                                       .text
                                                                       .toString(),
                                                                   facility
                                                                       .text
                                                                       .toString(),
                                                                   conditions
                                                                       .text
                                                                       .toString(),
                                                                   latitude
                                                                       .toString(),
                                                                   longitude
                                                                       .toString());
                                                             }
                                                           } else {
                                                             showDialog(
                                                               context:
                                                               context,
                                                               builder:
                                                                   (BuildContext
                                                               context) {
                                                                 return AlertDialog(
                                                                   title:
                                                                   Text(
                                                                     "Error",
                                                                     style:
                                                                     TextStyle(color: Colors.red),
                                                                   ),
                                                                   content:
                                                                   Text("Please add at least one image."),
                                                                   actions: [
                                                                     TextButton(
                                                                         onPressed: () => Navigator.pop(context),
                                                                         child: Text("OK")),
                                                                   ],
                                                                 );
                                                               },
                                                             );
                                                           }
                                                         } else {
                                                           showDialog(
                                                             context:
                                                             context,
                                                             builder:
                                                                 (BuildContext
                                                             context) {
                                                               return AlertDialog(
                                                                 title:
                                                                 Text(
                                                                   "Error",
                                                                   style: TextStyle(
                                                                       color:
                                                                       Colors.red),
                                                                 ),
                                                                 content: Text(
                                                                     "Please enter a condition."),
                                                                 actions: [
                                                                   TextButton(
                                                                       onPressed: () =>
                                                                           Navigator.pop(context),
                                                                       child: Text("OK")),
                                                                 ],
                                                               );
                                                             },
                                                           );
                                                         }
                                                       } else {
                                                         showDialog(
                                                           context:
                                                           context,
                                                           builder:
                                                               (BuildContext
                                                           context) {
                                                             return AlertDialog(
                                                               title: Text(
                                                                 "Error",
                                                                 style: TextStyle(
                                                                     color:
                                                                     Colors.red),
                                                               ),
                                                               content: Text(
                                                                   "Please enter a facility."),
                                                               actions: [
                                                                 TextButton(
                                                                     onPressed: () => Navigator.pop(
                                                                         context),
                                                                     child:
                                                                     Text("OK")),
                                                               ],
                                                             );
                                                           },
                                                         );
                                                       }
                                                     } else {
                                                       showDialog(
                                                         context: context,
                                                         builder:
                                                             (BuildContext
                                                         context) {
                                                           return AlertDialog(
                                                             title: Text(
                                                               "Error",
                                                               style: TextStyle(
                                                                   color: Colors
                                                                       .red),
                                                             ),
                                                             content: Text(
                                                                 "Please enter monthly charges."),
                                                             actions: [
                                                               TextButton(
                                                                   onPressed: () =>
                                                                       Navigator.pop(
                                                                           context),
                                                                   child: Text(
                                                                       "OK")),
                                                             ],
                                                           );
                                                         },
                                                       );
                                                     }
                                                   } else {
                                                     showDialog(
                                                       context: context,
                                                       builder:
                                                           (BuildContext
                                                       context) {
                                                         return AlertDialog(
                                                           title: Text(
                                                             "Error",
                                                             style: TextStyle(
                                                                 color: Colors
                                                                     .red),
                                                           ),
                                                           content: Text(
                                                               "Please enter gate closing time."),
                                                           actions: [
                                                             TextButton(
                                                                 onPressed: () =>
                                                                     Navigator.pop(
                                                                         context),
                                                                 child: Text(
                                                                     "OK")),
                                                           ],
                                                         );
                                                       },
                                                     );
                                                   }
                                                 } else {
                                                   showDialog(
                                                     context: context,
                                                     builder: (BuildContext
                                                     context) {
                                                       return AlertDialog(
                                                         title: Text(
                                                           "Error",
                                                           style: TextStyle(
                                                               color: Colors
                                                                   .red),
                                                         ),
                                                         content: Text(
                                                             "Please select charges."),
                                                         actions: [
                                                           TextButton(
                                                               onPressed: () =>
                                                                   Navigator.pop(
                                                                       context),
                                                               child: Text(
                                                                   "OK")),
                                                         ],
                                                       );
                                                     },
                                                   );
                                                 }
                                               } else {
                                                 showDialog(
                                                   context: context,
                                                   builder: (BuildContext
                                                   context) {
                                                     return AlertDialog(
                                                       title: Text(
                                                         "Error",
                                                         style: TextStyle(
                                                             color: Colors
                                                                 .red),
                                                       ),
                                                       content: Text(
                                                           "Please enter vacancy."),
                                                       actions: [
                                                         TextButton(
                                                             onPressed: () =>
                                                                 Navigator.pop(
                                                                     context),
                                                             child: Text(
                                                                 "OK")),
                                                       ],
                                                     );
                                                   },
                                                 );
                                               }
                                             } else {
                                               showDialog(
                                                 context: context,
                                                 builder: (BuildContext
                                                 context) {
                                                   return AlertDialog(
                                                     title: Text(
                                                       "Error",
                                                       style: TextStyle(
                                                           color:
                                                           Colors.red),
                                                     ),
                                                     content: Text(
                                                         "Please select a type."),
                                                     actions: [
                                                       TextButton(
                                                           onPressed: () =>
                                                               Navigator.pop(
                                                                   context),
                                                           child:
                                                           Text("OK")),
                                                     ],
                                                   );
                                                 },
                                               );
                                             }
                                           } else {
                                             showDialog(
                                               context: context,
                                               builder:
                                                   (BuildContext context) {
                                                 return AlertDialog(
                                                   title: Text(
                                                     "Error",
                                                     style: TextStyle(
                                                         color:
                                                         Colors.red),
                                                   ),
                                                   content: Text(
                                                       "Please enter a valid telephone number."),
                                                   actions: [
                                                     TextButton(
                                                         onPressed: () =>
                                                             Navigator.pop(
                                                                 context),
                                                         child:
                                                         Text("OK")),
                                                   ],
                                                 );
                                               },
                                             );
                                           }
                                         } else {
                                           showDialog(
                                             context: context,
                                             builder:
                                                 (BuildContext context) {
                                               return AlertDialog(
                                                 title: Text(
                                                   "Error",
                                                   style: TextStyle(
                                                       color: Colors.red),
                                                 ),
                                                 content: Text(
                                                     "Please enter a valid email."),
                                                 actions: [
                                                   TextButton(
                                                       onPressed: () =>
                                                           Navigator.pop(
                                                               context),
                                                       child: Text("OK")),
                                                 ],
                                               );
                                             },
                                           );
                                         }
                                       } else {
                                         showDialog(
                                           context: context,
                                           builder:
                                               (BuildContext context) {
                                             return AlertDialog(
                                               title: Text(
                                                 "Error",
                                                 style: TextStyle(
                                                     color: Colors.red),
                                               ),
                                               content: Text(
                                                   "Please enter a valid whatsapp number."),
                                               actions: [
                                                 TextButton(
                                                     onPressed: () =>
                                                         Navigator.pop(
                                                             context),
                                                     child: Text("OK")),
                                               ],
                                             );
                                           },
                                         );
                                       }
                                     } else {
                                       showDialog(
                                         context: context,
                                         builder: (BuildContext context) {
                                           return AlertDialog(
                                             title: Text(
                                               "Error",
                                               style: TextStyle(
                                                   color: Colors.red),
                                             ),
                                             content: Text(
                                                 "Please enter a valid owner number."),
                                             actions: [
                                               TextButton(
                                                   onPressed: () =>
                                                       Navigator.pop(
                                                           context),
                                                   child: Text("OK")),
                                             ],
                                           );
                                         },
                                       );
                                     }
                                   } else {
                                     showDialog(
                                       context: context,
                                       builder: (BuildContext context) {
                                         return AlertDialog(
                                           title: Text(
                                             "Error",
                                             style: TextStyle(
                                                 color: Colors.red),
                                           ),
                                           content: Text(
                                               "Please enter owner name."),
                                           actions: [
                                             TextButton(
                                                 onPressed: () =>
                                                     Navigator.pop(
                                                         context),
                                                 child: Text("OK")),
                                           ],
                                         );
                                       },
                                     );
                                   }
                                 } else {
                                   showDialog(
                                     context: context,
                                     builder: (BuildContext context) {
                                       return AlertDialog(
                                         title: Text(
                                           "Error",
                                           style: TextStyle(
                                               color: Colors.red),
                                         ),
                                         content: Text(
                                             "Please capture your location."),
                                         actions: [
                                           TextButton(
                                               onPressed: () =>
                                                   Navigator.pop(context),
                                               child: Text("OK")),
                                         ],
                                       );
                                     },
                                   );
                                 }
                               } else {
                                 showDialog(
                                   context: context,
                                   builder: (BuildContext context) {
                                     return AlertDialog(
                                       title: Text(
                                         "Error",
                                         style:
                                         TextStyle(color: Colors.red),
                                       ),
                                       content:
                                       Text("Please set a location."),
                                       actions: [
                                         TextButton(
                                             onPressed: () =>
                                                 Navigator.pop(context),
                                             child: Text("OK")),
                                       ],
                                     );
                                   },
                                 );
                               }
                             } else {
                               showDialog(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return AlertDialog(
                                     title: Text(
                                       "Error",
                                       style: TextStyle(color: Colors.red),
                                     ),
                                     content: Text(
                                         "Please enter hostel address."),
                                     actions: [
                                       TextButton(
                                           onPressed: () =>
                                               Navigator.pop(context),
                                           child: Text("OK")),
                                     ],
                                   );
                                 },
                               );
                             }
                           } else {
                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Text(
                                     "Error",
                                     style: TextStyle(color: Colors.red),
                                   ),
                                   content:
                                   Text("Please enter hostel name."),
                                   actions: [
                                     TextButton(
                                         onPressed: () =>
                                             Navigator.pop(context),
                                         child: Text("OK")),
                                   ],
                                 );
                               },
                             );
                           }
                         } else {
                           showDialog(
                             context: context,
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 title: Text(
                                   "Error",
                                   style: TextStyle(color: Colors.red),
                                 ),
                                 content:
                                 Text("Please enter leaving policy."),
                                 actions: [
                                   TextButton(
                                       onPressed: () =>
                                           Navigator.pop(context),
                                       child: Text("OK")),
                                 ],
                               );
                             },
                           );
                         }
                       }else{
                         controller.jumpTo(1000.0);
                       }
                      },
                      child: Text(
                        'SUBMIT',
                        style: Sty().mediumText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validatoeForm(index) {
    bool check = formkey.currentState!.validate();
    if (priceCtrl[index].text.isEmpty) {
      setState(() {
        positions = index;
        priceValue.add('This Field is required');
        check = false;
      });
    } else {
      setState(() {
        positions = index;
        priceValue.add('This Field is required');
        check = true;
      });
    }
    if (descripCtrl[index].text.isEmpty) {
      setState(() {
        positions = index;
        descriValue.add('');
        check = false;
      });
    } else {
      setState(() {
        positions = index;
        descriValue.add('');
        check = true;
      });
    }
    if (check) {
      if (diffChargList
          .map((e) => e['type'].toString())
          .contains(actionList[index].toString())) {
        setState(() {
          int position = diffChargList.indexWhere((element) =>
          element['type'].toString() == actionList[index].toString());
          diffChargList.removeAt(position);
        });
      } else {
        setState(() {
          diffChargList.add({
            "type": actionList[index],
            "charge": priceCtrl[index].text,
            "description": descripCtrl[index].text,
          });
        });
        print(diffChargList);
      }
    }
  }

  Future<void> permissionHandle() async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getcurrentLocation();
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      STM().displayToast('Location permission is required');
      await Geolocator.openAppSettings();
    }
  }

  // getLocation
  getcurrentLocation() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    LocationPermission permission = await Geolocator.requestPermission();
    dialog = STM().loadingDialog(ctx, 'Fetch location');
    dialog!.show();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        STM().displayToast('Current location is selected');
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        setState(() {
          locationCapText =
              "latitude: " + latitude + "\n" + "longitude: " + longitude;
        });
        dialog!.dismiss();
      });
    }).catchError((e) {
      dialog!.dismiss();
    });
  }

  void getReview() async {
    var result = await STM().get(
      ctx,
      Str().loading,
      'rules',
    );
    setState(() {
      ruleslists = result['rules'];
      newpageType = widget.pageType;
    });
    selectedList.clear();
    for (int a = 0; a < result['rules'].length; a++) {
      setState(() {
        selectedList.add({
          'rule': result['rules'][a]['rule'],
        });
      });
    }
    print(selectedList);
  }

  void getfacilities() async {
    var result = await STM().get(
      ctx,
      Str().loading,
      'facilities',
    );
    setState(() {
      facilitylists = result['facilities'];
    });
    selectedList2.clear();
    for (int a = 0; a < result['facilities'].length; a++) {
      setState(() {
        selectedList2.add({
          'facility': result['facilities'][a]['facility'],
        });
      });
    }
    print(selectedList2);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textEditingController2.dispose();
    _ruleController.dispose();
    _facilityController2.dispose();
    super.dispose();
  }
}
