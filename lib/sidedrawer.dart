import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/sign_in.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'abouus.dart';
import 'contact.dart';
import 'manage/static_method.dart';
import 'my_residency.dart';
import 'values/colors.dart';

Widget navbar(context, key,owner,userdata) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        if (key.currentState.isDrawerOpen) {
          key.currentState.openEndDrawer();
        }
        return true;
      },
      child: Drawer(
        width: 300,
        backgroundColor: Clr().white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Dim().d32),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),

                // decoration: BoxDecoration(color: Color(0xffFF6363)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/profilenew.svg',height: Dim().d52,width:  Dim().d52),
                  title:  Text(
                    // 'Username',
                    userdata != null ? '${userdata['name']}':'',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle:  Text(
                    userdata != null ? '${userdata['phone']}':'',
                    // '+91 7028297606',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),

                ),
              ),
              // SizedBox(height: Dim().d12),
              Divider(color: Colors.black,),
              if( owner == '2' ) SizedBox(height: Dim().d36),

            if( owner == '2' )  Text('Are you residency owner?',
                  style: Sty().mediumBoldText.copyWith(
                      fontWeight: FontWeight.w600, fontSize: Dim().d20)),
              SizedBox(height: Dim().d12),
              owner == '2' ? Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFF6363)),
                child: ListTile(
                      visualDensity: VisualDensity(horizontal: -4, vertical: -0),
                  // tileColor: Colors.red,
                  leading:  Image.asset('assets/bulding.png',height: 30,width: 30,color: Clr().primaryColor),
                  title: const Text(
                    'List your residency',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: const Text(
                      'Register your flat, PG flat, hostel, PG room and non cot-base room here',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  onTap: () {
                    STM().redirect2page(context, MyResidency());
                    close(key);
                  },
                ),
              ): Container(),
              SizedBox(height: Dim().d36),

              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('About Application',
                      style: Sty().mediumBoldText.copyWith(
                          fontWeight: FontWeight.w600, fontSize: Dim().d20)),
                ),
              ),
              SizedBox(height: Dim().d2),
              // Image.asset(
              //   'assets/logo.png',
              //   height: Dim().d250,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              // ),

              // owner == '2' ?  Container(
              //   margin: const EdgeInsets.only(right: 20, left: 20),
              //   // decoration: BoxDecoration(color: Color(0xffABE68C)),
              //   child: ListTile(
              //     leading: SvgPicture.asset(
              //       'assets/myhotels.svg',
              //     ),
              //     title: const Text(
              //       'My Hostel',
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 16,
              //           fontWeight: FontWeight.w400),
              //     ),
              //     onTap: () {
              //       STM().redirect2page(context, MyHostel());
              //       close(key);
              //     },
              //   ),
              // ) : Container(),
              SizedBox(
                height: 0,
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFF6363)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/privacy.svg'),
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    STM().openWeb("https://resieasy.com/privacy_policy");
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFAB400)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/terms.svg'),
                  title: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                   STM().openWeb("https://resieasy.com/terms_conditions");
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFAB400)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/share.svg'),
                  title: Text('Share App',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    var message = 'Download The ResiEasy App from below link\n\nhttps://play.google.com/store/apps/details?id=com.app.quick_room_services';
                    Share.share(message);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffFAB400)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/aboutus.svg'),
                  title: Text(
                    'About Us',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    STM().redirect2page(context, AboutUs());
                    close(key);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffE683F0)),
                child: ListTile(
                  leading: Icon(
                    Icons.call, color: Color(0xff21488C), size: Dim().d28,),
                  title: const Text(
                    'Contact Us',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    // var message =
                    //     'Download The Arham App from below link\n\n https://play.google.com/store/apps/details?id=org.arhamparivar.arhamparivar';
                    // Share.share(message);
                    STM().redirect2page(context, ContactUs());
                    close(key);
                  },
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                // decoration: BoxDecoration(color: Color(0xffF1B382)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/logout.svg'),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dim().d12)),
                        insetPadding: EdgeInsets.symmetric(horizontal: Dim().d16),
                        title: Image.asset('assets/exit.jpg',height: Dim().d220,width: Dim().d350),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: InkWell(onTap: (){
                                  STM().back2Previous(context);
                                },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dim().d12),
                                        border: Border.all(color: Clr().primaryColor)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: Dim().d12),
                                      child: Center(
                                        child: Text('Cancel',style: Sty().mediumText.copyWith(color: Clr().primaryColor)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: Dim().d12),
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dim().d12),
                                        border: Border.all(color: Clr().primaryColor)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: Dim().d12),
                                      child: Center(
                                        child: Text('ok',style: Sty().mediumText.copyWith(color: Clr().primaryColor)),
                                      ),
                                    ),
                                  ),
                                  onTap: ()async{
                                    SharedPreferences sp = await SharedPreferences.getInstance();
                                    sp.clear();
                                    STM().finishAffinity(context, SignIn());
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dim().d20,
                          ),
                        ],
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void close(key) {
  key.currentState.openEndDrawer();
}