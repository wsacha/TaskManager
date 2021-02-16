import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/utils/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_manager/utils/sharedpreferences.dart';
import 'package:task_manager/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await UserPreferenceFunctions.getUserLoggedInSharedPreference();
  String userName = await UserPreferenceFunctions.getUserNameSharedPreference();
  String userEmail = await UserPreferenceFunctions.getUserEmailSharedPreference();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserDataModel(userName, userEmail),
    ),
    ChangeNotifierProvider(
      create: (context) => RoomModel(),
    )
  ], child: MyApp(isLoggedIn)));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp(this.isLoggedIn);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool isUserLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'My Task Manager App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xff145C9E),
          scaffoldBackgroundColor: Color(0xff1F1F1F),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: widget.isLoggedIn != null
          ? widget.isLoggedIn
              ? HomeRoom()
              : Authenticate()
          : Authenticate(),
    );
  }
}
