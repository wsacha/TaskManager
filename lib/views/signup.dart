import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/auth.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/utils/sharedpreferences.dart';
import 'package:task_manager/views/home.dart';
import 'package:task_manager/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  var message;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController userEmailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signUserUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      message = await checkIfNameOrEmailAlreadyInUse();
      if (message == false) {
        await authMethods
            .signUpWithEmailAndPassword(
                userEmailTextEditingController.text, passwordTextEditingController.text)
            .then((result) {
          if (result != null) {
            Map<String, String> userInfoMap = {
              "name": userNameTextEditingController.text,
              "email": userEmailTextEditingController.text
            };

            databaseMethods.uploadUserInfo(userInfoMap);

            UserPreferenceFunctions.saveUserLoggedInSharedPreference(true);
            UserPreferenceFunctions.saveUserNameSharedPreference(
                userNameTextEditingController.text);
            UserPreferenceFunctions.saveUserEmailSharedPreference(
                userEmailTextEditingController.text);

            var state = Provider.of<UserDataModel>(context, listen: false);
            state.userName = userNameTextEditingController.text;
            state.userEmail = userEmailTextEditingController.text;

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRoom()));
          }
        });
      } else {
        setState(() {
          isLoading = false;
          message = message;
        });
      }
    }
  }

  checkIfNameOrEmailAlreadyInUse() async {
    QuerySnapshot checkExistingData =
        await databaseMethods.getUserByUserName(userNameTextEditingController.text);
    if (checkExistingData.docs.isNotEmpty) {
      return "Username already exists";
    }
    checkExistingData =
        await databaseMethods.getUserByUserEmail(userEmailTextEditingController.text);
    if (checkExistingData.docs.isNotEmpty) {
      return "Email already exists";
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarScreens(context, 'Sign up'),
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
                            SizedBox(
                              height: 24,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (val) {
                                      return val.isEmpty || val.length < 4
                                          ? "Please provide a valid username"
                                          : null;
                                    },
                                    controller: userNameTextEditingController,
                                    style: simpleTextStyle(),
                                    decoration: textFieldInputDecoration('username'),
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                    controller: userEmailTextEditingController,
                                    style: simpleTextStyle(),
                                    decoration: textFieldInputDecoration('email'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    validator: (val) {
                                      return val.length > 6
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
                                await signUserUp();
                                if (!isLoading) {
                                  Scaffold.of(context).showSnackBar(snackBarInfo(message));
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
                                  'Sign up',
                                  style: mediumTextStyle(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have account? ",
                                  style: mediumTextStyle(),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggle();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'Sign in now',
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
