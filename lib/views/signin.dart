import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/auth.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/utils/sharedpreferences.dart';
import 'package:task_manager/views/home.dart';
import 'package:task_manager/widgets/widget.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;

  signUserIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(
              emailTextEditingController.text, passwordTextEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot snapshotUserInfo =
              await databaseMethods.getUserByUserEmail(emailTextEditingController.text);

          UserPreferenceFunctions.saveUserLoggedInSharedPreference(true);
          UserPreferenceFunctions.saveUserNameSharedPreference(
              snapshotUserInfo.docs[0].data()["name"]);
          UserPreferenceFunctions.saveUserEmailSharedPreference(
              snapshotUserInfo.docs[0].data()["email"]);

          var state = Provider.of<UserDataModel>(context, listen: false);
          state.userName = snapshotUserInfo.docs[0].data()["name"].toString();
          state.userEmail = snapshotUserInfo.docs[0].data()["email"].toString();

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarScreens(context, 'Sign in'),
        body: Builder(
          builder: (BuildContext context) {
            return isLoading
                ? Center(child: Container(child: CircularProgressIndicator()))
                : SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 24,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return RegExp(
                                                  // ignore: valid_regexps
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)
                                          ? null
                                          : "Please provide a valid e-mail";
                                    },
                                    controller: emailTextEditingController,
                                    style: simpleTextStyle(),
                                    decoration: textFieldInputDecoration('email'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    validator: (val) {
                                      return val.length >= 6
                                          ? null
                                          : "Password must have at least 6 characters";
                                    },
                                    controller: passwordTextEditingController,
                                    style: simpleTextStyle(),
                                    decoration: textFieldInputDecoration('password'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await signUserIn();
                                if (!isLoading) {
                                  Scaffold.of(context).showSnackBar(snackBarInfo("Invalid data"));
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [const Color(0xff007EF4), const Color(0xff2A75BC)]),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  'Sign in',
                                  style: mediumTextStyle(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have account? ",
                                  style: mediumTextStyle(),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggle();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'Register now',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ));
  }
}
