import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtpl/const/const.dart';
import 'package:gtpl/provider/login.dart';
import 'package:gtpl/query/broadband/sent_otp_broadband.dart';
import 'package:gtpl/query/sent_otp.dart';
import 'package:gtpl/view/home.dart';
import 'package:gtpl/view/login/components/dropdown.dart';
import 'package:gtpl/view/login/verify.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController stbController = TextEditingController();
  final _secureStorage = FlutterSecureStorage();
  Future storeUserId() async {
    await _secureStorage.write(key: "user", value: stbController.text);
  }

  @override
  // ignore: must_call_super
  void initState() {
    storeUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const Home();
                }));
              },
              child: Text(
                'Skip',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
        leading: BackButton(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            'Welcome Back',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Login with your STB Number Or You can use your User Id or Phone Number or Customer Number',
            style: TextStyle(
              color: greycolor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Choose your Service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: DropdownLogin(),
                      ),
                    ),
                  ]),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Provider.of<LoginProvider>(context, listen: true).selectedValue ==
                  "Cable"
              ? Column(
                  children: [
                    TextField(
                      controller: stbController,
                      decoration: InputDecoration(
                        hintText: 'Enter Your STB Number',
                        hintStyle: TextStyle(
                          color: greycolor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                )
              : Provider.of<LoginProvider>(context, listen: true)
                          .selectedValue ==
                      "Broadband"
                  ? TextField(
                      controller: stbController,
                      decoration: InputDecoration(
                        hintText:
                            'Enter Your User ID or Phone Number or Customer Number',
                        hintStyle: TextStyle(color: greycolor, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  : Container()
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 2),
        ], color: Colors.white),
        child: InkWell(
          onTap: () {
            context.loaderOverlay.show();

            if (Provider.of<LoginProvider>(context, listen: false)
                    .selectedValue ==
                "Cable") {
              sentOtp(context, stbController.text).then((value) {
                context.loaderOverlay.hide();

                if (value!.status == 200) {
                  print(value.otp!);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyScreen(
                        userid: stbController.text,
                        isBroadband: false,
                        customerNo: value.cUSTOMERNO!,
                        phone: value.module!,
                        otp: value.otp!,
                      ),
                    ),
                  );
                } else {
                  context.loaderOverlay.hide();

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Check STB Number'),
                      actions: [
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  );
                }
              });
            } else {
              sentOtpBroadband(context, stbController.text).then((value) {
                context.loaderOverlay.hide();

                if (value!.status == 200) {
                  print(value.otp!);
                  print(value.userId);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyScreen(
                        userid: stbController.text,
                        isBroadband: true,
                        customerNo: value.userId!,
                        phone: value.mobile!,
                        otp: value.otp!,
                      ),
                    ),
                  );
                } else {
                  context.loaderOverlay.hide();

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Check User Id'),
                      actions: [
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  );
                }
              });
            }
            storeUserId();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: const Center(
              child: Text(
                "Request for OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
