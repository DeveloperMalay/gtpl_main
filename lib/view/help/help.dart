import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtpl/api_layer/networking.dart';
import 'package:gtpl/api_layer/questionData.dart';
import 'package:gtpl/query/const.dart';
import 'package:gtpl/query/get_broad_details.dart';
import 'package:gtpl/query/global_handler.dart';
import 'package:gtpl/view/help/components/past_ticket.dart';
import 'package:gtpl/view/login/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

enum WidgetMarker {
  issue,
  raiseTicket,
  cableQuestions,
  equipmentQuestions,
  digitalQuestions,
  hdtvQuestions,
  parentalcontrolQuestions,
  smartfeaturesQuestions,
}

//questions item model
class Item {
  final String questionTitle;
  final String questionAnswer;
  Item({
    required this.questionTitle,
    required this.questionAnswer,
  });
}

class Help extends StatefulWidget {
  Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  //the question and their titles are store here
  List<Item> items = [
    Item(
        questionTitle:
            'Where Can I Find A List Of Channels Available In My Area?',
        questionAnswer:
            'Answer: You can find a complete listing of all channels offered in your area here.'),
    Item(
        questionTitle:
            'You can find a complete listing of all channels offered in your area here.',
        questionAnswer:
            'Answer: If your remote control is not working, first check and replace the batteries. If this does not solve your problem, the remote control may need to be reprogrammed. To reprogram your remote control, click here. If this does not work, call us at 033-66 000 000 to get a replacement remote.'),
    Item(
        questionTitle:
            'What Can I Do If My Remote No Longer Turns On My TV Or Adjusts Volume',
        questionAnswer:
            'Answer: The remote may need to be reprogrammed for your specific television set. If your remote is not listed, or if you need assistance, please contact Customer Service at 033-66 000 000 Set top box Remote Learning:- 1. Press and hold SET Key on the Set Top box remote control for 3 seconds, the red light indicator on the top left corner of the remote will get darker thus entering the learning mode. 2. Press the key you want to assign to the set top box remote the red light indicator will start flickering, this means the remote is now ready to learn from the other remote control (TV Remote). 3. Hold the TV remote control, aim at the Set top box remote from a distance of 3 to 5 cm, press the button you want to be replicated on the TV remote control. 4. On pressing this button, the Indicator light on the top left will flicker three times, this indicates the button has been assigned a function. 5. You can now select other keys which are to be assigned functions from the TV remote control. 6. After completion of the process, press SET key on the set top box remote control to exit learning status, this will lead to the indicator light on the top left to turn off. 7. You can now use the same remote for both your TV and Set top box. Use these steps everywhere when it talks about reprogramming of remotes. Further in areas where steps have been provided in FAQ please remove the ans on top and arrange the steps in proper layout. The information provided on the STB page at the bottom is not at all professional please provide the information in a professional way and do not use those colourful boxes. The broadband page is too wordy and the representation of the content is very boring and discourages people to go through it, please rearrange the page such that is looks neat and people click to see what they want to instead of being exposed to so much info at once .'),
    Item(
        questionTitle: 'Why Does My HDTV Say ‘Weak Or NO Signal’?',
        questionAnswer:
            'Answer: Newer HD television sets have many input options. More than likely, your TV is simply on the wrong input to receive the signal from our cable box. Make sure your GTPL KCBPL cable box is powered on, and use your TV remote to change inputs (for most HD TVs you have to choose HDMI 1 or HDMI 2 in which port you connect you STB).'),
    Item(
        questionTitle: 'What Is E-51 Error?',
        questionAnswer:
            'Answer: Post a month of subscription Set Top Box deletes the package by default. Upon renewal a new command is sent to the box which activates the package. If STB is switched off this command is not received & hence the package is not activated in spite of the command being transmitted How can consumers troubleshoot\?In case consumer does not receive picture, ensure pack is activated, keep STB switched on (around 10 mins) to receive the command & resume services or give a missed call to 033 6600 0099/033 4089 4646 from registered no.'),
  ];

  WidgetMarker selectedWidgetMarker = WidgetMarker.issue;
  int activeIndex = 0;

  final controller = CarouselController(); //controller for the carousel

  void animateToSlide(int index) => controller
      .animateToPage(index); // function to move the items on clicking the dots

  TextEditingController getTicketNumber = TextEditingController();
  TextEditingController getSubscriberNo = TextEditingController();
  TextEditingController getStbNo = TextEditingController();
  TextEditingController getIssueDesc = TextEditingController();
  TextEditingController getIssue = TextEditingController();

//questions and answers are save in this array
  List<Map<String, dynamic>> faqData = [];

  void clearText() {
    getIssueDesc.clear();
    getIssue.clear();
  }

//function to get the questions for different category
  void fliterQuestions(String categoryName) {
    List<Map<String, dynamic>> result = [];
    result = questions
        .where((data) => data['categoryName'].contains(categoryName))
        .toList();

    setState(() {
      faqData = result;
    });
  }

//function to get the current userID from sharedprefarance
  dynamic dsBroadband;
  bool? accountNotFound;
  bool? accountBroadbandNotFound;

  final _secureStorage = FlutterSecureStorage();

  var userId;
  void getuser() async {
    userId = await _secureStorage.read(key: "user");
  }

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
      faqData = questions;

      print(dsBroadband);
    });
    //postTicket("description", "issue type");

    getOperator();
    getToken();
    getuser();

    // Timer.periodic(Duration(milliseconds: 250), (timer) {
    //   fetchTicketData();
    // });

    super.initState();
  }

//the widget to show indecator dots
  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 7,
        onDotClicked: animateToSlide,
        effect: ScrollingDotsEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: primaryColor,
          dotColor: greyColor,
        ),
      );
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
                body: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            //MediaQ ka jo kaam h size ke sth kuch bhi kr skte h jo chahiye more importance for me this mediaQ.
                            height: MediaQuery.of(context).padding.top + 50,
                          ),
                          Text(
                            'HELLO',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'How can we help you?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(500, 30),
                          bottomRight: Radius.elliptical(500, 20),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF003A97),
                            Color(0xFF3B80CD),
                            Color(0xFF8CD0FD),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: _buildCustomContainer(),
                    ),
                  ],
                ),
              );
  }

//widget controller to control which widget to show+
  Widget _buildCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.issue:
        return _buildChooseIssue();
      case WidgetMarker.raiseTicket:
        return _buildRaiseTicket();
      case WidgetMarker.cableQuestions:
        return _buildQuestions('Cables');
      case WidgetMarker.equipmentQuestions:
        return _buildQuestions('Equipments');
      case WidgetMarker.digitalQuestions:
        return _buildQuestions('Digital');
      case WidgetMarker.hdtvQuestions:
        return _buildQuestions('HDTV');
      case WidgetMarker.parentalcontrolQuestions:
        return _buildQuestions('Parental Control');
      case WidgetMarker.smartfeaturesQuestions:
        return _buildQuestions('Smart Featured');
    }
  }

//choose Issue section widget  is here
  Widget _buildChooseIssue() {
    return Container(
      child: Column(children: [
        Center(
          child: Text(
            "FAQ's",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF003A97),
              ),
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  controller.previousPage();
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 105,
                  width: 290,
                  child: CarouselSlider(
                      carouselController: controller,
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index),
                      ),
                      items: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWidgetMarker =
                                  WidgetMarker.cableQuestions;
                            });
                            fliterQuestions('Cables');
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor:
                                    Color.fromARGB(255, 183, 218, 247),
                                child: Icon(
                                  Icons.cable_outlined,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Cables'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWidgetMarker =
                                  WidgetMarker.equipmentQuestions;
                            });
                            fliterQuestions('Equipment');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 218, 247),
                                  child: Icon(
                                    Icons.wifi_tethering,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Equipments'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWidgetMarker =
                                  WidgetMarker.digitalQuestions;
                            });
                            fliterQuestions('Digital');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 218, 247),
                                  child: Icon(
                                    Icons.four_k_outlined,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Digital'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWidgetMarker = WidgetMarker.hdtvQuestions;
                            });
                            fliterQuestions('HDTV');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 218, 247),
                                  child: Icon(
                                    Icons.hd_outlined,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('HDTV'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWidgetMarker =
                                  WidgetMarker.parentalcontrolQuestions;
                            });
                            fliterQuestions('Parental Control');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 218, 247),
                                  child: Icon(
                                    Icons.co_present_outlined,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Parental \n Control'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWidgetMarker =
                                  WidgetMarker.smartfeaturesQuestions;
                            });
                            fliterQuestions('Smart Feature');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 218, 247),
                                  child: Icon(
                                    Icons.computer_rounded,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Smart ',
                                ),
                                Text(
                                  'Featured',
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWidgetMarker = WidgetMarker.raiseTicket;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 218, 247),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 45,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Others'),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
                buildIndicator(),
              ],
            ),
            Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF003A97),
              ),
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  controller.nextPage();
                },
                icon: Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Not found answers for your Queries?',
                style: TextStyle(
                  fontSize: 14,
                  color: greyColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoButton(
                color: primaryColor,
                onPressed: () {
                  setState(() {
                    selectedWidgetMarker = WidgetMarker.raiseTicket;
                  });
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  child: Text(
                    'Raise a Ticket',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check ticket status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: getTicketNumber,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Ticket Number",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Card(
                  color: primaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Check Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  width: 226,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      'Subsciber Id: ${dsBroadband!.resultUserDetail!.userId}',
                      style: TextStyle(
                        fontSize: 13,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Your past tickets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: blackColor,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PastTickets(),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

// raised a ticket widget is here
  Widget _buildRaiseTicket() {
    //List of items in our dropdown menu
    // var issueCategory = [
    //   'Cables',
    //   'Equipments',
    //   'Digital',
    //   'HDTV',
    //   'Parental Control',
    //   'Smart Featured',
    //   'Others',
    // ];
    // Initial Selected Value
    //var _dropdownValue;

    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedWidgetMarker = WidgetMarker.issue;
                      });
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Text(
                    'Raise a Ticket',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextField(
                enabled: false,
                controller: getSubscriberNo,
                decoration: InputDecoration(
                  enabled: true,
                  hintText: userId,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Optional Only for Cable',
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: getStbNo,
                decoration: InputDecoration(
                  hintText: 'STB No.',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: getIssue,
                decoration: InputDecoration(
                  hintText: 'Write your Issue Type',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(5),
              //   width: 400,
              //   height: 60,
              //   child: DropdownButton<String>(
              //     enableFeedback: true,
              //     hint: Text('Choose your Issue'),
              //     isExpanded: true,
              //     value: _dropdownValue,
              //     items: issueCategory
              //         .map((String item) =>
              //             DropdownMenuItem(value: item, child: Text(item)))
              //         .toList(),
              //     onChanged: (String? d) {
              //       setState(() {
              //         _dropdownValue = d!;
              //         print(_dropdownValue);
              //       });
              //     },
              //   ),
              // ),
              SizedBox(height: 20),
              TextField(
                controller: getIssueDesc,
                maxLength: 250,
                decoration: InputDecoration(
                  hintText: 'Tell Us the reason (250 words)',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
        ),
        Center(
          child: CupertinoButton(
            color: primaryColor,
            onPressed: () {
              String desc = getIssueDesc.text;
              String issueType = getIssue.text;
              postTicket(desc, issueType);

              setState(() {
                selectedWidgetMarker = WidgetMarker.issue;
              });
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Text(
                        'Thank You, our team will get back to you within 48 hours',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
              clearText();
              fetchTicketData();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Your past tickets',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
          ),
        ),
        PastTickets()
      ],
    );
  }

  //widget to show the questions
  Widget _buildQuestions(String category) {
    return Column(
      children: [
        Center(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedWidgetMarker = WidgetMarker.issue;
                  });
                },
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(
                width: 80,
              ),
              Text(
                category,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ExpansionPanelList.radio(
            children: faqData
                .map(
                  (item) => ExpansionPanelRadio(
                    value: item['questionTitle'],
                    canTapOnHeader: true,
                    headerBuilder: (context, isExpanded) => ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item['questionTitle'],
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    body: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        item['questionAnswer'],
                        style: TextStyle(
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Center(
          child: Text(
            'Not found Answers for your Queries?',
            style: TextStyle(
              fontSize: 16,
              color: greyColor,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: CupertinoButton(
            color: primaryColor,
            onPressed: () {
              setState(
                () {
                  selectedWidgetMarker = WidgetMarker.raiseTicket;
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Text(
                'Raise a Ticket',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
