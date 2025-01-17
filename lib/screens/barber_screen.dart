import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:siravarmi/widgets/comments_list_item.dart';
import 'package:siravarmi/widgets/selected_service_popup_screen.dart';
import 'package:siravarmi/widgets/slidingUpPanels/barber_slidingUpPanel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cloud_functions/dbHelperHttp.dart';
import '../models/assessment_model.dart';
import '../models/barber_model.dart';
import '../routes/hero_dialog_route.dart';
import '../utilities/consts.dart';
import '../utilities/custom_rect_tween.dart';

class BarberScreen extends StatefulWidget {
  BarberModel barberModel;
  BarberScreen({required this.barberModel, Key? key}) : super(key: key);

  @override
  State<BarberScreen> createState() => _BarberScreenState();
}

class _BarberScreenState extends State<BarberScreen> {
  final String lat = '25.421';
  final String lon = '32.412';
  Uri? googleMapsUrl;
  Uri? appleMapsUrl;
  Future<void>? _launched;

  Future<void> _launchMap(Uri url) async {
    if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
    ))
    /*if(!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    ))*/
    {
      throw 'Could not launch URL';
    }
  }

  double profileHeigt = getSize(300);

  final String phoneNumber = "0 (850) 442 15 22";

  String shopTime = "08.00 - 17.00";

  PageController pageController = PageController(initialPage: 0);

  final panelController = PanelController();

  late final ScrollController controller;

  final double right1 = getSize(211),
      right2 = getSize(115),
      right3 = 0,
      left1 = 0,
      left2 = getSize(111),
      left3 = getSize(205);

  double left = 0, right = getSize(211);

  double daysSize = getSize(16);

  double smallContainerWidthSize = getSize(120);
  double bigContainerWidthSize = getSize(332);
  double containerHeightSize = getSize(30);
  double inContainerSize = getSize(14);

  Color serviceColor = Colors.white,
      infosColor = primaryColor,
      commentsColor = primaryColor;

  List<AssessmentModel> assessments = [];

  @override
  void initState() {
    googleMapsUrl = Uri.parse("https://www.google.com/maps/place/Lumen+Field/@47.5951518,-122.3316394,17z");
    loadAssessments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Sira Var Mi"),
        ),
        body: frontBody(context));
  }

  frontBody(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.barberModel.profileURL),
                  fit: BoxFit.cover)),
          height: profileHeigt,
          width: screenWidth,
          child: IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // BURAYA FONKSİYON EKLENİCEK
            },
            padding: EdgeInsets.only(left: getSize(378), bottom: getSize(265)),
            iconSize: getSize(30),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(getSize(100)),
                topLeft: Radius.circular(getSize(100))),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
          margin: EdgeInsets.only(
              top: getSize(265),
              bottom: getSize(470),
              left: getSize(60),
              right: getSize(60)),
          child: SizedBox(
            child: AutoSizeText(
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.fade,
              maxLines: 1,
              widget.barberModel.name,
              style: TextStyle(
                color: primaryColor,
                fontSize: getSize(34),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: getSize(270), left: getSize(344)),
          height: getSize(25),
          width: getSize(70),
          child: Row(
            children: [
              Container(
                width: getSize(18),
                height: getSize(18),
                child: SvgPicture.string(
                  '<svg viewBox="194.0 149.0 35.0 35.0" ><path transform="translate(194.0, 149.0)" d="M 16.55211448669434 2.820034503936768 C 16.85749244689941 1.911513090133667 18.14250755310059 1.911513090133667 18.4478874206543 2.820034503936768 L 21.65240097045898 12.35370826721191 C 21.78610229492188 12.75147819519043 22.1539249420166 13.02346038818359 22.57341384887695 13.03473949432373 L 32.28314971923828 13.2957706451416 C 33.21295166015625 13.32076740264893 33.60798263549805 14.49047565460205 32.88371658325195 15.07407760620117 L 25.09336853027344 21.35141181945801 C 24.78136444091797 21.60282135009766 24.6495532989502 22.01619529724121 24.75843238830566 22.40180778503418 L 27.53403663635254 32.23200225830078 C 27.79165267944336 33.14437866210938 26.75349426269531 33.86965179443359 25.98543548583984 33.31387710571289 L 18.08622741699219 27.59795761108398 C 17.73640060424805 27.34482002258301 17.26360130310059 27.34482002258301 16.91377258300781 27.59795761108398 L 9.014564514160156 33.31387710571289 C 8.246504783630371 33.86965179443359 7.208349227905273 33.14437866210938 7.465964317321777 32.23200225830078 L 10.24156761169434 22.40180778503418 C 10.35044765472412 22.01619529724121 10.21863651275635 21.60282135009766 9.906631469726562 21.35141181945801 L 2.116285085678101 15.0740795135498 C 1.392019271850586 14.49047660827637 1.787049174308777 13.32076835632324 2.716848611831665 13.29577255249023 L 12.42658805847168 13.03474140167236 C 12.84607601165771 13.02346420288086 13.21389961242676 12.75148105621338 13.34760093688965 12.35371112823486 Z" fill="#002964" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  allowDrawingOutsideViewBox: true,
                ),
              ),

              /*Pin(size: screenWidth!*50/designWidth, end: 4.0),
                      Pin(size: screenWidth!*15/designWidth, start: 1.0),*/
              Container(
                margin: EdgeInsets.only(left: getSize(2)),
                alignment: Alignment.center,
                height: getSize(25),
                width: getSize(45),
                child: Text(
                  "${widget.barberModel.averageStars} (${widget.barberModel.assessmentCount})",
                  style: TextStyle(
                    fontSize: getSize(11),
                    color: primaryColor,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.center,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: getSize(335), left: getSize(45), right: getSize(45)),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(getSize(25))),
                border: Border.all(color: Colors.transparent)),
            child: Stack(
              children: [
                Positioned(
                  left: left,
                  right: right,
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(getSize(25))),
                    ),
                    height: getSize(48),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius:
                            BorderRadius.all(Radius.circular(getSize(25))),
                      ),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(getSize(18))),
                            )),
                        child: Text(
                          "HİZMETLER",
                          style: TextStyle(
                              color: serviceColor, fontSize: getSize(13)),
                        ),
                        onPressed: () {
                          pageController.animateToPage(0,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.ease);
                          _toggleFirst();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.transparent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(getSize(18))),
                          ),
                        ),
                        child: Text(
                          "BİLGİLER",
                          style: TextStyle(
                              color: infosColor, fontSize: getSize(13)),
                        ),
                        onPressed: () {
                          pageController.animateToPage(1,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.ease);
                          _toggleSecond();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(getSize(18))),
                            )),
                        child: Text(
                          "YORUMLAR",
                          style: TextStyle(
                              color: commentsColor, fontSize: getSize(13)),
                        ),
                        onPressed: () {
                          pageController.animateToPage(2,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.ease);
                          _toggleThird();
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: getSize(410),
              left: getSize(40),
              right: getSize(40),
              bottom: getSize(60)),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              Container(
                height: getSize(50),
                width: getSize(50),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) => Card(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: getSize(15)),
                    child: Container(
                      padding: EdgeInsets.only(),
                      decoration: BoxDecoration(border: Border.all()),
                      child: EntryItem(
                        data[index],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: getSize(50),
                width: getSize(50),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        height: getSize(24),
                        width: getSize(332),
                        decoration: BoxDecoration(color: bgColor),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: getSize(5)),
                        child: Text(
                          "Adres Bilgisi",
                          style: TextStyle(
                              fontSize: getSize(18), color: primaryColor),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: EdgeInsets.only(bottom: getSize(153)),
                          margin: EdgeInsets.only(top: getSize(24)),
                          child: SizedBox(
                            child: Icon(Icons.map, size: getSize(30)),
                            height: getSize(40),
                            width: getSize(42),
                          )),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        padding:
                            EdgeInsets.only(top: getSize(2), left: getSize(10)),
                        margin: EdgeInsets.only(
                            top: getSize(24), left: getSize(42)),
                        width: getSize(292),
                        height: getSize(195),
                        child: AutoSizeText(
                          widget.barberModel.address,
                          maxLines: 4,
                          style: TextStyle(fontSize: inContainerSize),
                        ),
                      ),
                      Container(
                        height: getSize(40),
                        width: getSize(250),
                        margin: EdgeInsets.only(
                            top: getSize(112), left: getSize(41)),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.lightGreen,
                              side: BorderSide(color: Colors.transparent)),
                          child: Text(
                            "Haritada Göster",
                            style: TextStyle(
                                fontSize: getSize(16), color: Colors.white),
                          ),
                          onPressed: () => setState(() {
                            _launched = _launchMap(googleMapsUrl!);
                          }),
                        ),
                      ),
                      Container(
                        height: getSize(40),
                        width: getSize(250),
                        margin: EdgeInsets.only(
                            top: getSize(165), left: getSize(41)),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              side: BorderSide(color: Colors.transparent)),
                          child: Text(
                            phoneNumber,
                            style: TextStyle(
                                fontSize: getSize(16), color: Colors.white),
                          ),
                          onPressed: () async {
                            FlutterPhoneDirectCaller.callNumber(phoneNumber);
                          },
                        ),
                      ),
                      Container(
                        height: getSize(24),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(color: bgColor),
                        margin: EdgeInsets.only(top: getSize(219)),
                        padding: EdgeInsets.only(left: getSize(5)),
                        child: Text(
                          "Çalışma Saatleri",
                          style: TextStyle(
                              fontSize: getSize(18), color: primaryColor),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: getSize(243)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                            ),
                            height: containerHeightSize,
                            width: bigContainerWidthSize,
                            child: Text(
                              "Pazartesi:",
                              style: TextStyle(fontSize: daysSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getSize(243), left: getSize(232)),
                            alignment: Alignment.center,
                            height: containerHeightSize,
                            width: smallContainerWidthSize,
                            child: Text(
                              shopTime,
                              style: TextStyle(fontSize: inContainerSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: getSize(273)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            height: containerHeightSize,
                            width: bigContainerWidthSize,
                            child: Text(
                              "Salı:",
                              style: TextStyle(fontSize: daysSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getSize(273), left: getSize(232)),
                            alignment: Alignment.center,
                            height: containerHeightSize,
                            width: smallContainerWidthSize,
                            child: Text(
                              shopTime,
                              style: TextStyle(fontSize: inContainerSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: getSize(303)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            height: containerHeightSize,
                            width: bigContainerWidthSize,
                            child: Text(
                              "Çarşamba:",
                              style: TextStyle(fontSize: daysSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getSize(303), left: getSize(232)),
                            alignment: Alignment.center,
                            height: containerHeightSize,
                            width: smallContainerWidthSize,
                            child: Text(
                              shopTime,
                              style: TextStyle(fontSize: inContainerSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: getSize(333)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            height: containerHeightSize,
                            width: bigContainerWidthSize,
                            child: Text(
                              "Perşembe:",
                              style: TextStyle(fontSize: daysSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getSize(333), left: getSize(232)),
                            alignment: Alignment.center,
                            height: containerHeightSize,
                            width: smallContainerWidthSize,
                            child: Text(
                              shopTime,
                              style: TextStyle(fontSize: inContainerSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: getSize(363)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            height: containerHeightSize,
                            width: bigContainerWidthSize,
                            child: Text(
                              "Cuma:",
                              style: TextStyle(fontSize: daysSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getSize(363), left: getSize(232)),
                            alignment: Alignment.center,
                            height: containerHeightSize,
                            width: smallContainerWidthSize,
                            child: Text(
                              shopTime,
                              style: TextStyle(fontSize: inContainerSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: getSize(393)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            height: containerHeightSize,
                            width: bigContainerWidthSize,
                            child: Text(
                              "Cumartesi:",
                              style: TextStyle(fontSize: daysSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getSize(393), left: getSize(232)),
                            alignment: Alignment.center,
                            height: containerHeightSize,
                            width: smallContainerWidthSize,
                            child: Text(
                              shopTime,
                              style: TextStyle(fontSize: inContainerSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: getSize(423)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            height: containerHeightSize,
                            width: bigContainerWidthSize,
                            child: Text(
                              "Pazar:",
                              style: TextStyle(fontSize: daysSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: getSize(423), left: getSize(232)),
                            alignment: Alignment.center,
                            height: containerHeightSize,
                            width: smallContainerWidthSize,
                            child: Text(
                              shopTime,
                              style: TextStyle(fontSize: inContainerSize),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              ListView.builder(
                itemCount: assessments.length,
                itemBuilder: (context, index) {
                  return CommentsListItem(
                    assessment: assessments[index],
                  );
                },
              )
            ],
          ),
        ),
        Container(
          color: primaryColor,
          width: screenWidth,
          height: getSize(50),
          margin: EdgeInsets.only(top: getSize(screenHeight! - 130)),
          child: Row(
            children: [
              Hero(
                tag: _heroselectedService,
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin!, end: end!);
                },
                child: Container(
                    color: primaryColor,
                    margin: EdgeInsets.only(left: getSize(22)),
                    child: TextButton(
                      child: Text(
                          style: TextStyle(
                              color: Colors.white, fontSize: getSize(16)),
                          "x Hizmet Seçili"),
                      onPressed: () {
                        selectedServiceBtnClicked(context);
                      },
                    )),
              ),
              Container(
                margin: EdgeInsets.only(left: getSize(104)),
                child: TextButton(
                    child: Text(
                      "Randevu Al >",
                      style: TextStyle(
                          color: secondaryColor, fontSize: getSize(16)),
                    ),
                    onPressed: () {
                      appointmentBtnClicked();
                    }),
              )
            ],
          ),
        ),
        SlidingUpPanel(
          backdropEnabled: true,
          minHeight: 0,
          maxHeight: getSize(250),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getSize(15)),
              topRight: Radius.circular(getSize(15))),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: getSize(5),
              blurRadius: getSize(10),
            )
          ],
          controller: panelController,
          padding: EdgeInsets.only(
              left: getSize(20), right: getSize(20), top: getSize(20)),
          panelBuilder: (builder) => BarberSlidingUpPanel(),
          footer: Padding(
            padding: EdgeInsets.only(left: getSize(180)),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => primaryColor),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => secondaryColor.withOpacity(0.2))),
              onPressed: () {},
              child: Text(
                "Randevu olustur",
                style: TextStyle(
                  fontSize: getSize(18),
                  fontFamily: secondaryFontFamily,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void appointmentBtnClicked() {
    if (panelController.isPanelClosed) {
      panelController.open();
    }
  }

  Future<void> selectedServiceBtnClicked(BuildContext context) async {
    final result =
        await Navigator.push(context, HeroDialogRoute(builder: (context) {
      return SelectedServicePopupScreen();
    }));
  }

  void _toggleFirst() {
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      left = left1;
      right = right1;
      serviceColor = Colors.white;
      infosColor = primaryColor;
      commentsColor = primaryColor;
      timer.cancel();
      setState(() {});
    });
  }

  void _toggleSecond() {
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      left = left2;
      right = right2;
      serviceColor = primaryColor;
      infosColor = Colors.white;
      commentsColor = primaryColor;
      timer.cancel();
      setState(() {});
    });
  }

  void _toggleThird() {
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      left = left3;
      right = right3;
      serviceColor = primaryColor;
      infosColor = primaryColor;
      commentsColor = Colors.white;
      timer.cancel();
      setState(() {});
    });
  }

  Future<void> loadAssessments() async {
    DbHelperHttp dbHelper = DbHelperHttp();
    final assessmentsData = dbHelper.getAssessmentList(widget.barberModel.id);
    var ass = await assessmentsData;

    for (int i = 0; i < ass.length; i++) {
      assessments.add(AssessmentModel(
        userId: int.parse(ass[i]["userId"]),
        barberId: int.parse(ass[i]["barberId"]),
        employeeId: int.parse(ass[i]["employeeId"]),
        id: int.parse(ass[i]["id"]),
        command: ass[i]['comment'],
        stars: int.parse(ass[i]['star']),
        userName: ass[i]['userName'],
        userSurname: ass[i]['userSurname'],
      ));
    }

    setState(() {
      assessments = assessments;
    });
  }
}

final String _heroselectedService = "selected-service-hero";

class Entry {
  late final String title;
  late final List<Entry> children;
  Entry(this.title, [this.children = const <Entry>[]]);
}

final List<Entry> data = <Entry>[
  Entry(
    'Cilt Bakım (KADIN)',
    <Entry>[
      Entry('Test 1'),
      Entry('Test 2'),
      Entry('Test 3'),
    ],
  ),
  // Second Bar
  Entry(
    'Saç (ERKEK)',
    <Entry>[
      Entry('Test 1'),
      Entry('Test 2'),
    ],
  ),
  //  Third Bar
  Entry(
    'Tırnak (ERKEK)',
    <Entry>[Entry('Test 1'), Entry('Test 2'), Entry('Test 3')],
  ),
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);
  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
