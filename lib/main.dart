import 'package:class_resources/pages/auth/add-courses.dart';
import 'package:class_resources/pages/auth/create-course.dart';
import 'package:class_resources/pages/menu/privacy-policy.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './themes.dart';
import './pages/dashboard.dart';
import './pages/welcome.dart';
import './pages/auth/signup.dart';
import './pages/auth/login.dart';
import './pages/auth/update-profile.dart';
import 'pages/menu/license.dart';

void main() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? "";
    return runApp(AppMain(uid: uid));
  } catch (_) {
    return runApp(AppMain(uid: ""));
  }
}

class AppMain extends StatelessWidget {
  AppMain({@required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {

    //Using Future References to avoid Re-instantiation on any event (i.e. Keyboard Popup)
    final updateProfile = UpdateProfile(),
        welcomePage = WelcomePage(),
        signupPage = SignupPage(),
        loginPage = LoginPage(),
        dashboard = Dashboard(),
        addCourses = AddCourses(),
        createCourse = CreateCourse(),
        appLicensePage = AppLicensePage(),
        privacyPolicyPage = PrivacyPolicyPage();

    return MaterialApp(
      title: 'Class Resources',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      routes: {
        '/': (ctx) => this.uid == "" ? WelcomePage() : Dashboard(),
        '/welcome': (ctx) => welcomePage,
        '/dashboard': (ctx) => dashboard,
        '/signup': (ctx) => signupPage,
        '/login': (ctx) => loginPage,
        '/edit-profile': (ctx) => updateProfile,
        '/add-course': (ctx) => addCourses,
        '/create-course': (ctx) => createCourse,
        '/license': (ctx) => appLicensePage,
        '/privacypolicy': (ctx) => privacyPolicyPage
      },
    );
  }
}
