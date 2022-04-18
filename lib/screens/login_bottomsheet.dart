import 'package:flutter/material.dart';
import 'package:inventory_v1/constants.dart';
import 'landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_v1/widgets/toast.dart';

final _fireauth = FirebaseAuth.instance;
TextEditingController userIdController = TextEditingController();
bool loginFail = false;

Widget showEditableUserIDField(bool alreadyLoggedIn) {
  return TextField(
    maxLines: 1,
    onChanged: (value) {
      userIdController.text = value;
    },
    style: kAddProductTextFieldStyle,
    keyboardType: TextInputType.emailAddress,
    autofocus: alreadyLoggedIn == true ? false : true,
    decoration: InputDecoration(
      errorText: loginFail ? 'Please check the UserId' : null,
      errorBorder: kAddProductTextFieldErrorBorder,
      filled: true,
      fillColor: Color(0xFFE2E3E3),
      labelText: 'User ID',
      labelStyle: kAddProductTextFieldLableStyle,
      contentPadding: EdgeInsets.all(10),
      border: kAddProductTextFieldBorder,
      focusedBorder: loginFail == false
          ? kAddProductTextFieldFocusedBorder
          : kAddProductTextFieldErrorBorder,
    ),
  );
}

Widget showNonEditableUserIDField(String emailId) {
  return Text(
    'User ID: ' + emailId,
    style: TextStyle(
      color: Colors.black,
    ),
  );
}

class LoginBottomsheet extends StatefulWidget {
  final String emailId;
  final String password;
  final bool alreadyLoggedIn;

  LoginBottomsheet({
    this.emailId,
    this.password,
    this.alreadyLoggedIn,
  });

  @override
  _LoginBottomsheetState createState() => _LoginBottomsheetState();
}

class _LoginBottomsheetState extends State<LoginBottomsheet> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userIdController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: userIdController.text.length,
      ),
    );
    passwordController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: passwordController.text.length,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: kbottomSheetBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      padding: EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please enter the registered User ID and Password to login. If not registered please Contact Us',
              style: TextStyle(color: kCardColor, fontSize: 12),
            ),
            SizedBox(
              height: 15,
            ),
            widget.alreadyLoggedIn == false
                ? showEditableUserIDField(widget.alreadyLoggedIn)
                : showNonEditableUserIDField(widget.emailId),
            SizedBox(
              height: 15,
            ),
            TextField(
              maxLines: 1,
              onChanged: (value) {
                passwordController.text = value;
              },
              style: kAddProductTextFieldStyle,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              autofocus: widget.alreadyLoggedIn == true ? true : false,
              decoration: InputDecoration(
                errorText: loginFail ? 'Please check the password' : null,
                errorBorder: kAddProductTextFieldErrorBorder,
                filled: true,
                fillColor: Color(0xFFE2E3E3),
                labelText: 'Password',
                labelStyle: kAddProductTextFieldLableStyle,
                contentPadding: EdgeInsets.all(10),
                border: kAddProductTextFieldBorder,
                focusedBorder: loginFail == false
                    ? kAddProductTextFieldFocusedBorder
                    : kAddProductTextFieldErrorBorder,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 50,
              elevation: 8,
              child: Text(
                'LOGIN',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                ShowingToast(context: context).showLoginToast(
                  "Logging in...",
                );
                try {
                  final loginUser = await _fireauth.signInWithEmailAndPassword(
                    email: widget.alreadyLoggedIn == true
                        ? widget.emailId
                        : userIdController.text,
                    password: passwordController.text,
                  );
                  if (loginUser != null) {
                    setState(() {
                      loginFail = false;
                    });

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('alreadyLoggedIn', true);
                    widget.alreadyLoggedIn == true
                        ? prefs.setString('emailId', widget.emailId)
                        : prefs.setString('emailId', userIdController.text);
                    prefs.setString('password', passwordController.text);

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LandingScreen().id,
                      (r) => false,
                    );
                  }
                } catch (e) {
                  setState(() {
                    loginFail = true;
                  });
                }
              },
              color: kCardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
