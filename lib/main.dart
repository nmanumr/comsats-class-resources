import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/pages/auth/change-email.dart';
import 'package:class_resources/pages/auth/change-pass.dart';
import 'package:class_resources/pages/auth/reset-pass.dart';
import 'package:class_resources/pages/menu/privacy-policy.dart';
import 'package:class_resources/pages/courses/add-courses.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './themes.dart';
import './pages/dashboard.dart';
import './pages/welcome.dart';
import './pages/auth/signup.dart';
import './pages/auth/login.dart';
import './pages/auth/update-profile.dart';
import 'pages/menu/license.dart';

void main() async {
  String uid = "";
  try {
    // to void "ServicesBinding.defaultBinaryMessenger was
    // accessed before the binding was initialized" error
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? "";
  } catch (_) {}

  return runApp(AppMain(uid));
}

class AppMain extends StatefulWidget {
  AppMain(this.uid);
  final String uid;

  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  UserModel user;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    user = UserModel(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) {
          return (brightness == Brightness.light)
              ? defaultTheme()
              : defaultDarkTheme();
        },
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Class Resources',
            theme: theme,
            routes: {
              '/': (ctx) => user.status == AccountStatus.LoggedOut
                  ? WelcomePage(user)
                  : Dashboard(user, observer),
              '/welcome': (ctx) => WelcomePage(user),
              '/dashboard': (ctx) => Dashboard(user, observer),
              '/signup': (ctx) => SignupPage(user),
              '/login': (ctx) => LoginPage(user, observer),
              '/resetpass': (ctx) => ResetPassPage(),
              '/changepass': (ctx) => ChangePass(user),
              '/changeEmail': (ctx) => ChangeEmail(user),
              '/create-profile': (ctx) => UpdateProfile(
                  navigateToDashboard: true, profile: user.profile),
              '/add-course': (ctx) => AddCourses(),
              '/license': (ctx) => AppLicensePage(),
              '/privacypolicy': (ctx) => PrivacyPolicyPage()
            },
            navigatorObservers: [observer],
          );
        });
  }
}
