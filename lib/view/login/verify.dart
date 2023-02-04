import 'package:flutter/material.dart';
import 'package:gtpl/api_layer/networking.dart';
import 'package:gtpl/const/const.dart';
import 'package:gtpl/query/broadband/sent_otp.dart';
import 'package:gtpl/query/const.dart';
import 'package:gtpl/query/global_handler.dart';
import 'package:gtpl/query/sent_otp.dart';
import 'package:gtpl/view/home.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';

class VerifyScreen extends StatefulWidget {
  final String userid;
  final bool isBroadband;
  final String customerNo;
  final String phone;
  final int otp;
  const VerifyScreen(
      {Key? key,
      required this.phone,
      required this.otp,
      required this.customerNo,
      required this.isBroadband,
      required this.userid})
      : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  OtpTimerButtonController controller = OtpTimerButtonController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  PinTheme? focusedPinTheme;
  PinTheme? submittedPinTheme;
  late int otp;
  @override
  void initState() {
    otp = widget.otp;
    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: Text(
              'Skip',
              style: TextStyle(color: Theme.of(context).primaryColor),
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
            'Verify Your Account',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Enter the OTP sent to your registered mobile number',
            style: TextStyle(
              color: greycolor,
              fontSize: 12,
            ),
          ),
          Text(
            '+91 ${widget.phone.replaceFirst(RegExp(r'\d{5}'), '*****')}',
            style: TextStyle(
              color: greycolor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Pinput(
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            validator: (s) {
              if (s == otp.toString()) {
                if (widget.isBroadband) {
                  print(widget.customerNo);
                  GlobalHandler.setBroadbandNo(widget.customerNo);
                  GlobalHandler.navigatorPushReplacement(context, Home());
                } else {
                  GlobalHandler.setCustomerNo(widget.customerNo);
                  GlobalHandler.navigatorPushReplacement(context, Home());
                }

                return null;
              } else {
                print('incorrect pin');
                return 'Pin is incorrect';
              }
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) => print(pin),
          ),
          SizedBox(
            height: 10,
          ),
          OtpTimerButton(
            controller: controller,
            onPressed: () {
              controller.startTimer();
              context.loaderOverlay.show();

              if (!widget.isBroadband) {
                sentOtp(context, widget.userid).then((value) {
                  context.loaderOverlay.hide();

                  if (value!.status == 200) {
                    otp = value.otp!;
                    print(value.otp!);
                    GlobalHandler.snackBar(
                        context: context,
                        isSuccess: true,
                        message: "OTP sent to your mobile number");
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
                sentOtpBroadband(context, widget.userid).then((value) {
                  context.loaderOverlay.hide();

                  if (value!.status == 200) {
                    print(value.otp!);
                    otp = value.otp!;
                    GlobalHandler.snackBar(
                        context: context,
                        isSuccess: true,
                        message: "OTP sent to your mobile number");
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
            },
            backgroundColor: primaryColor,
            text: Text('Resend OTP'),
            duration: 30,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 2),
        ], color: Colors.white),
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: const Center(
              child: Text(
                "Verify now",
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
