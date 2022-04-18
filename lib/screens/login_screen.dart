import 'package:flutter/material.dart';
import 'package:inventory_v1/constants.dart';
import 'login_bottomsheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_v1/controller/firebase_networks.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

bool alreadyLoggedIn;
String emailId;
String password;

class LoginScreen extends StatefulWidget {
  final String id = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

Future onLoginPressed() async {
  await getSizesFromFireBase();
  final prefs = await SharedPreferences.getInstance();
  alreadyLoggedIn = prefs.getBool('alreadyLoggedIn') ?? false;
  emailId = prefs.getString('emailId') ?? '';
  password = prefs.getString('password') ?? '';
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool showLoading = false;
  AnimationController cogAnimationController;
  AnimationController cog1AnimationController;
  @override
  void initState() {
    super.initState();
    cogAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    cog1AnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    cogAnimationController.repeat();
    cog1AnimationController.repeat();

    // hammerAnimationController.addListener(() {
    //   setState(() {
    //     if (hammerAnimationController.isCompleted) {
    //       hammerAnimationController.reverse().whenComplete(
    //             () => hammerAnimationController.forward(),
    //           );
    //     }
    //   });
    // });

    cogAnimationController.addListener(() {
      setState(() {});
    });
    cog1AnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    cogAnimationController.dispose();
    cog1AnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showLoading,
        opacity: 0.1,
        progressIndicator: CircularProgressIndicator(
          color: Colors.white,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: CustomPaint(
            painter: BottomCurvePainter(),
            child: CustomPaint(
              painter: CurvePainter(),
              child: Stack(
                children: [
                  Center(
                    child: Image(
                      image: AssetImage('images/Logo.PNG'),
                      width: 280,
                      height: 280,
                    ),
                  ),
                  // Center(
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.white,
                  //     radius: 110,
                  //   ),
                  // ),
                  // Center(
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.red,
                  //     radius: 104,
                  //   ),
                  // ),
                  // Center(
                  //   child: Container(
                  //     width: 220,
                  //     color: Colors.white,
                  //     child: Text(
                  //       'LMNS',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         letterSpacing: 10,
                  //         color: Colors.red,
                  //         fontSize: 59,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      width: 150,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 7),
                      child: MaterialButton(
                        elevation: 8,
                        child: Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          setState(() => showLoading = true);
                          await onLoginPressed();
                          setState(() => showLoading = false);
                          showModalBottomSheet(
                            backgroundColor: Colors.black.withOpacity(0.0),
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: LoginBottomsheet(
                                  alreadyLoggedIn: alreadyLoggedIn,
                                  emailId: emailId,
                                  password: password,
                                ),
                              ),
                            ),
                          );
                        },
                        color: kCardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 20),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'CONTACT US',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.copyright,
                            color: Colors.grey,
                            size: 13,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Anto App Solutions',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width * 0.3,
                    top: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                        alignment: Alignment.center,
                        angle: cog1AnimationController.value,
                        child: FaIcon(
                          FontAwesomeIcons.cog,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width * 0.4,
                    top: MediaQuery.of(context).size.width * 0.23,
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                        alignment: Alignment.center,
                        angle: -cog1AnimationController.value,
                        child: FaIcon(
                          FontAwesomeIcons.cog,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width * 0.2,
                    top: MediaQuery.of(context).size.width * 0.23,
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                        alignment: Alignment.center,
                        angle: -cog1AnimationController.value,
                        child: FaIcon(
                          FontAwesomeIcons.cog,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width * 1.5,
                    top: -MediaQuery.of(context).size.height * 0.02,
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                        alignment: Alignment.center,
                        angle: -(3.14 / 4),
                        child: Transform.rotate(
                          angle: (3.14),
                          child: FaIcon(
                            FontAwesomeIcons.wrench,
                            size: 55,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width * 1.8,
                    top: -MediaQuery.of(context).size.height * 0.06,
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                        alignment: Alignment.bottomRight,
                        angle: -(3.14 / 4),
                        child: Transform.rotate(
                          angle: (3.14),
                          child: FaIcon(
                            FontAwesomeIcons.screwdriver,
                            size: 75,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width * 2,
                    top: MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                        alignment: Alignment.center,
                        angle: cogAnimationController.value,
                        child: FaIcon(
                          FontAwesomeIcons.cog,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = kCardColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(
      0,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(
      size.width,
      0,
    );
    path.lineTo(
      0,
      0,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color(0000212338),
          Color(0xFF112338),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            size.width / 2,
            size.height / 2,
          ),
          radius: 500,
        ),
      );
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(
      0,
      size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.6,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(
      size.width,
      0,
    );
    path.lineTo(
      0,
      0,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
