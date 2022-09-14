import 'package:flutter/material.dart';
import 'package:gtpl/provider/home.dart';
import 'package:gtpl/query/const.dart';
import 'package:gtpl/query/get_broad_details.dart';
import 'package:gtpl/query/global_handler.dart';
import 'package:gtpl/view/home/components/broadband.dart';
import 'package:gtpl/view/home/components/ticket.dart';
import 'package:gtpl/view/login/login.dart';
import 'package:gtpl/view/quick_pay/quick_pay.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? accountNotFound;
  bool? accountBroadbandNotFound;
  // GetUserDetailsModel? dsValue;
  GetBroadbandDetailsModel? dsBroadband;
  @override
  void initState() {
    GlobalHandler.getBroadbandNo().then((value) async {
      // print(value == null);
      if (value != null) {
        setState(() {
          accountBroadbandNotFound = true;
        });
        var getId = await GlobalHandler.getBroadbandNo();
        getBroadbandUserDetails(context, getId!).then((value) {
          setState(() {
            dsBroadband = value;
          });
        });
      } else {
        setState(() {
          accountBroadbandNotFound = false;
        });
      }
      print(dsBroadband);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return accountBroadbandNotFound == false
        ? Scaffold(
            appBar: AppBar(
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 2,
              leading: BackButton(
                color: Colors.black,
              ),
            ),
            body: Center(
                child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                width: 250,
                height: 50,
                child: const Center(
                  child: Text(
                    'Login Now',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )))
        : dsBroadband == null
            ? Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 7, bottom: 7),
                    child: InkWell(
                      onTap: () {
                        Provider.of<HomeProvider>(context, listen: false)
                            .chnageScreen(3);
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png'),
                        radius: 10,
                      ),
                    ),
                  ),
                  // actions: [
                  //   IconButton(
                  //     icon: Icon(Icons.notifications_none),
                  //     onPressed: () {},
                  //   ),
                  //   IconButton(
                  //     icon: Icon(Icons.search),
                  //     onPressed: () {},
                  //   ),
                  // ],
                  backgroundColor: primaryColor,
                  elevation: 0,
                  title: InkWell(
                    onTap: () {
                      Provider.of<HomeProvider>(context, listen: false)
                          .chnageScreen(3);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Hii, ${dsBroadband!.resultUserDetail!.name}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              Text(
                                'User Id: ${dsBroadband!.resultUserDetail!.userId}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFEFEFEF)),
                              )
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text('Hii, Priya',
                        //           style: TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w600,
                        //               color: Colors.white)),
                        //       Text(
                        //         'Subscriber Id:252621',
                        //         style: TextStyle(
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.w400,
                        //             color: Color(0xFFEFEFEF)),
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                body: ListView(children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height:
                                320 - MediaQuery.of(context).viewPadding.top,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                      // Broadband Account
                      BroadbandCard(
                        dsBroadband: dsBroadband,
                      )
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Offers for you',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF41444B),
                              ),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF41444B),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 120,
                          child: PageView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.only(right: 10, left: 8),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    // yaha pr radis add hua h all
                                    borderRadius: BorderRadius.circular(10)),

                                //deco
                                //borderrud-circl
                              );
                            },
                          ),
                        ),
// size chnge
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            'Searching the perfect plan? ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Make your own custom plan ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: greyColor,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Center(
                          child: Card(
                            elevation: 3,
                            color: primaryColor,
                            child: InkWell(
                              onTap: () {
                                Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .chnageScreen(2);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Text(
                                  "Explore plans".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //tect

                        //text
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Tickets',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF41444B),
                              ),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF41444B),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Ticket()
                      ],
                    ),
                  ),
                  //
                ]));
  }
}
