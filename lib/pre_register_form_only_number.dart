import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quick_room_services/home.dart';
import 'package:quick_room_services/manage/static_method.dart';
import 'package:quick_room_services/sign_in.dart';
import 'package:quick_room_services/values/colors.dart';
import 'package:quick_room_services/values/global_urls.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

import 'location.dart';
import 'otp_verification.dart';

class PreRegister extends StatefulWidget {
  @override
  State<PreRegister> createState() => _PreRegisterState();
}

class _PreRegisterState extends State<PreRegister> {
  late BuildContext ctx;
  TextEditingController number = TextEditingController();
  bool loaded = true;

  String? sDropdown;

  void signUpUser(String name, String number, String dropdownvalue) async {
    setState(() {
      loaded = false;
    });
    var dio = Dio();
    var formData = FormData.fromMap({
      'type': dropdownvalue.toString(),
      'name': name.toString(),
      'phone': number.toString(),
    });
    var response = await dio.post(signUpUrl(), data: formData);
    var res = response.data;
    print(res);
    setState(() {
      loaded = true;
    });

    if (res['error'] == false) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setBool("isLoggedIn", true);
      sp.setString("user_id", res['user']['id'].toString());
      sp.setString("user_type", res['user']['type'].toString());
      sp.setString("user_name", res['user']['name'].toString());
      sp.setString("user_phone", res['user']['phone'].toString());
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SelectLocation()));
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

  void checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // Do nothing
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(30),
            contentPadding: EdgeInsets.all(30),
            alignment: Alignment.center,
            children: [
              Icon(Icons.wifi_off, size: 100, color: Colors.blue,),
              SizedBox(height: 15,),
              Align(alignment: Alignment.center, child: Text("Connection Error", style: TextStyle(fontSize: 20))),
              SizedBox(height: 5,),
              Align(alignment: Alignment.center, child: Text("No internet connection found.", style: TextStyle(fontSize: 18))),
              SizedBox(height: 10,),
              Container(
                // margin: EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  
                  onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PreRegister()));
                }, child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(child: Center(child: Text("TRY AGAIN"))),
                    Icon(Icons.refresh)
                  ],),
                )),
              )
            ],
          );
        },
      );

      //  children: [
      //   Icon(Icons.wifi_off),
      //   Text("No internet connection!"),
      // ]);
    }
  }

  void initState(){
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.menu),
      //   title: Text('QRS'),
      //
      //   actions: [
      //     Padding(padding: EdgeInsets.only(right: 20.0),
      //       child: GestureDetector(
      //         onTap: () {},
      //         child: Icon(Icons.notifications),
      //       ),)
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Align(
                alignment: Alignment.center,
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Enter Your Number',
                  style: const TextStyle(
                    fontSize: 18,
                  )),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: number,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  // label: Text('Enter Your Number'),
                  hintText: "Enter Your Number",
                  counterText: "",

                  border: InputBorder.none,
                  fillColor: Colors.black12,
                  filled: true,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: loaded ? ElevatedButton(
                    child: const Text('Sign Up'),
                    onPressed: () async {
                        if (isLength(number.text, 10)) {
                            setState(() {
                              loaded = false;
                            });

                            var dio = Dio();
                            var formdata = FormData.fromMap({
                              "phone": number.text.toString(),
                              "page_type": "register"
                            });
                            print(formdata.fields);
                            final response =
                                await dio.post(sendOTP(), data: formdata);
                            var result = response.data;
                            print(result);
                            setState(() {
                              loaded = true;
                            });

                            if(result["error"] != true){
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          OTPVerificationScreen(
                                            mobileNumebr:
                                                number.text.toString(),
                                            name: "",
                                            email: "",
                                            companyName: "",
                                            otptype: "register",
                                            type: ""
                                          ))),
                                  (route) => false);
                            }
                            else{

                            }

                          } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error", style: TextStyle(color: Colors.red),),
                                  content: Text("Please enter a 10 digit number"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK")),
                                  ],
                                );
                              },
                            );
                        }
                      },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF21488c),
                      padding: const EdgeInsets.all(12),
                      minimumSize: const Size(150.0, 12.0),
                    ),
                  ) : CircularProgressIndicator(),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // STM().redirect2page(ctx, SignIn());
                    Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: Sty().smallText,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In',
                          style: Sty().smallText.copyWith(
                                color: Color(0xFF21488c),
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
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
